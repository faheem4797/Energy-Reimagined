import 'dart:convert';

import 'package:equatable/equatable.dart';

enum JobStatus { pending, assigned, started, onHold, completed, cancelled }

class JobModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final JobStatus status;
  final String assignedTechnicianId;
  final String locationName;
  final int locationLatitude;
  final int locationLongitude;
  final String holdReason;
  final String cancelReason;
  final int createdTimestamp;
  final int assignedTimestamp;
  final int startedTimestamp;
  final int holdTimestamp;
  final int completedTimestamp;
  const JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignedTechnicianId,
    required this.locationName,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.holdReason,
    required this.cancelReason,
    required this.createdTimestamp,
    required this.assignedTimestamp,
    required this.startedTimestamp,
    required this.holdTimestamp,
    required this.completedTimestamp,
  });

  static const empty = JobModel(
      id: '',
      title: '',
      description: '',
      status: JobStatus.pending,
      assignedTechnicianId: '',
      locationName: '',
      locationLongitude: 0,
      locationLatitude: 0,
      holdReason: '',
      cancelReason: '',
      createdTimestamp: 0,
      assignedTimestamp: 0,
      startedTimestamp: 0,
      holdTimestamp: 0,
      completedTimestamp: 0);

  JobModel copyWith({
    String? id,
    String? title,
    String? description,
    JobStatus? status,
    String? assignedTechnicianId,
    String? locationName,
    int? locationLatitude,
    int? locationLongitude,
    String? holdReason,
    String? cancelReason,
    int? createdTimestamp,
    int? assignedTimestamp,
    int? startedTimestamp,
    int? holdTimestamp,
    int? completedTimestamp,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      locationName: locationName ?? this.locationName,
      locationLatitude: locationLatitude ?? this.locationLatitude,
      locationLongitude: locationLongitude ?? this.locationLongitude,
      holdReason: holdReason ?? this.holdReason,
      cancelReason: cancelReason ?? this.cancelReason,
      createdTimestamp: createdTimestamp ?? this.createdTimestamp,
      assignedTimestamp: assignedTimestamp ?? this.assignedTimestamp,
      startedTimestamp: startedTimestamp ?? this.startedTimestamp,
      holdTimestamp: holdTimestamp ?? this.holdTimestamp,
      completedTimestamp: completedTimestamp ?? this.completedTimestamp,
    );
  }

  static Map<String, dynamic> _statusToMap(JobStatus status) {
    return {
      'status': status.toString().split('.').last,
    };
  }

  static JobStatus _mapToStatus(Map<String, dynamic> map) {
    return JobStatus.values.firstWhere(
        (status) => status.toString().split('.').last == map['status'],
        orElse: () => JobStatus.pending); // Default value if not found
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': _statusToMap(status),
      'assignedTechnicianId': assignedTechnicianId,
      'locationName': locationName,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      'holdReason': holdReason,
      'cancelReason': cancelReason,
      'createdTimestamp': createdTimestamp,
      'assignedTimestamp': assignedTimestamp,
      'startedTimestamp': startedTimestamp,
      'holdTimestamp': holdTimestamp,
      'completedTimestamp': completedTimestamp,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: _mapToStatus(map['status']), //JobStatus.fromMap(map['status']),
      assignedTechnicianId: map['assignedTechnicianId'] ?? '',
      locationName: map['locationName'] ?? '',
      locationLatitude: map['locationLatitude']?.toInt() ?? 0,
      locationLongitude: map['locationLongitude']?.toInt() ?? 0,
      holdReason: map['holdReason'] ?? '',
      cancelReason: map['cancelReason'] ?? '',
      createdTimestamp: map['createdTimestamp']?.toInt() ?? 0,
      assignedTimestamp: map['assignedTimestamp']?.toInt() ?? 0,
      startedTimestamp: map['startedTimestamp']?.toInt() ?? 0,
      holdTimestamp: map['holdTimestamp']?.toInt() ?? 0,
      completedTimestamp: map['completedTimestamp']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory JobModel.fromJson(String source) =>
      JobModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JobModel(id: $id, title: $title, description: $description, status: $status, assignedTechnicianId: $assignedTechnicianId, locationName: $locationName, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, holdReason: $holdReason, cancelReason: $cancelReason, createdTimestamp: $createdTimestamp, assignedTimestamp: $assignedTimestamp, startedTimestamp: $startedTimestamp, holdTimestamp: $holdTimestamp, completedTimestamp: $completedTimestamp)';
  }

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      status,
      assignedTechnicianId,
      locationName,
      locationLatitude,
      locationLongitude,
      holdReason,
      cancelReason,
      createdTimestamp,
      assignedTimestamp,
      startedTimestamp,
      holdTimestamp,
      completedTimestamp,
    ];
  }
}
