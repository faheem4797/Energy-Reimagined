import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:uuid/uuid.dart';

part 'edit_job_event.dart';
part 'edit_job_state.dart';

class EditJobBloc extends Bloc<EditJobEvent, EditJobState> {
  final JobsRepository _jobsRepository;
  final JobModel oldJobModel;
  final String userId;

  EditJobBloc({
    required JobsRepository jobsRepository,
    required this.oldJobModel,
    required this.userId,
  })  : _jobsRepository = jobsRepository,
        super(EditJobState(job: oldJobModel)) {
    on<EditJobWithUpdatedToolModel>(_editJobWithUpdatedToolModel);
    on<TitleChanged>(_titleChanged);
    on<DescriptionChanged>(_descriptionChanged);
    on<LocationChanged>(_locationChanged);
  }

  FutureOr<void> _editJobWithUpdatedToolModel(
      EditJobWithUpdatedToolModel event, Emitter<EditJobState> emit) async {
    emit(state.copyWith(
      isValid: _validate(
        title: state.job.title,
        description: state.job.description,
        locationName: state.job.locationName,
        locationLatitude: state.job.locationLatitude,
        locationLongitude: state.job.locationLongitude,
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
      final update = UpdateJobModel(
          id: const Uuid().v1(),
          updatedFields: mapOfUpdatedFields,
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
          locationLatitude: state.job.locationLatitude,
          locationLongitude: state.job.locationLongitude,
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
          locationLatitude: state.job.locationLatitude,
          locationLongitude: state.job.locationLongitude,
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
        event.locationName, event.locationLatitude, event.locationLongitude);

    emit(
      state.copyWith(
        job: state.job.copyWith(
            locationName: event.locationName,
            locationLatitude: event.locationLatitude,
            locationLongitude: event.locationLongitude),
        isValid: _validate(
          title: state.job.title,
          description: state.job.description,
          locationName: event.locationName,
          locationLatitude: event.locationLatitude,
          locationLongitude: event.locationLongitude,
        ),
        displayError: locationValidationStatus == LocationValidationStatus.empty
            ? 'Please enter a location'
            : locationValidationStatus == LocationValidationStatus.invalid
                ? 'Please choose a location on map as well'
                : null,
      ),
    );
  }

  bool _validate({
    required String title,
    required String description,
    required String locationName,
    required int locationLongitude,
    required int locationLatitude,
  }) {
    final TitleValidationStatus titleValidationStatus = _validateTitle(title);

    final DescriptionValidationStatus descriptionValidationStatus =
        _validateDescription(description);
    final LocationValidationStatus locationValidationStatus =
        _validateLocation(locationName, locationLatitude, locationLongitude);

    return titleValidationStatus == TitleValidationStatus.valid &&
        descriptionValidationStatus == DescriptionValidationStatus.valid &&
        locationValidationStatus == LocationValidationStatus.valid;
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
      String location, int locationLatitude, int locationLongitude) {
    if (location.isEmpty) {
      return LocationValidationStatus.empty;
    } else if (locationLatitude == 0 || locationLongitude == 0) {
      return LocationValidationStatus.invalid;
    } else {
      return LocationValidationStatus.valid;
    }
  }
}

enum TitleValidationStatus { empty, valid }

enum DescriptionValidationStatus { empty, valid }

enum LocationValidationStatus { empty, invalid, valid }
