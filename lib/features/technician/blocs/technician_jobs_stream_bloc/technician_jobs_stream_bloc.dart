import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:multi_dropdown/models/value_item.dart';

part 'technician_jobs_stream_event.dart';
part 'technician_jobs_stream_state.dart';

class TechnicianJobsStreamBloc
    extends Bloc<TechnicianJobsStreamEvent, TechnicianJobsStreamState> {
  final JobsRepository _jobsRepository;
  final String userId;
  late final StreamSubscription<List<JobModel>?> _jobsSubscription;

  TechnicianJobsStreamBloc(
      {required JobsRepository jobsRepository, required this.userId})
      : _jobsRepository = jobsRepository,
        super(TechnicianJobsStreamState.loading()) {
    _jobsSubscription =
        _jobsRepository.getUserJobsStream(userId).listen((jobData) {
      final newFilteredList = _filterList(jobData, state.selectedStatuses);
      add(GetJobStream(
          jobsStream: jobData,
          filteredJobs: newFilteredList,
          selectedStatuses: state.selectedStatuses));
    });
    on<GetJobStream>(_getJobStream);
    on<ChangeFilterStatus>(_changeFilterStatus);
    // on<AddFilterStatus>(_addFilterStatus);
    // on<RemoveFilterStatus>(_removeFilterStatus);
  }

  FutureOr<void> _getJobStream(
      GetJobStream event, Emitter<TechnicianJobsStreamState> emit) {
    try {
      emit(TechnicianJobsStreamState.success(
          event.jobsStream, event.filteredJobs, event.selectedStatuses));
    } catch (e) {
      log(e.toString());
      emit(TechnicianJobsStreamState.failure());
    }
  }

  FutureOr<void> _changeFilterStatus(
      ChangeFilterStatus event, Emitter<TechnicianJobsStreamState> emit) {
    Set<JobStatus> tempSet = {};
    for (var element in event.filterStatusList) {
      tempSet.add(element.value);
    }

    final newFilteredList = _filterList(state.jobStream!, tempSet);

    emit(TechnicianJobsStreamState.success(
        state.jobStream!, newFilteredList, tempSet));
  }

  // FutureOr<void> _addFilterStatus(
  //     AddFilterStatus event, Emitter<TechnicianJobsStreamState> emit) {
  //   final Set<JobStatus> tempSet = Set.from(state.selectedStatuses);
  //   tempSet.add(event.status);

  //   final newFilteredList = _filterList(state.jobStream!, tempSet);

  //   emit(TechnicianJobsStreamState.success(
  //       state.jobStream!, newFilteredList, tempSet));
  // }

  // FutureOr<void> _removeFilterStatus(
  //     RemoveFilterStatus event, Emitter<TechnicianJobsStreamState> emit) {
  //   final Set<JobStatus> tempSet = Set.from(state.selectedStatuses);
  //   tempSet.remove(event.status);

  //   final newFilteredList = _filterList(state.jobStream!, tempSet);

  //   emit(TechnicianJobsStreamState.success(
  //       state.jobStream!, newFilteredList, tempSet));
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

  @override
  Future<void> close() {
    _jobsSubscription.cancel();
    return super.close();
  }
}
