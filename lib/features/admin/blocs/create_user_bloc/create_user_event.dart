part of 'create_user_bloc.dart';

sealed class CreateUserEvent extends Equatable {
  const CreateUserEvent();

  @override
  List<Object> get props => [];
}

final class CreateUserWithEmailAndPassword extends CreateUserEvent {}

final class FirstNameChanged extends CreateUserEvent {
  final String firstName;
  const FirstNameChanged({required this.firstName});

  @override
  List<Object> get props => [firstName];
}

final class LastNameChanged extends CreateUserEvent {
  final String lastName;
  const LastNameChanged({required this.lastName});

  @override
  List<Object> get props => [lastName];
}

final class EmployeeNumberChanged extends CreateUserEvent {
  final String employeeNumber;
  const EmployeeNumberChanged({required this.employeeNumber});

  @override
  List<Object> get props => [employeeNumber];
}

final class EmailChanged extends CreateUserEvent {
  final String email;
  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

final class PasswordChanged extends CreateUserEvent {
  final String password;
  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

final class RoleChanged extends CreateUserEvent {
  final String role;
  const RoleChanged({required this.role});

  @override
  List<Object> get props => [role];
}
