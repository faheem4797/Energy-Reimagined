import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riddles_repository/riddles_repository.dart';

class RiddlesRepository {
  final riddlesCollection = FirebaseFirestore.instance.collection('riddles');
  final usersCollection = FirebaseFirestore.instance.collection('users');

  // Stream<List<RiddleModel>> get riddlesList =>W
  //     riddlesCollection.orderBy('riddleNumber').snapshots().map((snapshot) =>
  //         snapshot.docs.map((doc) => RiddleModel.fromMap(doc.data())).toList());

  Future<List<UserModel>> getAllUserScore() async {
    try {
      return await usersCollection.orderBy('userScore').get().then((value) =>
          value.docs
              .where((e) => e.data()['userScore'] != 0)
              .map((e) => UserModel.fromMap(e.data()))
              .toList());
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  Future<List<RiddleModel>> getAllRiddles() async {
    try {
      return await riddlesCollection.orderBy('riddleNumber').get().then(
          (value) =>
              value.docs.map((e) => RiddleModel.fromMap(e.data())).toList());
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  Future<void> setRiddleData(RiddleModel riddle) async {
    try {
      await riddlesCollection.doc(riddle.id).set(riddle.toMap());
    } on FirebaseException catch (e) {
      throw SetFirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const SetFirebaseDataFailure();
    }
  }

  Future<void> setRiddleTimeData(String userId, List<int> riddleTime) async {
    try {
      await usersCollection
          .doc(userId)
          .update({'riddleTime': List<int>.from(riddleTime)});
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> setHuntEnded(String userId, int userScore) async {
    try {
      await usersCollection
          .doc(userId)
          .update({'huntEnded': true, 'userScore': userScore});
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> resetHuntEnded(String userId) async {
    try {
      await usersCollection
          .doc(userId)
          .update({'huntEnded': false, 'userScore': 0});
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<int>> getRiddleTimeData(String userId) async {
    try {
      // final userDoc = await usersCollection
      //     .doc(userId)
      //     .get()
      //     .then((value) => UserModel.fromMap(value.data()!));

      // return userDoc.riddleTime;
      return [];
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteRiddle(RiddleModel riddle) async {
    try {
      await riddlesCollection.doc(riddle.id).delete();
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
