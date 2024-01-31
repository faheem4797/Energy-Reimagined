import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';

part 'job_detail_event.dart';
part 'job_detail_state.dart';

class JobDetailBloc extends Bloc<JobDetailEvent, JobDetailState> {
  final JobsRepository _jobsRepository;
  final String jobId;
  late final StreamSubscription<JobModel?> _jobsSubscription;
  JobDetailBloc({required JobsRepository jobsRepository, required this.jobId})
      : _jobsRepository = jobsRepository,
        super(const JobDetailState.loading()) {
    _jobsSubscription =
        _jobsRepository.getCurrentJobStream(jobId).listen((jobData) {
      add(GetCurrentJobStream(
        job: jobData,
      ));
    });
    on<GetCurrentJobStream>(_getCurrentJobStream);
  }

  FutureOr<void> _getCurrentJobStream(
      GetCurrentJobStream event, Emitter<JobDetailState> emit) {
    print('something new');
    try {
      emit(JobDetailState.success(
        event.job,
      ));
    } catch (e) {
      log(e.toString());
      emit(const JobDetailState.failure());
    }
  }

  @override
  Future<void> close() {
    _jobsSubscription.cancel();
    return super.close();
  }
}
