part of 'create_user_bloc.dart';

enum CreateUserStatus { initial, inProgress, success, failure }

final class CreateUserState extends Equatable {
  const CreateUserState({
    this.user = UserModel.empty,
    this.password = '',
    this.isValid = false,
    this.status = CreateUserStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final UserModel user;
  final String password;
  final bool isValid;
  final CreateUserStatus status;
  final String? errorMessage;
  final String? displayError;

  CreateUserState copyWith({
    UserModel? user,
    String? password,
    bool? isValid,
    CreateUserStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return CreateUserState(
      user: user ?? this.user,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      displayError: displayError,
    );
  }

  @override
  List<Object?> get props =>
      [user, password, isValid, status, errorMessage, displayError];
}
