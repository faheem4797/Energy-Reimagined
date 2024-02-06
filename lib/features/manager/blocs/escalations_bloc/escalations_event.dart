part of 'escalations_bloc.dart';

sealed class EscalationsEvent extends Equatable {
  const EscalationsEvent();

  @override
  List<Object> get props => [];
}

final class GetEscalations extends EscalationsEvent {
  final List<JobModel> escalatedJobs;
  final List<JobModel> filteredEscalations;
  final Set<JobStatus> selectedStatuses;

  const GetEscalations(
      {required this.escalatedJobs,
      required this.filteredEscalations,
      required this.selectedStatuses});

  @override
  List<Object> get props =>
      [escalatedJobs, filteredEscalations, selectedStatuses];
}

final class ChangeFilterStatus extends EscalationsEvent {
  final List<ValueItem<dynamic>> filterStatusList;
  const ChangeFilterStatus({required this.filterStatusList});
  @override
  List<Object> get props => [filterStatusList];
}
