import 'dart:convert';

import 'package:equatable/equatable.dart';

enum ToolRequestStatus {
  pending,
  cancelled,
  completed,
}

//TODO: SET STATUS TO CANCELLED WHEN TECHNICIAN REJECTS A JOB AND THERE IS SOME ToolRequest IN PENDING STATUS regarding that job

class ToolRequestModel extends Equatable {
  final String id;
  final String jobId;
  final List<String> toolsRequestedIds;
  final List<int> toolsRequestedQuantity;
  final String qrCode;
  final int requestedTimestamp;
  final int completedTimestamp;
  final ToolRequestStatus status;
  const ToolRequestModel({
    required this.id,
    required this.jobId,
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
      jobId,
      toolsRequestedIds,
      toolsRequestedQuantity,
      qrCode,
      requestedTimestamp,
      completedTimestamp,
      status,
    ];
  }

  static const empty = ToolRequestModel(
    id: '',
    jobId: '',
    toolsRequestedIds: [],
    toolsRequestedQuantity: [],
    qrCode: '',
    requestedTimestamp: 0,
    completedTimestamp: 0,
    status: ToolRequestStatus.pending,
  );

  ToolRequestModel copyWith({
    String? id,
    String? jobId,
    List<String>? toolsRequestedIds,
    List<int>? toolsRequestedQuantity,
    String? qrCode,
    int? requestedTimestamp,
    int? completedTimestamp,
    ToolRequestStatus? status,
  }) {
    return ToolRequestModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
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
      'jobId': jobId,
      'toolsRequestedIds': toolsRequestedIds,
      'toolsRequestedQuantity': toolsRequestedQuantity,
      'qrCode': qrCode,
      'requestedTimestamp': requestedTimestamp,
      'completedTimestamp': completedTimestamp,
      'status': _statusToMap(status),
    };
  }

  factory ToolRequestModel.fromMap(Map<String, dynamic> map) {
    return ToolRequestModel(
      id: map['id'] ?? '',
      jobId: map['jobId'] ?? '',
      toolsRequestedIds: List<String>.from(map['toolsRequestedIds']),
      toolsRequestedQuantity: List<int>.from(map['toolsRequestedQuantity']),
      qrCode: map['qrCode'] ?? '',
      requestedTimestamp: map['requestedTimestamp']?.toInt() ?? 0,
      completedTimestamp: map['completedTimestamp']?.toInt() ?? 0,
      status: _mapToStatus(map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ToolRequestModel.fromJson(String source) =>
      ToolRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ToolRequest(id: $id, toolsRequestedIds: $toolsRequestedIds, toolsRequestedQuantity: $toolsRequestedQuantity, qrCode: $qrCode, requestedTimestamp: $requestedTimestamp, completedTimestamp: $completedTimestamp, status: $status)';
  }
}
