part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class SignUpWithEmailAndPassword extends SignUpEvent {}

final class FirstNameChanged extends SignUpEvent {
  final String firstName;
  const FirstNameChanged({required this.firstName});

  @override
  List<Object> get props => [firstName];
}

final class LastNameChanged extends SignUpEvent {
  final String lastName;
  const LastNameChanged({required this.lastName});

  @override
  List<Object> get props => [lastName];
}

final class EmployeeNumberChanged extends SignUpEvent {
  final String employeeNumber;
  const EmployeeNumberChanged({required this.employeeNumber});

  @override
  List<Object> get props => [employeeNumber];
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

final class RoleChanged extends SignUpEvent {
  final String role;
  const RoleChanged({required this.role});

  @override
  List<Object> get props => [role];
}
