import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:uuid/uuid.dart';

part 'accept_job_event.dart';
part 'accept_job_state.dart';

class AcceptJobBloc extends Bloc<AcceptJobEvent, AcceptJobState> {
  final JobsRepository _jobsRepository;
  final JobModel oldJobModel;
  final String userId;
  AcceptJobBloc(
      {required JobsRepository jobsRepository,
      required this.userId,
      required this.oldJobModel})
      : _jobsRepository = jobsRepository,
        super(AcceptJobInitial()) {
    on<AcceptJob>(_acceptJob);
  }

  FutureOr<void> _acceptJob(
      AcceptJob event, Emitter<AcceptJobState> emit) async {
    emit(AcceptJobLoading());
    final currentTime = DateTime.now().microsecondsSinceEpoch;

    try {
      JobModel newJobModel = oldJobModel.copyWith(
        startedTimestamp: currentTime,
        status: JobStatus.workInProgress,
      );

      final mapOfUpdatedFields = oldJobModel.getChangedFields(newJobModel);
      final update = UpdateJobModel(
          id: const Uuid().v1(),
          updatedFields: mapOfUpdatedFields,
          updatedBy: userId,
          updatedTimeStamp: currentTime);

      await _jobsRepository.updateJobData(newJobModel, oldJobModel, update);
      emit(AcceptJobSuccess());
    } on SetFirebaseDataFailure catch (e) {
      emit(AcceptJobFailure(errorMessage: e.message));
    } catch (e) {
      log(e.toString());
      emit(AcceptJobFailure(errorMessage: e.toString()));
    }
  }
}
