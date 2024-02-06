part of 'escalations_bloc.dart';

enum EscalationsStatus { loading, success, failure }

class EscalationsState extends Equatable {
  final EscalationsStatus status;
  final List<JobModel>? escalatedJobs;
  final List<JobModel>? filteredEscalations;
  final Set<JobStatus> selectedStatuses;

  const EscalationsState._({
    this.status = EscalationsStatus.loading,
    this.escalatedJobs,
    this.filteredEscalations,
    required this.selectedStatuses,
  });

  EscalationsState.loading() : this._(selectedStatuses: {});

  const EscalationsState.success(List<JobModel> escalatedJobs,
      List<JobModel> filteredEscalations, Set<JobStatus> selectedStatuses)
      : this._(
            status: EscalationsStatus.success,
            escalatedJobs: escalatedJobs,
            filteredEscalations: filteredEscalations,
            selectedStatuses: selectedStatuses);

  EscalationsState.failure()
      : this._(status: EscalationsStatus.failure, selectedStatuses: {});

  @override
  List<Object?> get props =>
      [status, escalatedJobs, filteredEscalations, selectedStatuses];
}
