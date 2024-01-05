import 'dart:convert';

import 'package:equatable/equatable.dart';

class RiddleModel extends Equatable {
  final String id;
  final String riddleText;
  final String qrCodeText;
  final int riddleNumber;
  const RiddleModel({
    required this.id,
    required this.riddleText,
    required this.qrCodeText,
    required this.riddleNumber,
  });

  static const empty = RiddleModel(
    id: '',
    riddleText: '',
    qrCodeText: '',
    riddleNumber: 0,
  );

  RiddleModel copyWith({
    String? id,
    String? riddleText,
    String? qrCodeText,
    int? riddleNumber,
  }) {
    return RiddleModel(
      id: id ?? this.id,
      riddleText: riddleText ?? this.riddleText,
      qrCodeText: qrCodeText ?? this.qrCodeText,
      riddleNumber: riddleNumber ?? this.riddleNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'riddleText': riddleText,
      'qrCodeText': qrCodeText,
      'riddleNumber': riddleNumber,
    };
  }

  factory RiddleModel.fromMap(Map<String, dynamic> map) {
    return RiddleModel(
      id: map['id'] as String,
      riddleText: map['riddleText'] as String,
      qrCodeText: map['qrCodeText'] as String,
      riddleNumber: map['riddleNumber'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RiddleModel.fromJson(String source) =>
      RiddleModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RiddleModel(id: $id, riddleText: $riddleText, qrCodeText: $qrCodeText, riddleNumber: $riddleNumber)';
  }

  @override
  List<Object> get props => [id, riddleText, qrCodeText, riddleNumber];
}
