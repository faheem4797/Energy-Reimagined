import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_data_repository/src/models/models.dart';

class UserDataRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserDataRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<UserModel>> get getUsersStream {
    return _firebaseFirestore
        .collection('users')
        // .where('role', isNotEqualTo: 'admin')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }
}
