import 'dart:convert';

import 'package:equatable/equatable.dart';

// pending = job is just created by admin, not assigned to any technician
// assigned = admin assigned the job to technician
// workInProgress = technician is working on job
// onHold = technician put job on hold (need more tools etc.)
// completed = job is completed
// cancelled = admin completed the job
//also put onHold when technician requests tools

enum JobStatus {
  pending,
  assigned,
  workInProgress,
  onHold,
  completed,
  cancelled
}

const List<String> municipalities = [
  'Municipality 1',
  'Municipality 2',
  'Municipality 3',
  'Municipality 4',
  'Municipality 5'
];
const String firstMunicipality = 'Municipality 1';

class JobModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String municipality;
  final JobStatus status;
  final String assignedTechnicianId;
  final String locationName;
  final int locationLatitude;
  final int locationLongitude;
  final List<String> allToolsRequested;
  final List<String> currentToolsRequested;
  final String currentToolsRequestQrCode;
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
    required this.municipality,
    required this.status,
    required this.assignedTechnicianId,
    required this.locationName,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.allToolsRequested,
    required this.currentToolsRequested,
    required this.currentToolsRequestQrCode,
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
      municipality: firstMunicipality,
      status: JobStatus.pending,
      assignedTechnicianId: '',
      locationName: '',
      locationLongitude: 0,
      locationLatitude: 0,
      allToolsRequested: [],
      currentToolsRequested: [],
      currentToolsRequestQrCode: '',
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
    String? municipality,
    JobStatus? status,
    String? assignedTechnicianId,
    String? locationName,
    int? locationLatitude,
    int? locationLongitude,
    List<String>? allToolsRequested,
    List<String>? currentToolsRequested,
    String? currentToolsRequestQrCode,
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
      municipality: municipality ?? this.municipality,
      status: status ?? this.status,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      locationName: locationName ?? this.locationName,
      locationLatitude: locationLatitude ?? this.locationLatitude,
      locationLongitude: locationLongitude ?? this.locationLongitude,
      allToolsRequested: allToolsRequested ?? this.allToolsRequested,
      currentToolsRequested:
          currentToolsRequested ?? this.currentToolsRequested,
      currentToolsRequestQrCode:
          currentToolsRequestQrCode ?? this.currentToolsRequestQrCode,
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
      'municipality': municipality,
      'status': _statusToMap(status),
      'assignedTechnicianId': assignedTechnicianId,
      'locationName': locationName,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      'allToolsRequested': allToolsRequested,
      'currentToolsRequested': currentToolsRequested,
      'currentToolsRequestQrCode': currentToolsRequestQrCode,
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
      municipality: map['municipality'] ?? '',
      status: _mapToStatus(map['status']), //JobStatus.fromMap(map['status']),
      assignedTechnicianId: map['assignedTechnicianId'] ?? '',
      locationName: map['locationName'] ?? '',
      locationLatitude: map['locationLatitude']?.toInt() ?? 0,
      locationLongitude: map['locationLongitude']?.toInt() ?? 0,
      allToolsRequested: List<String>.from(map['allToolsRequested']),
      currentToolsRequested: List<String>.from(map['currentToolsRequested']),
      currentToolsRequestQrCode: map['currentToolsRequestQrCode'] ?? '',
      holdReason: map['holdReason'] ?? '',
      cancelReason: map['cancelReason'] ?? '',
      createdTimestamp: map['createdTimestamp']?.toInt() ?? 0,
      assignedTimestamp: map['assignedTimestamp']?.toInt() ?? 0,
      startedTimestamp: map['startedTimestamp']?.toInt() ?? 0,
      holdTimestamp: map['holdTimestamp']?.toInt() ?? 0,
      completedTimestamp: map['completedTimestamp']?.toInt() ?? 0,
    );
  }

  List<Map<String, dynamic>> getChangedFields(JobModel other) {
    final changedFieldsList = <Map<String, dynamic>>[];

    void addChangedField(String fieldName, dynamic oldValue, dynamic newValue) {
      changedFieldsList.add({
        'field': fieldName,
        'oldValue': oldValue,
        'newValue': newValue,
      });
    }

    if (id != other.id) {
      addChangedField('id', id, other.id);
    }
    if (title != other.title) {
      addChangedField('title', title, other.title);
    }
    if (description != other.description) {
      addChangedField('description', description, other.description);
    }
    if (status != other.status) {
      addChangedField('status', status.toString().split('.').last,
          other.status.toString().split('.').last);
    }

    if (allToolsRequested != other.allToolsRequested) {
      addChangedField(
          'allToolsRequested', allToolsRequested, other.allToolsRequested);
    }
    if (currentToolsRequested != other.currentToolsRequested) {
      addChangedField('currentToolsRequested', currentToolsRequested,
          other.currentToolsRequested);
    }
    if (currentToolsRequestQrCode != other.currentToolsRequestQrCode) {
      addChangedField('currentToolsRequestQrCode', currentToolsRequestQrCode,
          other.currentToolsRequestQrCode);
    }
    //TODO: ADD MORE FIELDS FOR UPDATION

    return changedFieldsList;
  }

  String toJson() => json.encode(toMap());

  factory JobModel.fromJson(String source) =>
      JobModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JobModel(id: $id, title: $title, description: $description, municipality: $municipality, status: $status, assignedTechnicianId: $assignedTechnicianId, locationName: $locationName, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, allToolsRequested: $allToolsRequested, currentToolsRequested: $currentToolsRequested, currentToolsRequestQrCode: $currentToolsRequestQrCode, holdReason: $holdReason, cancelReason: $cancelReason, createdTimestamp: $createdTimestamp, assignedTimestamp: $assignedTimestamp, startedTimestamp: $startedTimestamp, holdTimestamp: $holdTimestamp, completedTimestamp: $completedTimestamp)';
  }

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      municipality,
      status,
      assignedTechnicianId,
      locationName,
      locationLatitude,
      locationLongitude,
      allToolsRequested,
      currentToolsRequested,
      currentToolsRequestQrCode,
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
