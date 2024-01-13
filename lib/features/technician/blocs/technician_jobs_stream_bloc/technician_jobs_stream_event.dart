part of 'technician_jobs_stream_bloc.dart';

sealed class TechnicianJobsStreamEvent extends Equatable {
  const TechnicianJobsStreamEvent();

  @override
  List<Object> get props => [];
}

final class GetJobStream extends TechnicianJobsStreamEvent {
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

final class AddFilterStatus extends TechnicianJobsStreamEvent {
  final JobStatus status;
  const AddFilterStatus({required this.status});
  @override
  List<Object> get props => [status];
}

final class RemoveFilterStatus extends TechnicianJobsStreamEvent {
  final JobStatus status;
  const RemoveFilterStatus({required this.status});
  @override
  List<Object> get props => [status];
}
