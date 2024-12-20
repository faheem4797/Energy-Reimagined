import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:user_data_repository/user_data_repository.dart';
import 'package:uuid/uuid.dart';

part 'create_job_event.dart';
part 'create_job_state.dart';

class CreateJobBloc extends Bloc<CreateJobEvent, CreateJobState> {
  final JobsRepository _jobsRepository;
  final List<UserModel> currentUserStream;
  CreateJobBloc(
      {required JobsRepository jobsRepository, required this.currentUserStream})
      : _jobsRepository = jobsRepository,
        super(const CreateJobState()) {
    on<CreateJobWithDataModel>(_createJobWithDataModel);
    on<TitleChanged>(_titleChanged);
    on<DescriptionChanged>(_descriptionChanged);
    on<LocationChanged>(_locationChanged);
    on<MunicipalityChanged>(_municipalityChanged);
    on<CategoryChanged>(_categoryChanged);
    on<TechnicianSelected>(_technicianSelected);
  }

  FutureOr<void> _createJobWithDataModel(
      CreateJobWithDataModel event, Emitter<CreateJobState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(
          status: CreateJobStatus.failure, errorMessage: 'Invalid Form Data'));
      emit(state.copyWith(status: CreateJobStatus.initial));
      return;
    }
    emit(state.copyWith(status: CreateJobStatus.inProgress));
    try {
      emit(state.copyWith(
          job: state.job.copyWith(
              id: const Uuid().v1(),
              createdTimestamp: DateTime.now().microsecondsSinceEpoch)));

      await _jobsRepository.setJobData(state.job);

      emit(state.copyWith(status: CreateJobStatus.success));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: CreateJobStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: CreateJobStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: CreateJobStatus.failure));
      emit(state.copyWith(status: CreateJobStatus.initial));
    }
  }

  FutureOr<void> _titleChanged(
      TitleChanged event, Emitter<CreateJobState> emit) {
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
          category: state.job.category,
          municipality: state.job.municipality,
        ),
        displayError: titleValidationStatus == TitleValidationStatus.empty
            ? 'Please enter a title'
            : null,
      ),
    );
  }

  FutureOr<void> _descriptionChanged(
      DescriptionChanged event, Emitter<CreateJobState> emit) {
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
          category: state.job.category,
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
      LocationChanged event, Emitter<CreateJobState> emit) {
    final LocationValidationStatus locationValidationStatus = _validateLocation(
      event.locationName,
      //event.locationLatitude, event.locationLongitude
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
          category: state.job.category,
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

  FutureOr<void> _categoryChanged(
      CategoryChanged event, Emitter<CreateJobState> emit) {
    final CategoryValidationStatus categoryValidationStatus = _validateCategory(
      event.category,
    );

    emit(
      state.copyWith(
        job: state.job.copyWith(
          category: event.category,
        ),
        isValid: _validate(
          title: state.job.title,
          description: state.job.description,
          locationName: state.job.locationName,
          // locationLatitude: event.locationLatitude,
          // locationLongitude: event.locationLongitude,
          category: event.category,
          municipality: state.job.municipality,
        ),
        displayError: categoryValidationStatus == CategoryValidationStatus.empty
            ? 'Please choose a category'
            : null,
      ),
    );
  }

  FutureOr<void> _municipalityChanged(
      MunicipalityChanged event, Emitter<CreateJobState> emit) {
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
          category: state.job.category,
          municipality: event.municipality,
        ),
        displayError:
            municipalityValidationStatus == MunicipalityValidationStatus.empty
                ? 'Please choose a municipality'
                : null,
      ),
    );
  }

  FutureOr<void> _technicianSelected(
      TechnicianSelected event, Emitter<CreateJobState> emit) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    emit(state.copyWith(
        job: state.job.copyWith(
      status: JobStatus.assigned,
      assignedTechnicianId: event.technician.id,
      assignedTimestamp: currentTime,
    )));
  }

  bool _validate({
    required String title,
    required String description,
    required String locationName,

    // required int locationLongitude,
    // required int locationLatitude,
    required String category,
    required String municipality,
  }) {
    final TitleValidationStatus titleValidationStatus = _validateTitle(title);

    final DescriptionValidationStatus descriptionValidationStatus =
        _validateDescription(description);
    final LocationValidationStatus locationValidationStatus = _validateLocation(
      locationName,
      // locationLatitude, locationLongitude
    );
    final CategoryValidationStatus categoryValidationStatus =
        _validateCategory(category);
    final MunicipalityValidationStatus municipalityValidationStatus =
        _validateMunicipality(municipality);

    return titleValidationStatus == TitleValidationStatus.valid &&
        descriptionValidationStatus == DescriptionValidationStatus.valid &&
        locationValidationStatus == LocationValidationStatus.valid &&
        categoryValidationStatus == CategoryValidationStatus.valid &&
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
    // int locationLatitude, int locationLongitude
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

  CategoryValidationStatus _validateCategory(
    String category,
  ) {
    if (category.isEmpty) {
      return CategoryValidationStatus.empty;
    } else {
      return CategoryValidationStatus.valid;
    }
  }

  MunicipalityValidationStatus _validateMunicipality(
    String municipality,
  ) {
    if (municipality.isEmpty) {
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

enum CategoryValidationStatus { empty, valid }
