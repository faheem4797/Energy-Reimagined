import 'dart:convert';

import 'package:equatable/equatable.dart';

class UpdateJobModel extends Equatable {
  final String id;
  final List<Map<String, dynamic>> updatedFields;
  final String updatedBy;
  final int updatedTimeStamp;
  const UpdateJobModel({
    required this.id,
    required this.updatedFields,
    required this.updatedBy,
    required this.updatedTimeStamp,
  });

  UpdateJobModel copyWith({
    String? id,
    List<Map<String, dynamic>>? updatedFields,
    String? updatedBy,
    int? updatedTimeStamp,
  }) {
    return UpdateJobModel(
      id: id ?? this.id,
      updatedFields: updatedFields ?? this.updatedFields,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedTimeStamp: updatedTimeStamp ?? this.updatedTimeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'updatedField': updatedFields,
      'updatedBy': updatedBy,
      'updatedTimeStamp': updatedTimeStamp,
    };
  }

  factory UpdateJobModel.fromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> fields =
        List<Map<String, dynamic>>.from(map['updatedFields'] ?? []);

    return UpdateJobModel(
      id: map['id'] ?? '',
      updatedFields: fields,
      updatedBy: map['updatedBy'] ?? '',
      updatedTimeStamp: map['updatedTimeStamp']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateJobModel.fromJson(String source) =>
      UpdateJobModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateJobModel(id: $id, updatedField: $updatedFields, updatedBy: $updatedBy, updatedTimeStamp: $updatedTimeStamp)';
  }

  @override
  List<Object> get props => [id, updatedFields, updatedBy, updatedTimeStamp];
}
