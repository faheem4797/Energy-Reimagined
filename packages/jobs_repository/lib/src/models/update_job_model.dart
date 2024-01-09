import 'dart:convert';

import 'package:equatable/equatable.dart';

class UpdateJobModel extends Equatable {
  final String id;
  final List<String> updatedField;
  final String updatedBy;
  final int updatedTimeStamp;
  const UpdateJobModel({
    required this.id,
    required this.updatedField,
    required this.updatedBy,
    required this.updatedTimeStamp,
  });

  UpdateJobModel copyWith({
    String? id,
    List<String>? updatedField,
    String? updatedBy,
    int? updatedTimeStamp,
  }) {
    return UpdateJobModel(
      id: id ?? this.id,
      updatedField: updatedField ?? this.updatedField,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedTimeStamp: updatedTimeStamp ?? this.updatedTimeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'updatedField': updatedField,
      'updatedBy': updatedBy,
      'updatedTimeStamp': updatedTimeStamp,
    };
  }

  factory UpdateJobModel.fromMap(Map<String, dynamic> map) {
    return UpdateJobModel(
      id: map['id'] ?? '',
      updatedField: List<String>.from(map['updatedField']),
      updatedBy: map['updatedBy'] ?? '',
      updatedTimeStamp: map['updatedTimeStamp']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateJobModel.fromJson(String source) =>
      UpdateJobModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateJobModel(id: $id, updatedField: $updatedField, updatedBy: $updatedBy, updatedTimeStamp: $updatedTimeStamp)';
  }

  @override
  List<Object> get props => [id, updatedField, updatedBy, updatedTimeStamp];
}
