part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

final class SignInWithEmailAndPassword extends SignInEvent {}

final class EmailChanged extends SignInEvent {
  final String email;
  const EmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

final class PasswordChanged extends SignInEvent {
  final String password;
  const PasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}
