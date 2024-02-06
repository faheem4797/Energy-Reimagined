import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

part 'jobs_stream_event.dart';
part 'jobs_stream_state.dart';

class JobsStreamBloc extends Bloc<JobsStreamEvent, JobsStreamState> {
  final JobsRepository _jobsRepository;
  late final StreamSubscription<List<JobModel>?> _jobsSubscription;

  JobsStreamBloc({required JobsRepository jobsRepository})
      : _jobsRepository = jobsRepository,
        super(JobsStreamState.loading()) {
    _jobsSubscription = _jobsRepository.getJobsStream.listen((jobData) {
      final newFilteredList = _filterList(jobData, state.selectedStatuses);
      add(GetJobStream(
          jobsStream: jobData,
          filteredJobs: newFilteredList,
          selectedStatuses: state.selectedStatuses));
    });
    on<GetJobStream>(_getJobStream);
    on<ChangeFilterStatus>(_changeFilterStatus);
  }

  FutureOr<void> _getJobStream(
      GetJobStream event, Emitter<JobsStreamState> emit) {
    try {
      emit(JobsStreamState.success(
          event.jobsStream, event.filteredJobs, event.selectedStatuses));
    } catch (e) {
      log(e.toString());
      emit(JobsStreamState.failure());
    }
  }

  // FutureOr<void> _addFilterStatus(
  //     AddFilterStatus event, Emitter<JobsStreamState> emit) {
  //   final Set<JobStatus> tempSet = Set.from(state.selectedStatuses);
  //   tempSet.add(event.status);

  //   final newFilteredList = _filterList(state.jobStream!, tempSet);

  //   emit(JobsStreamState.success(state.jobStream!, newFilteredList, tempSet));
  // }

  // FutureOr<void> _removeFilterStatus(
  //     RemoveFilterStatus event, Emitter<JobsStreamState> emit) {
  //   final Set<JobStatus> tempSet = Set.from(state.selectedStatuses);
  //   tempSet.remove(event.status);

  //   final newFilteredList = _filterList(state.jobStream!, tempSet);

  //   emit(JobsStreamState.success(state.jobStream!, newFilteredList, tempSet));
  // }

  List<JobModel> _filterList(List<JobModel> jobData, Set<JobStatus> filterSet) {
    final List<JobModel> tempFilteredJobs;

    if (filterSet.isEmpty) {
      tempFilteredJobs = List.from(jobData);
    } else {
      tempFilteredJobs =
          jobData.where((job) => filterSet.contains(job.status)).toList();
    }
    return tempFilteredJobs;
  }

  FutureOr<void> _changeFilterStatus(
      ChangeFilterStatus event, Emitter<JobsStreamState> emit) {
    Set<JobStatus> tempSet = {};
    for (var element in event.filterStatusList) {
      tempSet.add(element.value);
    }

    final newFilteredList = _filterList(state.jobStream!, tempSet);

    emit(JobsStreamState.success(state.jobStream!, newFilteredList, tempSet));
  }

  @override
  Future<void> close() {
    _jobsSubscription.cancel();
    return super.close();
  }
}
