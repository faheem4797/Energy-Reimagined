import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:uuid/uuid.dart';

part 'reject_job_event.dart';
part 'reject_job_state.dart';

class RejectJobBloc extends Bloc<RejectJobEvent, RejectJobState> {
  final JobsRepository _jobsRepository;
  final JobModel oldJobModel;
  final String userId;
  RejectJobBloc(
      {required JobsRepository jobsRepository,
      required this.oldJobModel,
      required this.userId})
      : _jobsRepository = jobsRepository,
        super(RejectJobInitial()) {
    on<RejectJob>(_rejectJob);
  }

  FutureOr<void> _rejectJob(
      RejectJob event, Emitter<RejectJobState> emit) async {
    emit(RejectJobLoading());
    final currentTime = DateTime.now().microsecondsSinceEpoch;

    try {
      JobModel newJobModel = oldJobModel.copyWith(
        rejectedReason: event.rejectReason,
        rejectedTimestamp: currentTime,
        status: JobStatus.rejected,
        flagCounter: oldJobModel.flagCounter + 1,
      );
      //TODO: SEND NOTIFICATION TO MANAGER IF FLAGCOUNTER >= 3

      final mapOfUpdatedFields = oldJobModel.getChangedFields(newJobModel);
      final update = UpdateJobModel(
          id: const Uuid().v1(),
          updatedFields: mapOfUpdatedFields,
          updatedBy: userId,
          updatedTimeStamp: currentTime);

      await _jobsRepository.updateJobData(newJobModel, oldJobModel, update);
      emit(RejectJobSuccess());
    } on SetFirebaseDataFailure catch (e) {
      emit(RejectJobFailure(errorMessage: e.message));
    } catch (e) {
      log(e.toString());
      emit(RejectJobFailure(errorMessage: e.toString()));
    }
  }
}
