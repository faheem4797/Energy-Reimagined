import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final List<int> riddleTime;
  final bool huntEnded;
  final int userScore;
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.riddleTime,
    required this.huntEnded,
    required this.userScore,
  });

  static const empty = UserModel(
      id: '',
      name: '',
      email: '',
      riddleTime: [],
      huntEnded: false,
      userScore: 0);

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    List<int>? riddleTime,
    bool? huntEnded,
    int? userScore,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      riddleTime: riddleTime ?? this.riddleTime,
      huntEnded: huntEnded ?? this.huntEnded,
      userScore: userScore ?? this.userScore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'riddleTime': riddleTime,
      'huntEnded': huntEnded,
      'userScore': userScore,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      riddleTime: List<int>.from(map['riddleTime']),
      huntEnded: map['huntEnded'] as bool,
      userScore: map['userScore'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  bool get isEmpty => this == UserModel.empty;

  bool get isNotEmpty => this != UserModel.empty;

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, riddleTime: $riddleTime, huntEnded: $huntEnded, userscore: $userScore)';

  @override
  List<Object> get props => [id, name, email, riddleTime, huntEnded, userScore];
}
