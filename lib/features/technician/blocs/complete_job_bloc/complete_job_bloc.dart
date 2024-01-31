import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:uuid/uuid.dart';

part 'complete_job_event.dart';
part 'complete_job_state.dart';

class CompleteJobBloc extends Bloc<CompleteJobEvent, CompleteJobState> {
  final JobsRepository _jobsRepository;
  // final JobModel jobModel;
  final String userId;
  CompleteJobBloc(
      {required JobsRepository jobsRepository,
      // required this.jobModel,
      required this.userId})
      : _jobsRepository = jobsRepository,
        super(const CompleteJobState(
            // job: jobModel
            )) {
    on<CompleteJob>(_completeJob);
  }

  FutureOr<void> _completeJob(
      CompleteJob event, Emitter<CompleteJobState> emit) async {
    if (event.job.beforeCompleteImageUrl.isEmpty) {
      emit(state.copyWith(
          status: CompleteJobStatus.failure,
          errorMessage: 'Site Evidence - Before Work Missing'));
      emit(state.copyWith(status: CompleteJobStatus.initial));
      return;
    } else if (event.job.afterCompleteImageUrl.isEmpty) {
      emit(state.copyWith(
          status: CompleteJobStatus.failure,
          errorMessage: 'Site Evidence - After Work Missing'));
      emit(state.copyWith(status: CompleteJobStatus.initial));
      return;
    } else if (event.job.workDoneDescription == '') {
      emit(state.copyWith(
          status: CompleteJobStatus.failure,
          errorMessage: 'Description Of Work Done Missing'));
      emit(state.copyWith(status: CompleteJobStatus.initial));
      return;
    }
    emit(state.copyWith(status: CompleteJobStatus.inProgress));
    try {
      final currentTime = DateTime.now().microsecondsSinceEpoch;
      final newJobModel = event.job.copyWith(
        status: JobStatus.completed,
        completedTimestamp: currentTime,
      );

      final mapOfUpdatedFields = event.job.getChangedFields(newJobModel);
      final update = UpdateJobModel(
          id: const Uuid().v1(),
          updatedFields: mapOfUpdatedFields,
          updatedBy: userId,
          updatedTimeStamp: currentTime);
      await _jobsRepository.updateJobData(newJobModel, event.job, update);

      emit(state.copyWith(status: CompleteJobStatus.success));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: CompleteJobStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: CompleteJobStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: CompleteJobStatus.failure));
      emit(state.copyWith(status: CompleteJobStatus.initial));
    }
  }
}
