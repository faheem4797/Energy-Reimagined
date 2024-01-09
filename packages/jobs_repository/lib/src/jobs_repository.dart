import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobs_repository/jobs_repository.dart';

class JobsRepository {
  final FirebaseFirestore _firebaseFirestore;

  JobsRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<JobModel>> get getJobsStream {
    return _firebaseFirestore.collection('jobs').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => JobModel.fromMap(doc.data())).toList());
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

  Future<void> deleteJob(JobModel job) async {
    try {
      await _firebaseFirestore.collection('jobs').doc(job.id).delete();
    } on FirebaseException catch (e) {
      log(e.code);
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      log(_.toString());
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
    log(code);
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
