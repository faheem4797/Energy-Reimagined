part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class SignUpWithEmailAndPassword extends SignUpEvent {}

final class NameChanged extends SignUpEvent {
  final String name;
  const NameChanged({required this.name});

  @override
  List<Object> get props => [name];
}

final class EmailChanged extends SignUpEvent {
  final String email;
  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

final class PasswordChanged extends SignUpEvent {
  final String password;
  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}
