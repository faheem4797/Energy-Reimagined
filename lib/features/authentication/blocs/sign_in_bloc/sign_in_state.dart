part of 'sign_in_bloc.dart';

enum SignInStatus { initial, inProgress, success, failure }

final class SignInState extends Equatable {
  const SignInState({
    this.email = '',
    this.password = '',
    this.isValid = false,
    this.status = SignInStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final String email;
  final String password;
  final bool isValid;
  final SignInStatus status;
  final String? errorMessage;
  final String? displayError;

  SignInState copyWith({
    String? email,
    String? password,
    bool? isValid,
    SignInStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      displayError: displayError,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, isValid, status, errorMessage, displayError];
}
