part of 'sign_up_bloc.dart';

enum SignUpStatus { initial, inProgress, success, failure }

final class SignUpState extends Equatable {
  const SignUpState({
    this.user = UserModel.empty,
    this.password = '',
    this.isValid = false,
    this.status = SignUpStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final UserModel user;
  final String password;
  final bool isValid;
  final SignUpStatus status;
  final String? errorMessage;
  final String? displayError;

  SignUpState copyWith({
    UserModel? user,
    String? password,
    bool? isValid,
    SignUpStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return SignUpState(
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
