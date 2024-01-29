import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:user_data_repository/user_data_repository.dart';
import 'package:uuid/uuid.dart';

part 'edit_job_event.dart';
part 'edit_job_state.dart';

class EditJobBloc extends Bloc<EditJobEvent, EditJobState> {
  final JobsRepository _jobsRepository;
  final JobModel oldJobModel;
  final String userId;
  final List<UserModel> currentUserStream;

  EditJobBloc({
    required JobsRepository jobsRepository,
    required this.oldJobModel,
    required this.userId,
    required this.currentUserStream,
  })  : _jobsRepository = jobsRepository,
        super(EditJobState(
          job: oldJobModel,
          filteredUsers: currentUserStream,
        )) {
    on<EditJobWithUpdatedJobModel>(_editJobWithUpdatedJobModel);
    on<TitleChanged>(_titleChanged);
    on<DescriptionChanged>(_descriptionChanged);
    on<LocationChanged>(_locationChanged);
    // on<StatusChanged>(_statusChanged);
    on<MunicipalityChanged>(_municipalityChanged);
    on<TechnicianSelected>(_technicianSelected);
  }

  FutureOr<void> _editJobWithUpdatedJobModel(
      EditJobWithUpdatedJobModel event, Emitter<EditJobState> emit) async {
    emit(state.copyWith(
      isValid: _validate(
        title: state.job.title,
        description: state.job.description,
        locationName: state.job.locationName,
        // locationLatitude: state.job.locationLatitude,
        // locationLongitude: state.job.locationLongitude,
        municipality: state.job.municipality,
      ),
    ));
    if (!state.isValid) {
      emit(state.copyWith(
          status: EditJobStatus.failure, errorMessage: 'Invalid Form Data'));
      emit(state.copyWith(status: EditJobStatus.initial));
      return;
    }
    emit(state.copyWith(status: EditJobStatus.inProgress));
    try {
      final mapOfUpdatedFields = oldJobModel.getChangedFields(state.job);
      List<Map<String, dynamic>>? newMapOfUpdatedFields;
//TODO: CHECKED FLAG COUNTER HERE
      if (mapOfUpdatedFields.any((map) =>
          map['field'] == 'status' &&
          ( //map['newValue'] == 'cancelled' ||
              map['newValue'] == 'rejected'))) {
        emit(state.copyWith(
            job: state.job.copyWith(flagCounter: state.job.flagCounter + 1)));
        newMapOfUpdatedFields = oldJobModel.getChangedFields(state.job);
      }

      final update = UpdateJobModel(
          id: const Uuid().v1(),
          updatedFields: newMapOfUpdatedFields ?? mapOfUpdatedFields,
          updatedBy: userId,
          updatedTimeStamp: DateTime.now().microsecondsSinceEpoch);

      await _jobsRepository.updateJobData(state.job, oldJobModel, update);

      emit(state.copyWith(status: EditJobStatus.success));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: EditJobStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: EditJobStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: EditJobStatus.failure));
      emit(state.copyWith(status: EditJobStatus.initial));
    }
  }

  FutureOr<void> _titleChanged(TitleChanged event, Emitter<EditJobState> emit) {
    final TitleValidationStatus titleValidationStatus =
        _validateTitle(event.title);

    emit(
      state.copyWith(
        job: state.job.copyWith(title: event.title),
        isValid: _validate(
          title: event.title,
          description: state.job.description,
          locationName: state.job.locationName,
          // locationLatitude: state.job.locationLatitude,
          // locationLongitude: state.job.locationLongitude,
          municipality: state.job.municipality,
        ),
        displayError: titleValidationStatus == TitleValidationStatus.empty
            ? 'Please enter a title'
            : null,
      ),
    );
  }

  FutureOr<void> _descriptionChanged(
      DescriptionChanged event, Emitter<EditJobState> emit) {
    final DescriptionValidationStatus descriptionValidationStatus =
        _validateDescription(event.description);

    emit(
      state.copyWith(
        job: state.job.copyWith(description: event.description),
        isValid: _validate(
          title: state.job.title,
          description: event.description,
          locationName: state.job.locationName,
          // locationLatitude: state.job.locationLatitude,
          // locationLongitude: state.job.locationLongitude,
          municipality: state.job.municipality,
        ),
        displayError:
            descriptionValidationStatus == DescriptionValidationStatus.empty
                ? 'Please enter a description'
                : null,
      ),
    );
  }

  FutureOr<void> _locationChanged(
      LocationChanged event, Emitter<EditJobState> emit) {
    final LocationValidationStatus locationValidationStatus = _validateLocation(
      event.locationName,
      // event.locationLatitude, event.locationLongitude
    );

    emit(
      state.copyWith(
        job: state.job.copyWith(
          locationName: event.locationName,
          // locationLatitude: event.locationLatitude,
          // locationLongitude: event.locationLongitude
        ),
        isValid: _validate(
          title: state.job.title,
          description: state.job.description,
          locationName: event.locationName,
          // locationLatitude: event.locationLatitude,
          // locationLongitude: event.locationLongitude,
          municipality: state.job.municipality,
        ),
        displayError: locationValidationStatus == LocationValidationStatus.empty
            ? 'Please enter a location'
            : locationValidationStatus == LocationValidationStatus.invalid
                ? 'Please choose a location on map as well'
                : null,
      ),
    );
  }

  // FutureOr<void> _statusChanged(
  //     StatusChanged event, Emitter<EditJobState> emit) {
  //   emit(
  //     state.copyWith(
  //       job: state.job.copyWith(
  //         status: event.isCancelled
  //             ? JobStatus.cancelled
  //             : (oldJobModel.status == JobStatus.cancelled &&
  //                     state.job.assignedTechnicianId.isNotEmpty)
  //                 ? JobStatus.assigned
  //                 : oldJobModel.status,
  //         // status: event.isCancelled
  //         //     ? JobStatus.cancelled
  //         //     : oldJobModel.status == JobStatus.cancelled
  //         //         ? JobStatus.pending
  //         //         : JobStatus.cancelled,
  //       ),
  //       isValid: _validate(
  //         title: state.job.title,
  //         description: state.job.description,
  //         locationName: state.job.locationName,
  //         // locationLatitude: event.locationLatitude,
  //         // locationLongitude: event.locationLongitude,
  //         municipality: state.job.municipality,
  //       ),
  //     ),
  //   );
  // }

  FutureOr<void> _municipalityChanged(
      MunicipalityChanged event, Emitter<EditJobState> emit) {
    final MunicipalityValidationStatus municipalityValidationStatus =
        _validateMunicipality(
      event.municipality,
    );
    emit(
      state.copyWith(
        job: state.job.copyWith(
          municipality: event.municipality,
        ),
        isValid: _validate(
            title: state.job.title,
            description: state.job.description,
            locationName: state.job.locationName,
            // locationLatitude: event.locationLatitude,
            // locationLongitude: event.locationLongitude,
            municipality: event.municipality),
        displayError:
            municipalityValidationStatus == MunicipalityValidationStatus.empty
                ? 'Please choose a municipality'
                : null,
      ),
    );
  }

  FutureOr<void> _technicianSelected(
      TechnicianSelected event, Emitter<EditJobState> emit) {
    if (event.technician.id == oldJobModel.assignedTechnicianId) {
      emit(state.copyWith(
          job: state.job.copyWith(
        status: oldJobModel.status,
        assignedTechnicianId: oldJobModel.assignedTechnicianId,
        assignedTimestamp: oldJobModel.assignedTimestamp,
      )));
    } else {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      emit(state.copyWith(
          job: state.job.copyWith(
        status: JobStatus.assigned,
        assignedTechnicianId: event.technician.id,
        assignedTimestamp: currentTime,
      )));
    }
  }

  bool _validate({
    required String title,
    required String description,
    required String locationName,
    // required int locationLongitude,
    // required int locationLatitude,
    required String municipality,
  }) {
    final TitleValidationStatus titleValidationStatus = _validateTitle(title);

    final DescriptionValidationStatus descriptionValidationStatus =
        _validateDescription(description);
    final LocationValidationStatus locationValidationStatus = _validateLocation(
      locationName,
      // locationLatitude, locationLongitude
    );
    final MunicipalityValidationStatus municipalityValidationStatus =
        _validateMunicipality(municipality);

    return titleValidationStatus == TitleValidationStatus.valid &&
        descriptionValidationStatus == DescriptionValidationStatus.valid &&
        locationValidationStatus == LocationValidationStatus.valid &&
        municipalityValidationStatus == MunicipalityValidationStatus.valid;
  }

  TitleValidationStatus _validateTitle(String title) {
    if (title.isEmpty) {
      return TitleValidationStatus.empty;
    } else {
      return TitleValidationStatus.valid;
    }
  }

  DescriptionValidationStatus _validateDescription(String description) {
    if (description.isEmpty) {
      return DescriptionValidationStatus.empty;
    } else {
      return DescriptionValidationStatus.valid;
    }
  }

  LocationValidationStatus _validateLocation(
    String location,
    //  int locationLatitude, int locationLongitude
  ) {
    if (location.isEmpty) {
      return LocationValidationStatus.empty;
    }
    // else if (locationLatitude == 0 || locationLongitude == 0) {
    //   return LocationValidationStatus.invalid;
    // }
    else {
      return LocationValidationStatus.valid;
    }
  }

  MunicipalityValidationStatus _validateMunicipality(
    String? municipality,
  ) {
    if (municipality == null || municipality.isEmpty) {
      return MunicipalityValidationStatus.empty;
    } else {
      return MunicipalityValidationStatus.valid;
    }
  }
}

enum TitleValidationStatus { empty, valid }

enum DescriptionValidationStatus { empty, valid }

enum LocationValidationStatus { empty, invalid, valid }

enum MunicipalityValidationStatus { empty, valid }
