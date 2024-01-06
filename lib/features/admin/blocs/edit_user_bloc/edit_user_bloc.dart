import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  final AuthenticationRepository _authenticationRepository;
  final UserModel oldUserModel;
  EditUserBloc(
      {required AuthenticationRepository authenticationRepository,
      required this.oldUserModel})
      : _authenticationRepository = authenticationRepository,
        super(EditUserState(user: oldUserModel)) {
    on<EditUserWithUpdatedUserModel>(_editUserWithUpdatedUserModel);
    on<FirstNameChanged>(_firstNameChanged);
    on<LastNameChanged>(_lastNameChanged);
    on<EmployeeNumberChanged>(_employeeNumberChanged);
    on<RoleChanged>(_roleChanged);
    on<RestrictionChanged>(_restrictionChanged);
  }

  FutureOr<void> _editUserWithUpdatedUserModel(
      EditUserWithUpdatedUserModel event, Emitter<EditUserState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(
          status: EditUserStatus.failure, errorMessage: 'Invalid Form Data'));
      emit(state.copyWith(status: EditUserStatus.initial));
      return;
    }
    emit(state.copyWith(status: EditUserStatus.inProgress));
    try {
      // final newUser =
      //     authUser.copyWith(createdAt: DateTime.now().microsecondsSinceEpoch);

      await _authenticationRepository.setUserData(state.user);

      emit(state.copyWith(status: EditUserStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
          status: EditUserStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: EditUserStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: EditUserStatus.failure));
      emit(state.copyWith(status: EditUserStatus.initial));
    }
  }

  FutureOr<void> _firstNameChanged(
      FirstNameChanged event, Emitter<EditUserState> emit) {
    final FirstNameValidationStatus firstNameValidationStatus =
        _validateFirstName(event.firstName);
    emit(
      state.copyWith(
        user: state.user.copyWith(firstName: event.firstName),
        isValid: _validate(
            firstName: event.firstName,
            lastName: state.user.lastName,
            employeeNumber: state.user.employeeNumber,
            role: state.user.role),
        displayError:
            firstNameValidationStatus == FirstNameValidationStatus.empty
                ? 'Please enter a first name'
                : null,
      ),
    );
  }

  FutureOr<void> _lastNameChanged(
      LastNameChanged event, Emitter<EditUserState> emit) {
    final LastNameValidationStatus lastNameValidationStatus =
        _validateLastName(event.lastName);
    emit(
      state.copyWith(
        user: state.user.copyWith(lastName: event.lastName),
        isValid: _validate(
            firstName: state.user.firstName,
            lastName: event.lastName,
            employeeNumber: state.user.employeeNumber,
            role: state.user.role),
        displayError: lastNameValidationStatus == LastNameValidationStatus.empty
            ? 'Please enter a last name'
            : null,
      ),
    );
  }

  FutureOr<void> _roleChanged(RoleChanged event, Emitter<EditUserState> emit) {
    final RoleValidationStatus roleValidationStatus = _validateRole(event.role);
    emit(
      state.copyWith(
        user: state.user.copyWith(role: event.role),
        isValid: _validate(
            firstName: state.user.firstName,
            lastName: state.user.lastName,
            employeeNumber: state.user.employeeNumber,
            role: event.role),
        displayError: roleValidationStatus == RoleValidationStatus.empty
            ? 'Please enter some role'
            : null,
      ),
    );
  }

  FutureOr<void> _employeeNumberChanged(
      EmployeeNumberChanged event, Emitter<EditUserState> emit) {
    final EmployeeNumberValidationStatus employeeNumberValidationStatus =
        _validateEmployeeNumber(event.employeeNumber);
    emit(
      state.copyWith(
        user: state.user.copyWith(employeeNumber: event.employeeNumber),
        isValid: _validate(
            firstName: state.user.firstName,
            lastName: state.user.lastName,
            employeeNumber: event.employeeNumber,
            role: state.user.role),
        displayError: employeeNumberValidationStatus ==
                EmployeeNumberValidationStatus.empty
            ? 'Please enter an employee number'
            : null,
      ),
    );
  }

  FutureOr<void> _restrictionChanged(
      RestrictionChanged event, Emitter<EditUserState> emit) {
    emit(
      state.copyWith(
        user: state.user.copyWith(isRestricted: event.isRestricted),
      ),
    );
  }

  bool _validate({
    required String firstName,
    required String lastName,
    required String employeeNumber,
    required String role,
  }) {
    final FirstNameValidationStatus firstNameValidationStatus =
        _validateFirstName(firstName);
    final LastNameValidationStatus lastNameValidationStatus =
        _validateLastName(lastName);

    final EmployeeNumberValidationStatus employeeNumberValidationStatus =
        _validateEmployeeNumber(employeeNumber);
    final RoleValidationStatus roleValidationStatus = _validateRole(role);

    return firstNameValidationStatus == FirstNameValidationStatus.valid &&
        lastNameValidationStatus == LastNameValidationStatus.valid &&
        employeeNumberValidationStatus ==
            EmployeeNumberValidationStatus.valid &&
        roleValidationStatus == RoleValidationStatus.valid;
  }

  FirstNameValidationStatus _validateFirstName(String firstName) {
    if (firstName.isEmpty) {
      return FirstNameValidationStatus.empty;
    } else {
      return FirstNameValidationStatus.valid;
    }
  }

  LastNameValidationStatus _validateLastName(String lastName) {
    if (lastName.isEmpty) {
      return LastNameValidationStatus.empty;
    } else {
      return LastNameValidationStatus.valid;
    }
  }

  EmployeeNumberValidationStatus _validateEmployeeNumber(
      String employeeNumber) {
    if (employeeNumber.isEmpty) {
      return EmployeeNumberValidationStatus.empty;
    } else {
      return EmployeeNumberValidationStatus.valid;
    }
  }

  RoleValidationStatus _validateRole(String role) {
    if (role.isEmpty) {
      return RoleValidationStatus.empty;
    } else {
      return RoleValidationStatus.valid;
    }
  }
}

enum FirstNameValidationStatus { empty, valid }

enum LastNameValidationStatus { empty, valid }

enum EmployeeNumberValidationStatus { empty, valid }

enum RoleValidationStatus { empty, valid }
