part of 'edit_job_bloc.dart';

enum EditJobStatus { initial, inProgress, success, failure }

final class EditJobState extends Equatable {
  const EditJobState({
    required this.job,
    this.isValid = false,
    this.status = EditJobStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final JobModel job;
  final bool isValid;
  final EditJobStatus status;
  final String? errorMessage;
  final String? displayError;

  EditJobState copyWith({
    JobModel? job,
    bool? isValid,
    EditJobStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return EditJobState(
      job: job ?? this.job,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      displayError: displayError,
    );
  }

  @override
  List<Object?> get props => [job, isValid, status, errorMessage, displayError];
}
