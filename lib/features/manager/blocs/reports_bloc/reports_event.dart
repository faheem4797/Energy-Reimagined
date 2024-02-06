part of 'reports_bloc.dart';

sealed class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object> get props => [];
}

final class GetJobStream extends ReportsEvent {
  final List<JobModel> jobsStream;
  final List<JobModel> filteredJobs;
  final Set<String> selectedStatuses;

  const GetJobStream(
      {required this.jobsStream,
      required this.filteredJobs,
      required this.selectedStatuses});

  @override
  List<Object> get props => [jobsStream, filteredJobs, selectedStatuses];
}

final class ChangeFilterStatus extends ReportsEvent {
  final List<ValueItem<dynamic>> filterStatusList;
  const ChangeFilterStatus({required this.filterStatusList});
  @override
  List<Object> get props => [filterStatusList];
}
