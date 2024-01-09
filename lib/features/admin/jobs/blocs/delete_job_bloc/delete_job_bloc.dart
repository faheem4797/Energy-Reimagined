import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';

part 'delete_job_event.dart';
part 'delete_job_state.dart';

class DeleteJobBloc extends Bloc<DeleteJobEvent, DeleteJobState> {
  final JobsRepository _jobsRepository;
  DeleteJobBloc({required JobsRepository jobsRepository})
      : _jobsRepository = jobsRepository,
        super(DeleteJobInitial()) {
    on<JobDeleteRequested>(_jobDeleteRequested);
  }

  FutureOr<void> _jobDeleteRequested(
      JobDeleteRequested event, Emitter<DeleteJobState> emit) async {
    try {
      await _jobsRepository.deleteJob(event.job);

      emit(DeleteJobSuccess());
    } on SetFirebaseDataFailure catch (e) {
      emit(DeleteJobFailure(errorMessage: e.message));
    } catch (e) {
      log(e.toString());
      emit(DeleteJobFailure(errorMessage: e.toString()));
    }
  }
}
