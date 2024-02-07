import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class JobsRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  JobsRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseStorage? firebaseStorage})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Stream<List<JobModel>> get getJobsStream {
    return _firebaseFirestore
        .collection('jobs')
        .orderBy('createdTimestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => JobModel.fromMap(doc.data())).toList());
  }

  Stream<List<JobModel>> get getEscalations {
    // Construct the first query for documents where flagCounter is greater than or equal to 3
    final stream1 = _firebaseFirestore
        .collection('jobs')
        .where('flagCounter', isGreaterThanOrEqualTo: 3)
        .snapshots();

    // Construct the second query for documents where jobStatus is onHold and holdTimeStamp is more than a day old
    final stream2 = _firebaseFirestore
        .collection('jobs')
        .where('status.status', isEqualTo: 'onHold')
        .where('holdTimestamp',
            isLessThan: DateTime.now()
                .subtract(const Duration(days: 1))
                .microsecondsSinceEpoch)
        .where('holdTimestamp', isNotEqualTo: 0)
        .snapshots();

    // Combine the latest emissions from both streams
    Stream<List<QuerySnapshot<Map<String, dynamic>>>> combinedStream =
        Rx.combineLatest2(stream1, stream2, (snapshot1, snapshot2) {
      return [snapshot1, snapshot2];
    });

    // Process the combined stream and return the result
    return combinedStream.map((snapshotsList) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> combinedDocs = [];
      for (var snapshot in snapshotsList) {
        combinedDocs.addAll(snapshot.docs);
      }
      return combinedDocs.map((doc) => JobModel.fromMap(doc.data())).toList();
    });

    // // Merge the two streams using rxdart's merge method
    // Stream<QuerySnapshot<Map<String, dynamic>>> mergedStream =
    //     Rx.merge([stream1, stream2]);

    // return mergedStream.map((snapshot) =>
    //     snapshot.docs.map((doc) => JobModel.fromMap(doc.data())).toList());
  }

  Stream<List<JobModel>> getUserJobsStream(String userId) {
    return _firebaseFirestore
        .collection('jobs')
        .where('assignedTechnicianId', isEqualTo: userId)
        .orderBy('assignedTimestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => JobModel.fromMap(doc.data())).toList());
  }

  Stream<JobModel> getCurrentJobStream(String jobId) {
    return _firebaseFirestore.collection('jobs').doc(jobId).snapshots().map(
        (doc) => doc.data() == null
            ? throw const SetFirebaseDataFailure()
            : JobModel.fromMap(doc.data()!));
  }

  Future<void> setJobData(JobModel job) async {
    try {
      await _firebaseFirestore.collection('jobs').doc(job.id).set(job.toMap());
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  // Future<void> setJobDataWithCompleteImage(
  //     JobModel job,
  //     String jobImagePathFromFilePicker,
  //     String jobImageNameFromFilePicker,
  //     String currentUserId) async {
  //   try {
  //     int randomNumber = Random().nextInt(100000) + 100000;

  //     final jobRef = _firebaseStorage.ref().child(
  //         'job_image/${job.id}/$randomNumber$jobImageNameFromFilePicker');
  //     UploadTask jobUploadTask =
  //         jobRef.putFile(File(jobImagePathFromFilePicker));

  //     final jobSnapshot = await jobUploadTask.whenComplete(() => {});
  //     final String jobUrlDownload = await jobSnapshot.ref.getDownloadURL();
  //     //TODO: CHECK THIS LATER
  //     if (job.afterCompleteImageUrl != '') {
  //       await FirebaseStorage.instance
  //           .refFromURL(job.afterCompleteImageUrl)
  //           .delete();
  //     }
  //     final JobModel newJob = job.copyWith(
  //       status: JobStatus.completed,
  //       completedTimestamp: DateTime.now().microsecondsSinceEpoch,
  //       afterCompleteImageUrl: jobUrlDownload,
  //     );

  //     final mapOfUpdatedFields = job.getChangedFields(newJob);
  //     final update = UpdateJobModel(
  //         id: const Uuid().v1(),
  //         updatedFields: mapOfUpdatedFields,
  //         updatedBy: currentUserId,
  //         updatedTimeStamp: DateTime.now().microsecondsSinceEpoch);
  //     await _firebaseFirestore
  //         .collection('jobs')
  //         .doc(newJob.id)
  //         .set(newJob.toMap());
  //     await _firebaseFirestore
  //         .collection('jobs')
  //         .doc(newJob.id)
  //         .collection('updates')
  //         .doc(update.id)
  //         .set(update.toMap());
  //   } on FirebaseException catch (e) {
  //     throw SetFirebaseDataFailure.fromCode(e.code);
  //   } catch (_) {
  //     throw const SetFirebaseDataFailure();
  //   }
  // }

  Future<void> setJobImage(
    JobModel job,
    List<String> jobImagePathFromFilePicker,
    List<String> jobImageNameFromFilePicker,
    String currentUserId,
    bool isBeforeImage,
  ) async {
    try {
      int randomNumber = Random().nextInt(100000) + 100000;
      List<String> jobImagesUrlDownload = [];

      for (int i = 0; i < jobImagePathFromFilePicker.length; i++) {
        final jobRef = _firebaseStorage.ref().child(
            'job_image/${job.id}/$randomNumber${jobImageNameFromFilePicker[i]}');
        UploadTask jobUploadTask =
            jobRef.putFile(File(jobImagePathFromFilePicker[i]));

        final jobSnapshot = await jobUploadTask.whenComplete(() => {});
        final String jobUrlDownload = await jobSnapshot.ref.getDownloadURL();
        jobImagesUrlDownload.add(jobUrlDownload);
      }
      if (isBeforeImage
          ? job.beforeCompleteImageUrl.isNotEmpty
          : job.afterCompleteImageUrl.isNotEmpty) {
        for (var i in isBeforeImage
            ? job.beforeCompleteImageUrl
            : job.afterCompleteImageUrl) {
          await FirebaseStorage.instance.refFromURL(i).delete();
        }
      }

      final JobModel newJob = isBeforeImage
          ? job.copyWith(
              beforeCompleteImageUrl: jobImagesUrlDownload,
            )
          : job.copyWith(
              afterCompleteImageUrl: jobImagesUrlDownload,
            );

      final mapOfUpdatedFields = job.getChangedFields(newJob);
      final update = UpdateJobModel(
          id: const Uuid().v1(),
          updatedFields: mapOfUpdatedFields,
          updatedBy: currentUserId,
          updatedTimeStamp: DateTime.now().microsecondsSinceEpoch);
      await _firebaseFirestore
          .collection('jobs')
          .doc(newJob.id)
          .set(newJob.toMap());
      await _firebaseFirestore
          .collection('jobs')
          .doc(newJob.id)
          .collection('updates')
          .doc(update.id)
          .set(update.toMap());
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  // Future<void> setJobDataWithBeforeImage(
  //     JobModel job,
  //     String jobImagePathFromFilePicker,
  //     String jobImageNameFromFilePicker,
  //     String currentUserId) async {
  //   try {
  //     int randomNumber = Random().nextInt(100000) + 100000;

  //     final jobRef = _firebaseStorage.ref().child(
  //         'job_image/${job.id}/$randomNumber$jobImageNameFromFilePicker');
  //     UploadTask jobUploadTask =
  //         jobRef.putFile(File(jobImagePathFromFilePicker));

  //     final jobSnapshot = await jobUploadTask.whenComplete(() => {});
  //     final String jobUrlDownload = await jobSnapshot.ref.getDownloadURL();

  //     if (job.beforeCompleteImageUrl != '') {
  //       await FirebaseStorage.instance
  //           .refFromURL(job.beforeCompleteImageUrl)
  //           .delete();
  //     }
  //     final JobModel newJob = job.copyWith(
  //       beforeCompleteImageUrl: jobUrlDownload,
  //     );

  //     final mapOfUpdatedFields = job.getChangedFields(newJob);
  //     final update = UpdateJobModel(
  //         id: const Uuid().v1(),
  //         updatedFields: mapOfUpdatedFields,
  //         updatedBy: currentUserId,
  //         updatedTimeStamp: DateTime.now().microsecondsSinceEpoch);
  //     await _firebaseFirestore
  //         .collection('jobs')
  //         .doc(newJob.id)
  //         .set(newJob.toMap());
  //     await _firebaseFirestore
  //         .collection('jobs')
  //         .doc(newJob.id)
  //         .collection('updates')
  //         .doc(update.id)
  //         .set(update.toMap());
  //   } on FirebaseException catch (e) {
  //     throw SetFirebaseDataFailure.fromCode(e.code);
  //   } catch (_) {
  //     throw const SetFirebaseDataFailure();
  //   }
  // }

  Future<void> updateJobData(JobModel currentJobModel, JobModel oldJobModel,
      UpdateJobModel updateModel) async {
    try {
      await _firebaseFirestore
          .collection('jobs')
          .doc(currentJobModel.id)
          .set(currentJobModel.toMap());
      await _firebaseFirestore
          .collection('jobs')
          .doc(currentJobModel.id)
          .collection('updates')
          .doc(updateModel.id)
          .set(updateModel.toMap());
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  Future<void> deleteJob(JobModel job) async {
    try {
      await _firebaseFirestore.collection('jobs').doc(job.id).delete();
    } on FirebaseException catch (e) {
      developer.log(e.code);
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      developer.log(_.toString());
      throw const SetFirebaseDataFailure();
    }
  }
}

class SetFirebaseDataFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const SetFirebaseDataFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory SetFirebaseDataFailure.fromCode(code) {
    developer.log(code);
    switch (code) {
      // case 'invalid-email':
      //   return const SetFirebaseDataFailure(
      //     'Email is not valid or badly formatted.',
      //   );
      // case 'user-disabled':
      //   return const SetFirebaseDataFailure(
      //     'This user has been disabled. Please contact support for help.',
      //   );
      // case 'user-not-found':
      //   return const SetFirebaseDataFailure(
      //     'Email is not found, please create an account.',
      //   );
      // case 'wrong-password':
      //   return const SetFirebaseDataFailure(
      //     'Incorrect password, please try again.',
      //   );
      default:
        return const SetFirebaseDataFailure();
    }
  }

  /// The associated error message.
  final String message;
}
