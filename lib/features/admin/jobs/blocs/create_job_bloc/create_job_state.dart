part of 'create_job_bloc.dart';

enum CreateJobStatus { initial, inProgress, success, failure }

//TODO: add a dropdown in job creation named 'municipality'. dropdown shows a list of municipalities

final class CreateJobState extends Equatable {
  const CreateJobState({
    this.job = JobModel.empty,
    this.isValid = false,
    this.status = CreateJobStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final JobModel job;
  final bool isValid;
  final CreateJobStatus status;
  final String? errorMessage;
  final String? displayError;

  CreateJobState copyWith({
    JobModel? job,
    bool? isValid,
    CreateJobStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return CreateJobState(
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
