part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

final class ForgotPassword extends ForgotPasswordEvent {}

final class EmailChanged extends ForgotPasswordEvent {
  final String email;
  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}
