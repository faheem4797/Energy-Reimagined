part of 'edit_job_bloc.dart';

enum EditJobStatus { initial, inProgress, success, failure }

final class EditJobState extends Equatable {
  const EditJobState({
    required this.job,
    required this.filteredUsers,
    this.isValid = false,
    this.status = EditJobStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final JobModel job;
  final List<UserModel> filteredUsers;
  final bool isValid;
  final EditJobStatus status;
  final String? errorMessage;
  final String? displayError;

  EditJobState copyWith({
    List<UserModel>? filteredUsers,
    JobModel? job,
    bool? isValid,
    EditJobStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return EditJobState(
      job: job ?? this.job,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      displayError: displayError,
    );
  }

  @override
  List<Object?> get props =>
      [job, filteredUsers, isValid, status, errorMessage, displayError];
}
