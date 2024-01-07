part of 'forgot_password_bloc.dart';

enum ForgotPasswordStatus { initial, inProgress, success, failure }

final class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = '',
    this.isValid = false,
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final String email;
  final bool isValid;
  final ForgotPasswordStatus status;
  final String? errorMessage;
  final String? displayError;

  ForgotPasswordState copyWith({
    String? email,
    bool? isValid,
    ForgotPasswordStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      displayError: displayError,
    );
  }

  @override
  List<Object?> get props =>
      [email, isValid, status, errorMessage, displayError];
}
