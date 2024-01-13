part of 'jobs_stream_bloc.dart';

enum JobsStreamStatus { loading, success, failure }

class JobsStreamState extends Equatable {
  final JobsStreamStatus status;
  final List<JobModel>? jobStream;
  final List<JobModel>? filteredJobs;
  final Set<JobStatus> selectedStatuses;

  const JobsStreamState._({
    this.status = JobsStreamStatus.loading,
    this.jobStream,
    this.filteredJobs,
    required this.selectedStatuses,
  });

  JobsStreamState.loading() : this._(selectedStatuses: {});

  const JobsStreamState.success(List<JobModel> jobStream,
      List<JobModel> filteredJobs, Set<JobStatus> selectedStatuses)
      : this._(
            status: JobsStreamStatus.success,
            jobStream: jobStream,
            filteredJobs: filteredJobs,
            selectedStatuses: selectedStatuses);

  JobsStreamState.failure()
      : this._(status: JobsStreamStatus.failure, selectedStatuses: {});

  @override
  List<Object?> get props =>
      [status, jobStream, filteredJobs, selectedStatuses];
}
