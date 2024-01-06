part of 'edit_user_bloc.dart';

sealed class EditUserEvent extends Equatable {
  const EditUserEvent();

  @override
  List<Object> get props => [];
}

final class EditUserWithUpdatedUserModel extends EditUserEvent {}

final class FirstNameChanged extends EditUserEvent {
  final String firstName;
  const FirstNameChanged({required this.firstName});

  @override
  List<Object> get props => [firstName];
}

final class LastNameChanged extends EditUserEvent {
  final String lastName;
  const LastNameChanged({required this.lastName});

  @override
  List<Object> get props => [lastName];
}

final class EmployeeNumberChanged extends EditUserEvent {
  final String employeeNumber;
  const EmployeeNumberChanged({required this.employeeNumber});

  @override
  List<Object> get props => [employeeNumber];
}

final class RoleChanged extends EditUserEvent {
  final String role;
  const RoleChanged({required this.role});

  @override
  List<Object> get props => [role];
}

final class RestrictionChanged extends EditUserEvent {
  final bool isRestricted;
  const RestrictionChanged({required this.isRestricted});

  @override
  List<Object> get props => [isRestricted];
}
