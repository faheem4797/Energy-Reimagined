part of 'technician_jobs_stream_bloc.dart';

enum JobsStreamStatus { loading, success, failure }

class TechnicianJobsStreamState extends Equatable {
  final JobsStreamStatus status;
  final List<JobModel>? jobStream;
  final List<JobModel>? filteredJobs;
  final Set<JobStatus> selectedStatuses;

  const TechnicianJobsStreamState._({
    this.status = JobsStreamStatus.loading,
    this.jobStream,
    this.filteredJobs,
    required this.selectedStatuses,
  });

  TechnicianJobsStreamState.loading() : this._(selectedStatuses: {});

  const TechnicianJobsStreamState.success(List<JobModel> jobStream,
      List<JobModel> filteredJobs, Set<JobStatus> selectedStatuses)
      : this._(
            status: JobsStreamStatus.success,
            jobStream: jobStream,
            filteredJobs: filteredJobs,
            selectedStatuses: selectedStatuses);

  TechnicianJobsStreamState.failure()
      : this._(status: JobsStreamStatus.failure, selectedStatuses: {});

  @override
  List<Object?> get props =>
      [status, jobStream, filteredJobs, selectedStatuses];
}
