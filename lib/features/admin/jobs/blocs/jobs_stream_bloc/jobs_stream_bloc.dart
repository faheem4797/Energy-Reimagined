import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';

part 'jobs_stream_event.dart';
part 'jobs_stream_state.dart';

class JobsStreamBloc extends Bloc<JobsStreamEvent, JobsStreamState> {
  final JobsRepository _jobsRepository;
  late final StreamSubscription<List<JobModel>?> _jobsSubscription;

  JobsStreamBloc({required JobsRepository jobsRepository})
      : _jobsRepository = jobsRepository,
        super(const JobsStreamState.loading()) {
    _jobsSubscription = _jobsRepository.getJobsStream.listen((jobData) {
      add(GetJobStream(jobsStream: jobData));
    });
    on<GetJobStream>(_getJobStream);
  }

  FutureOr<void> _getJobStream(
      GetJobStream event, Emitter<JobsStreamState> emit) {
    try {
      emit(JobsStreamState.success(event.jobsStream));
    } catch (e) {
      log(e.toString());
      emit(const JobsStreamState.failure());
    }
  }

  @override
  Future<void> close() {
    _jobsSubscription.cancel();
    return super.close();
  }
}
