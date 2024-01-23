import 'dart:convert';

import 'package:equatable/equatable.dart';

enum ToolRequestStatus {
  pending,
  completed,
}

class ToolRequest extends Equatable {
  final String id;
  final List<String> toolsRequestedIds;
  final List<int> toolsRequestedQuantity;
  final String qrCode;
  final int requestedTimestamp;
  final int completedTimestamp;
  final ToolRequestStatus status;
  const ToolRequest({
    required this.id,
    required this.toolsRequestedIds,
    required this.toolsRequestedQuantity,
    required this.qrCode,
    required this.requestedTimestamp,
    required this.completedTimestamp,
    required this.status,
  });

  @override
  List<Object> get props {
    return [
      id,
      toolsRequestedIds,
      toolsRequestedQuantity,
      qrCode,
      requestedTimestamp,
      completedTimestamp,
      status,
    ];
  }

  ToolRequest copyWith({
    String? id,
    List<String>? toolsRequestedIds,
    List<int>? toolsRequestedQuantity,
    String? qrCode,
    int? requestedTimestamp,
    int? completedTimestamp,
    ToolRequestStatus? status,
  }) {
    return ToolRequest(
      id: id ?? this.id,
      toolsRequestedIds: toolsRequestedIds ?? this.toolsRequestedIds,
      toolsRequestedQuantity:
          toolsRequestedQuantity ?? this.toolsRequestedQuantity,
      qrCode: qrCode ?? this.qrCode,
      requestedTimestamp: requestedTimestamp ?? this.requestedTimestamp,
      completedTimestamp: completedTimestamp ?? this.completedTimestamp,
      status: status ?? this.status,
    );
  }

  static Map<String, dynamic> _statusToMap(ToolRequestStatus status) {
    return {
      'status': status.toString().split('.').last,
    };
  }

  static ToolRequestStatus _mapToStatus(Map<String, dynamic> map) {
    return ToolRequestStatus.values.firstWhere(
        (status) => status.toString().split('.').last == map['status'],
        orElse: () => ToolRequestStatus.pending); // Default value if not found
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toolsRequestedIds': toolsRequestedIds,
      'toolsRequestedQuantity': toolsRequestedQuantity,
      'qrCode': qrCode,
      'requestedTimestamp': requestedTimestamp,
      'completedTimestamp': completedTimestamp,
      'status': _statusToMap(status),
    };
  }

  factory ToolRequest.fromMap(Map<String, dynamic> map) {
    return ToolRequest(
      id: map['id'] ?? '',
      toolsRequestedIds: List<String>.from(map['toolsRequestedIds']),
      toolsRequestedQuantity: List<int>.from(map['toolsRequestedQuantity']),
      qrCode: map['qrCode'] ?? '',
      requestedTimestamp: map['requestedTimestamp']?.toInt() ?? 0,
      completedTimestamp: map['completedTimestamp']?.toInt() ?? 0,
      status: _mapToStatus(map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ToolRequest.fromJson(String source) =>
      ToolRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ToolRequest(id: $id, toolsRequestedIds: $toolsRequestedIds, toolsRequestedQuantity: $toolsRequestedQuantity, qrCode: $qrCode, requestedTimestamp: $requestedTimestamp, completedTimestamp: $completedTimestamp, status: $status)';
  }
}
