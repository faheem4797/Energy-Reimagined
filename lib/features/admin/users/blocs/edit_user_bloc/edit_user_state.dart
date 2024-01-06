part of 'edit_user_bloc.dart';

enum EditUserStatus { initial, inProgress, success, failure }

final class EditUserState extends Equatable {
  const EditUserState({
    //this.user = UserModel.empty,
    required this.user,
    this.isValid = false,
    this.status = EditUserStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final UserModel user;
  final bool isValid;
  final EditUserStatus status;
  final String? errorMessage;
  final String? displayError;

  EditUserState copyWith({
    UserModel? user,
    bool? isValid,
    EditUserStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return EditUserState(
      user: user ?? this.user,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      displayError: displayError,
    );
  }

  @override
  List<Object?> get props =>
      [user, isValid, status, errorMessage, displayError];
}
