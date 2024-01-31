part of 'complete_job_bloc.dart';

enum CompleteJobStatus { initial, inProgress, success, failure }

final class CompleteJobState extends Equatable {
  const CompleteJobState({
    this.status = CompleteJobStatus.initial,
    this.errorMessage,
  });
  final CompleteJobStatus status;
  final String? errorMessage;

  CompleteJobState copyWith({
    JobModel? job,
    CompleteJobStatus? status,
    String? errorMessage,
  }) {
    return CompleteJobState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];
}
