part of 'jobs_stream_bloc.dart';

sealed class JobsStreamEvent extends Equatable {
  const JobsStreamEvent();

  @override
  List<Object> get props => [];
}

final class GetJobStream extends JobsStreamEvent {
  final List<JobModel> jobsStream;
  final List<JobModel> filteredJobs;
  final Set<JobStatus> selectedStatuses;

  const GetJobStream(
      {required this.jobsStream,
      required this.filteredJobs,
      required this.selectedStatuses});

  @override
  List<Object> get props => [jobsStream, filteredJobs, selectedStatuses];
}

// final class AddFilterStatus extends JobsStreamEvent {
//   final JobStatus status;
//   const AddFilterStatus({required this.status});
//   @override
//   List<Object> get props => [status];
// }

// final class RemoveFilterStatus extends JobsStreamEvent {
//   final JobStatus status;
//   const RemoveFilterStatus({required this.status});
//   @override
//   List<Object> get props => [status];
// }

final class ChangeFilterStatus extends JobsStreamEvent {
  final List<ValueItem<dynamic>> filterStatusList;
  const ChangeFilterStatus({required this.filterStatusList});
  @override
  List<Object> get props => [filterStatusList];
}
