import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final JobsRepository _jobsRepository;
  late final StreamSubscription<List<JobModel>?> _jobsSubscription;
  ReportsBloc({required JobsRepository jobsRepository})
      : _jobsRepository = jobsRepository,
        super(ReportsState.loading()) {
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

  FutureOr<void> _getJobStream(GetJobStream event, Emitter<ReportsState> emit) {
    try {
      emit(ReportsState.success(
          event.jobsStream, event.filteredJobs, event.selectedStatuses));
    } catch (e) {
      log(e.toString());
      emit(ReportsState.failure());
    }
  }

  List<JobModel> _filterList(List<JobModel> jobData, Set<String> filterSet) {
    final List<JobModel> tempFilteredJobs;

    if (filterSet.isEmpty) {
      tempFilteredJobs = List.from(jobData);
    } else {
      tempFilteredJobs =
          jobData.where((job) => filterSet.contains(job.category)).toList();
    }
    return tempFilteredJobs;
  }

  FutureOr<void> _changeFilterStatus(
      ChangeFilterStatus event, Emitter<ReportsState> emit) {
    Set<String> tempSet = {};
    for (var element in event.filterStatusList) {
      tempSet.add(element.value);
    }

    final newFilteredList = _filterList(state.jobStream!, tempSet);

    emit(ReportsState.success(state.jobStream!, newFilteredList, tempSet));
  }

  @override
  Future<void> close() {
    _jobsSubscription.cancel();
    return super.close();
  }
}
