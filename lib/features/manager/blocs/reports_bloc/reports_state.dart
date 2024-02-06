part of 'reports_bloc.dart';

enum ReportsStreamStatus { loading, success, failure }

class ReportsState extends Equatable {
  final ReportsStreamStatus status;
  final List<JobModel>? jobStream;
  final List<JobModel>? filteredJobs;
  final Set<String> selectedStatuses;

  const ReportsState._({
    this.status = ReportsStreamStatus.loading,
    this.jobStream,
    this.filteredJobs,
    required this.selectedStatuses,
  });

  ReportsState.loading() : this._(selectedStatuses: {});

  const ReportsState.success(List<JobModel> jobStream,
      List<JobModel> filteredJobs, Set<String> selectedStatuses)
      : this._(
            status: ReportsStreamStatus.success,
            jobStream: jobStream,
            filteredJobs: filteredJobs,
            selectedStatuses: selectedStatuses);

  ReportsState.failure()
      : this._(status: ReportsStreamStatus.failure, selectedStatuses: {});

  @override
  List<Object?> get props =>
      [status, jobStream, filteredJobs, selectedStatuses];
}
