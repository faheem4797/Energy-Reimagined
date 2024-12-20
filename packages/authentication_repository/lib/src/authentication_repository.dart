import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  AuthenticationRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((user) => user);
  }

  // Stream<DocumentSnapshot> getUserDocumentStream(String userId) {
  //   return usersCollection.doc(userId).snapshots();
  // }

  Future<UserModel> signUp({
    required UserModel myUser,
    required String password,
  }) async {
    try {
      FirebaseApp secondaryApp = await Firebase.initializeApp(
          name: "secondary", options: Firebase.app().options);

      UserCredential user = await FirebaseAuth.instanceFor(app: secondaryApp)
          .createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );

      await secondaryApp.delete();

      // UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
      //   email: myUser.email,
      //   password: password,
      // );

      return myUser.copyWith(id: user.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInWithEmailAndPasswordFailure();
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      throw SignOutFailure();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw SendPasswordResetEmailFailure.fromCode(e.code);
    } catch (_) {
      throw const SendPasswordResetEmailFailure();
    }
  }

  Future<void> setUserData(UserModel user) async {
    try {
      await usersCollection.doc(user.id).set(user.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel> getUser(String userId) async {
    try {
      return usersCollection
          .doc(userId)
          .get()
          .then((value) => UserModel.fromMap(value.data()!));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // deleteAccount() async {
  //    Need to reauthenticate user and then use the delete functionality from firebase
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     await user.delete();
  //     await AuthService().signOut();
  //   }
  // }
}

/// {@template sign_up_with_email_and_password_failure}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class SignInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const SignInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory SignInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const SignInWithEmailAndPasswordFailure(
          'Email not found, please create an account.',
        );
      case 'wrong-password':
        return const SignInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const SignInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class SignOutFailure implements Exception {}

/// {@template send_password_reset_email_failure}
/// Thrown during the password reset email sending process if a failure occurs.
/// {@endtemplate}
class SendPasswordResetEmailFailure implements Exception {
  /// {@macro send_password_reset_email_failure}
  const SendPasswordResetEmailFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create a password reset email message
  /// from a Firebase authentication exception code.
  factory SendPasswordResetEmailFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SendPasswordResetEmailFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-not-found':
        return const SendPasswordResetEmailFailure(
          'Email not found, please create an account.',
        );
      case 'too-many-requests':
        return const SendPasswordResetEmailFailure(
          'Too many requests, please try again later.',
        );
      case 'network-request-failed':
        return const SendPasswordResetEmailFailure(
          'A network error occurred, please check your internet connection.',
        );
      default:
        return const SendPasswordResetEmailFailure();
    }
  }

  /// The associated error message.
  final String message;
}
