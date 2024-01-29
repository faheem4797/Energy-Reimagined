import 'dart:convert';

import 'package:equatable/equatable.dart';

// pending = job is just created by admin, not assigned to any technician
// assigned = admin assigned the job to technician
// workInProgress = technician is working on job
// onHold = technician put job on hold (need more tools etc.)
// completed = job is completed
// rejected = job rejected by technician
//also put onHold when technician requests tools

enum JobStatus {
  pending,
  assigned,
  workInProgress,
  onHold,
  completed,
  rejected,
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
  final List<String> currentToolsRequestedIds;
  final List<int> currentToolsRequestedQuantity;
  final String currentToolsRequestQrCode;
  final String holdReason;
  final String cancelReason;
  final String rejectedReason;
  final int rejectedTimestamp;
  final int createdTimestamp;
  final int assignedTimestamp;
  final int startedTimestamp;
  final int holdTimestamp;
  final int completedTimestamp;
  final String beforeCompleteImageUrl;
  final String afterCompleteImageUrl;
  final String workDoneDescription;
  final int flagCounter;
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
    required this.currentToolsRequestedIds,
    required this.currentToolsRequestedQuantity,
    required this.currentToolsRequestQrCode,
    required this.holdReason,
    required this.cancelReason,
    required this.rejectedReason,
    required this.rejectedTimestamp,
    required this.createdTimestamp,
    required this.assignedTimestamp,
    required this.startedTimestamp,
    required this.holdTimestamp,
    required this.completedTimestamp,
    required this.beforeCompleteImageUrl,
    required this.afterCompleteImageUrl,
    required this.workDoneDescription,
    required this.flagCounter,
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
    currentToolsRequestedIds: [],
    currentToolsRequestedQuantity: [],
    currentToolsRequestQrCode: '',
    holdReason: '',
    cancelReason: '',
    rejectedReason: '',
    rejectedTimestamp: 0,
    createdTimestamp: 0,
    assignedTimestamp: 0,
    startedTimestamp: 0,
    holdTimestamp: 0,
    completedTimestamp: 0,
    beforeCompleteImageUrl: '',
    afterCompleteImageUrl: '',
    workDoneDescription: '',
    flagCounter: 0,
  );

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
    List<String>? currentToolsRequestedIds,
    List<int>? currentToolsRequestedQuantity,
    String? currentToolsRequestQrCode,
    String? holdReason,
    String? cancelReason,
    String? rejectedReason,
    int? rejectedTimestamp,
    int? createdTimestamp,
    int? assignedTimestamp,
    int? startedTimestamp,
    int? holdTimestamp,
    int? completedTimestamp,
    String? beforeCompleteImageUrl,
    String? afterCompleteImageUrl,
    String? workDoneDescription,
    int? flagCounter,
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
      currentToolsRequestedIds:
          currentToolsRequestedIds ?? this.currentToolsRequestedIds,
      currentToolsRequestedQuantity:
          currentToolsRequestedQuantity ?? this.currentToolsRequestedQuantity,
      currentToolsRequestQrCode:
          currentToolsRequestQrCode ?? this.currentToolsRequestQrCode,
      holdReason: holdReason ?? this.holdReason,
      cancelReason: cancelReason ?? this.cancelReason,
      rejectedReason: rejectedReason ?? this.rejectedReason,
      rejectedTimestamp: rejectedTimestamp ?? this.rejectedTimestamp,
      createdTimestamp: createdTimestamp ?? this.createdTimestamp,
      assignedTimestamp: assignedTimestamp ?? this.assignedTimestamp,
      startedTimestamp: startedTimestamp ?? this.startedTimestamp,
      holdTimestamp: holdTimestamp ?? this.holdTimestamp,
      completedTimestamp: completedTimestamp ?? this.completedTimestamp,
      beforeCompleteImageUrl:
          beforeCompleteImageUrl ?? this.beforeCompleteImageUrl,
      afterCompleteImageUrl:
          afterCompleteImageUrl ?? this.afterCompleteImageUrl,
      workDoneDescription: workDoneDescription ?? this.workDoneDescription,
      flagCounter: flagCounter ?? this.flagCounter,
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
      'currentToolsRequestedIds': currentToolsRequestedIds,
      'currentToolsRequestedQuantity': currentToolsRequestedQuantity,
      'currentToolsRequestQrCode': currentToolsRequestQrCode,
      'holdReason': holdReason,
      'cancelReason': cancelReason,
      'rejectedReason': rejectedReason,
      'rejectedTimestamp': rejectedTimestamp,
      'createdTimestamp': createdTimestamp,
      'assignedTimestamp': assignedTimestamp,
      'startedTimestamp': startedTimestamp,
      'holdTimestamp': holdTimestamp,
      'completedTimestamp': completedTimestamp,
      'beforeCompleteImageUrl': beforeCompleteImageUrl,
      'afterCompleteImageUrl': afterCompleteImageUrl,
      'workDoneDescription': workDoneDescription,
      'flagCounter': flagCounter,
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
      currentToolsRequestedIds:
          List<String>.from(map['currentToolsRequestedIds']),
      currentToolsRequestedQuantity:
          List<int>.from(map['currentToolsRequestedQuantity']),
      currentToolsRequestQrCode: map['currentToolsRequestQrCode'] ?? '',
      holdReason: map['holdReason'] ?? '',
      cancelReason: map['cancelReason'] ?? '',
      rejectedReason: map['rejectedReason'] ?? '',
      rejectedTimestamp: map['rejectedTimestamp']?.toInt() ?? 0,
      createdTimestamp: map['createdTimestamp']?.toInt() ?? 0,
      assignedTimestamp: map['assignedTimestamp']?.toInt() ?? 0,
      startedTimestamp: map['startedTimestamp']?.toInt() ?? 0,
      holdTimestamp: map['holdTimestamp']?.toInt() ?? 0,
      completedTimestamp: map['completedTimestamp']?.toInt() ?? 0,
      beforeCompleteImageUrl: map['beforeCompleteImageUrl'] ?? '',
      afterCompleteImageUrl: map['afterCompleteImageUrl'] ?? '',
      workDoneDescription: map['workDoneDescription'] ?? '',
      flagCounter: map['flagCounter']?.toInt() ?? 0,
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
    if (municipality != other.municipality) {
      addChangedField('municipality', municipality, other.municipality);
    }
    if (status != other.status) {
      addChangedField('status', status.toString().split('.').last,
          other.status.toString().split('.').last);
    }
    if (assignedTechnicianId != other.assignedTechnicianId) {
      addChangedField('assignedTechnicianId', assignedTechnicianId,
          other.assignedTechnicianId);
    }
    if (locationName != other.locationName) {
      addChangedField('locationName', locationName, other.locationName);
    }

    if (allToolsRequested != other.allToolsRequested) {
      addChangedField(
          'allToolsRequested', allToolsRequested, other.allToolsRequested);
    }
    if (currentToolsRequestedIds != other.currentToolsRequestedIds) {
      addChangedField('currentToolsRequestedIds', currentToolsRequestedIds,
          other.currentToolsRequestedIds);
    }
    if (currentToolsRequestedQuantity != other.currentToolsRequestedQuantity) {
      addChangedField('currentToolsRequestedQuantity',
          currentToolsRequestedQuantity, other.currentToolsRequestedQuantity);
    }
    if (currentToolsRequestQrCode != other.currentToolsRequestQrCode) {
      addChangedField('currentToolsRequestQrCode', currentToolsRequestQrCode,
          other.currentToolsRequestQrCode);
    }
    if (holdReason != other.holdReason) {
      addChangedField('holdReason', holdReason, other.holdReason);
    }
    if (cancelReason != other.cancelReason) {
      addChangedField('cancelReason', cancelReason, other.cancelReason);
    }
    if (rejectedReason != other.rejectedReason) {
      addChangedField('rejectedReason', rejectedReason, other.rejectedReason);
    }
    if (rejectedTimestamp != other.rejectedTimestamp) {
      addChangedField(
          'rejectedTimestamp', rejectedTimestamp, other.rejectedTimestamp);
    }
    if (holdTimestamp != other.holdTimestamp) {
      addChangedField('holdTimestamp', holdTimestamp, other.holdTimestamp);
    }
    if (createdTimestamp != other.createdTimestamp) {
      addChangedField(
          'createdTimestamp', createdTimestamp, other.createdTimestamp);
    }
    if (assignedTimestamp != other.assignedTimestamp) {
      addChangedField(
          'assignedTimestamp', assignedTimestamp, other.assignedTimestamp);
    }
    if (completedTimestamp != other.completedTimestamp) {
      addChangedField(
          'completedTimestamp', completedTimestamp, other.completedTimestamp);
    }
    if (startedTimestamp != other.startedTimestamp) {
      addChangedField(
          'startedTimestamp', startedTimestamp, other.startedTimestamp);
    }
    if (beforeCompleteImageUrl != other.beforeCompleteImageUrl) {
      addChangedField('beforeCompleteImageUrl', beforeCompleteImageUrl,
          other.beforeCompleteImageUrl);
    }
    if (afterCompleteImageUrl != other.afterCompleteImageUrl) {
      addChangedField('afterCompleteImageUrl', afterCompleteImageUrl,
          other.afterCompleteImageUrl);
    }
    if (workDoneDescription != other.workDoneDescription) {
      addChangedField('workDoneDescription', workDoneDescription,
          other.workDoneDescription);
    }
    if (flagCounter != other.flagCounter) {
      addChangedField('flagCounter', flagCounter, other.flagCounter);
    }

    return changedFieldsList;
  }

  String toJson() => json.encode(toMap());

  factory JobModel.fromJson(String source) =>
      JobModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JobModel(id: $id, title: $title, description: $description, municipality: $municipality, status: $status, assignedTechnicianId: $assignedTechnicianId, locationName: $locationName, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, allToolsRequested: $allToolsRequested, currentToolsRequested: $currentToolsRequestedIds, currentToolsRequestedQuantity: $currentToolsRequestedQuantity, currentToolsRequestQrCode: $currentToolsRequestQrCode, holdReason: $holdReason, cancelReason: $cancelReason, createdTimestamp: $createdTimestamp, assignedTimestamp: $assignedTimestamp, startedTimestamp: $startedTimestamp, holdTimestamp: $holdTimestamp, completedTimestamp: $completedTimestamp)';
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
      currentToolsRequestedIds,
      currentToolsRequestedQuantity,
      currentToolsRequestQrCode,
      holdReason,
      cancelReason,
      rejectedReason,
      rejectedTimestamp,
      createdTimestamp,
      assignedTimestamp,
      startedTimestamp,
      holdTimestamp,
      completedTimestamp,
      beforeCompleteImageUrl,
      afterCompleteImageUrl,
      workDoneDescription,
      flagCounter,
    ];
  }
}
