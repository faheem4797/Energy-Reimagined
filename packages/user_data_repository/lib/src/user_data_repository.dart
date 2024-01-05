import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_data_repository/src/models/models.dart';

class UserDataRepository {
  final String userId;

  UserDataRepository({required this.userId});

  Stream<UserModel> get getUserData {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((user) => UserModel.fromMap(user.data()!));
  }
}
