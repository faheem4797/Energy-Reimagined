import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String deviceToken;
  final String firstName;
  final String lastName;
  final bool isRestricted;
  final String email;
  final String employeeNumber;
  final String role;
  final int createdAt;

  const UserModel({
    required this.id,
    required this.deviceToken,
    required this.firstName,
    required this.lastName,
    required this.isRestricted,
    required this.email,
    required this.employeeNumber,
    required this.role,
    required this.createdAt,
  });

  static const empty = UserModel(
      id: '',
      deviceToken: '',
      firstName: '',
      lastName: '',
      email: '',
      isRestricted: false,
      employeeNumber: '',
      role: 'technician',
      createdAt: 0);

  UserModel copyWith({
    String? id,
    String? deviceToken,
    String? firstName,
    String? lastName,
    bool? isRestricted,
    String? email,
    String? employeeNumber,
    String? role,
    int? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      deviceToken: deviceToken ?? this.deviceToken,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isRestricted: isRestricted ?? this.isRestricted,
      email: email ?? this.email,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceToken': deviceToken,
      'firstName': firstName,
      'lastName': lastName,
      'isRestricted': isRestricted,
      'email': email,
      'employeeNumber': employeeNumber,
      'role': role,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      isRestricted: map['isRestricted'] ?? false,
      email: map['email'] ?? '',
      employeeNumber: map['employeeNumber'] ?? '',
      role: map['role'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  bool get isEmpty => this == UserModel.empty;

  bool get isNotEmpty => this != UserModel.empty;

  @override
  String toString() {
    return 'UserModel(id: $id, deviceToken: $deviceToken, firstName: $firstName, lastName: $lastName, isRestricted: $isRestricted, email: $email, employeeNumber: $employeeNumber, role: $role, createdAt: $createdAt)';
  }

  @override
  List<Object> get props {
    return [
      id,
      deviceToken,
      firstName,
      lastName,
      isRestricted,
      email,
      employeeNumber,
      role,
      createdAt,
    ];
  }
}
