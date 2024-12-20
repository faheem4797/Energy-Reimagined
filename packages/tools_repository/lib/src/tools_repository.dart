import 'dart:developer' as developers;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tools_repository/tools_repository.dart';

class ToolsRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  ToolsRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseStorage? firebaseStorage})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Stream<List<ToolModel>> get getToolsStream {
    return _firebaseFirestore.collection('tools').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ToolModel.fromMap(doc.data())).toList());
  }

  Stream<List<ToolRequestModel>> get getToolRequestsStream {
    return _firebaseFirestore.collection('toolRequests').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => ToolRequestModel.fromMap(doc.data()))
            .toList());
  }

  Future<List<ToolModel>> getAllTools() async {
    try {
      return await _firebaseFirestore.collection('tools').get().then(
          (toolsSnapshot) => toolsSnapshot.docs
              .map((doc) => ToolModel.fromMap(doc.data()))
              .toList());
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  Future<List<ToolModel>> getSomeTools(List<String> toolIds) async {
    try {
      return await _firebaseFirestore
          .collection('tools')
          .where('id', whereIn: toolIds)
          .get()
          .then((toolsSnapshot) => toolsSnapshot.docs
              .map((doc) => ToolModel.fromMap(doc.data()))
              .toList());
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  Future<ToolRequestModel> getToolRequestData(String toolRequestId) async {
    try {
      return await _firebaseFirestore
          .collection('toolRequests')
          .doc(toolRequestId)
          .get()
          .then((value) => ToolRequestModel.fromMap(value.data()!));
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  Future<void> setToolRequestData(ToolRequestModel toolRequest) async {
    try {
      await _firebaseFirestore
          .collection('toolRequests')
          .doc(toolRequest.id)
          .set(toolRequest.toMap());
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  // Future<List<ToolModel>> getCurrentTools(String toolRequestId) async {
  //   try {
  //     final toolRequest = await _firebaseFirestore
  //         .collection('tools_request')
  //         .doc(toolRequestId)
  //         .get()
  //         .then((doc) => ToolRequest.fromMap(doc.data()!));
  //     toolRequest.toolsRequestedIds;

  //     // .map((doc) => ToolModel.fromMap(doc.data()))
  //     // .toList());
  //     // return _firebaseFirestore.collection('tools').get().then(
  //     //     (toolsSnapshot) => toolsSnapshot.docs
  //     //         .map((doc) => ToolModel.fromMap(doc.data()))
  //     //         .toList());
  //   } on FirebaseException catch (e) {
  //     throw SetFirebaseDataFailure.fromCode(e.code);
  //   } catch (_) {
  //     throw const SetFirebaseDataFailure();
  //   }
  // }

  Future<void> setToolData(ToolModel tool, String? toolImagePathFromFilePicker,
      String? toolImageNameFromFilePicker) async {
    try {
      if (toolImagePathFromFilePicker != null &&
          toolImageNameFromFilePicker != null) {
        int randomNumber = Random().nextInt(100000) + 100000;

        final toolRef = _firebaseStorage.ref().child(
            'tool_image/${tool.id}/$randomNumber$toolImageNameFromFilePicker');
        UploadTask toolUploadTask =
            toolRef.putFile(File(toolImagePathFromFilePicker));

        final toolSnapshot = await toolUploadTask.whenComplete(() => {});
        final String toolUrlDownload = await toolSnapshot.ref.getDownloadURL();
        if (tool.imageUrl != '') {
          await FirebaseStorage.instance.refFromURL(tool.imageUrl).delete();
        }
        final ToolModel newTool = tool.copyWith(imageUrl: toolUrlDownload);

        await _firebaseFirestore
            .collection('tools')
            .doc(newTool.id)
            .set(newTool.toMap());
      } else {
        await _firebaseFirestore
            .collection('tools')
            .doc(tool.id)
            .set(tool.toMap());
      }
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  Future<void> updateToolQuantity(int quantity, String toolId) async {
    try {
      final toolModel = await _firebaseFirestore
          .collection('tools')
          .doc(toolId)
          .get()
          .then((value) => ToolModel.fromMap(value.data()!));
      int newToolQuantity = (toolModel.quantity - quantity) < 0
          ? 0
          : toolModel.quantity - quantity;
      await _firebaseFirestore
          .collection('tools')
          .doc(toolId)
          .update({'quantity': newToolQuantity});
    } on FirebaseException catch (e) {
      developers.log(e.code);
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      developers.log(_.toString());
      throw const SetFirebaseDataFailure();
    }
  }

  Future<void> deleteTool(ToolModel tool) async {
    try {
      await _firebaseFirestore.collection('tools').doc(tool.id).delete();
    } on FirebaseException catch (e) {
      developers.log(e.code);
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      developers.log(_.toString());
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
