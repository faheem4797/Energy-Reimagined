import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

part 'escalations_event.dart';
part 'escalations_state.dart';

class EscalationsBloc extends Bloc<EscalationsEvent, EscalationsState> {
  final JobsRepository _jobsRepository;
  late final StreamSubscription<List<JobModel>?> _escalationsSubscription;

  EscalationsBloc({required JobsRepository jobsRepository})
      : _jobsRepository = jobsRepository,
        super(EscalationsState.loading()) {
    _escalationsSubscription = _jobsRepository.getEscalations.listen((jobData) {
      final newFilteredList = _filterList(jobData, state.selectedStatuses);
      add(GetEscalations(
          escalatedJobs: jobData,
          filteredEscalations: newFilteredList,
          selectedStatuses: state.selectedStatuses));
    });
    on<GetEscalations>(_getEscalations);
    on<ChangeFilterStatus>(_changeFilterStatus);
  }

  FutureOr<void> _getEscalations(
      GetEscalations event, Emitter<EscalationsState> emit) {
    try {
      emit(EscalationsState.success(event.escalatedJobs,
          event.filteredEscalations, event.selectedStatuses));
    } catch (e) {
      log(e.toString());
      emit(EscalationsState.failure());
    }
  }

  FutureOr<void> _changeFilterStatus(
      ChangeFilterStatus event, Emitter<EscalationsState> emit) {
    Set<JobStatus> tempSet = {};
    for (var element in event.filterStatusList) {
      tempSet.add(element.value);
    }

    final newFilteredList = _filterList(state.escalatedJobs!, tempSet);

    emit(EscalationsState.success(
        state.escalatedJobs!, newFilteredList, tempSet));
  }

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
    _escalationsSubscription.cancel();
    return super.close();
  }
}
