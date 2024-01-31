import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:uuid/uuid.dart';

part 'add_work_description_event.dart';
part 'add_work_description_state.dart';

class AddWorkDescriptionBloc
    extends Bloc<AddWorkDescriptionEvent, AddWorkDescriptionState> {
  final JobsRepository _jobsRepository;
  final String userId;
  AddWorkDescriptionBloc(
      {required JobsRepository jobsRepository, required this.userId})
      : _jobsRepository = jobsRepository,
        super(const AddWorkDescriptionState()) {
    on<UpdateJobWithWorkDescription>(_updateJobWithWorkDescription);
  }

  FutureOr<void> _updateJobWithWorkDescription(
      UpdateJobWithWorkDescription event,
      Emitter<AddWorkDescriptionState> emit) async {
    if (event.workDescription.trim() == '') {
      emit(state.copyWith(
          status: AddWorkDescriptionStatus.failure,
          errorMessage: 'Work Description is Empty'));
      emit(state.copyWith(status: AddWorkDescriptionStatus.initial));
      return;
    }
    try {
      final currentTime = DateTime.now().microsecondsSinceEpoch;
      final newJobModel =
          event.job.copyWith(workDoneDescription: event.workDescription);

      final mapOfUpdatedFields = event.job.getChangedFields(newJobModel);
      final update = UpdateJobModel(
          id: const Uuid().v1(),
          updatedFields: mapOfUpdatedFields,
          updatedBy: userId,
          updatedTimeStamp: currentTime);
      await _jobsRepository.updateJobData(newJobModel, event.job, update);

      emit(state.copyWith(status: AddWorkDescriptionStatus.success));
      emit(state.copyWith(status: AddWorkDescriptionStatus.initial));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: AddWorkDescriptionStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: AddWorkDescriptionStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: AddWorkDescriptionStatus.failure));
      emit(state.copyWith(status: AddWorkDescriptionStatus.initial));
    }
  }
}
