import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository _authenticationRepository;
  SignUpBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignUpState()) {
    on<SignUpWithEmailAndPassword>(_signUpWithEmailAndPassword);
    on<FirstNameChanged>(_firstNameChanged);
    on<LastNameChanged>(_lastNameChanged);
    on<EmployeeNumberChanged>(_employeeNumberChanged);
    on<RoleChanged>(_roleChanged);
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
  }

  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //final passwordRegExp =RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //Add a proper password regexp for validation

  FutureOr<void> _signUpWithEmailAndPassword(
      SignUpWithEmailAndPassword event, Emitter<SignUpState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(
          status: SignUpStatus.failure, errorMessage: 'Invalid Form Data'));
      emit(state.copyWith(status: SignUpStatus.initial));
      return;
    }
    emit(state.copyWith(status: SignUpStatus.inProgress));
    try {
      UserModel authUser = await _authenticationRepository.signUp(
          myUser: state.user, password: state.password);

      final newUser =
          authUser.copyWith(createdAt: DateTime.now().microsecondsSinceEpoch);

      await _authenticationRepository.setUserData(newUser);

      emit(state.copyWith(status: SignUpStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
          status: SignUpStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: SignUpStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: SignUpStatus.failure));
      emit(state.copyWith(status: SignUpStatus.initial));
    }
  }

  FutureOr<void> _firstNameChanged(
      FirstNameChanged event, Emitter<SignUpState> emit) {
    final FirstNameValidationStatus firstNameValidationStatus =
        _validateFirstName(event.firstName);
    emit(
      state.copyWith(
        user: state.user.copyWith(firstName: event.firstName),
        isValid: _validate(
            firstName: event.firstName,
            lastName: state.user.lastName,
            password: state.password,
            email: state.user.email,
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
      LastNameChanged event, Emitter<SignUpState> emit) {
    final LastNameValidationStatus lastNameValidationStatus =
        _validateLastName(event.lastName);
    emit(
      state.copyWith(
        user: state.user.copyWith(lastName: event.lastName),
        isValid: _validate(
            firstName: state.user.firstName,
            lastName: event.lastName,
            password: state.password,
            email: state.user.email,
            employeeNumber: state.user.employeeNumber,
            role: state.user.role),
        displayError: lastNameValidationStatus == LastNameValidationStatus.empty
            ? 'Please enter a last name'
            : null,
      ),
    );
  }

  FutureOr<void> _emailChanged(EmailChanged event, Emitter<SignUpState> emit) {
    final EmailValidationStatus emailValidationStatus =
        _validateEmail(event.email);

    emit(
      state.copyWith(
        user: state.user.copyWith(email: event.email),
        isValid: _validate(
            firstName: state.user.firstName,
            lastName: state.user.lastName,
            password: state.password,
            email: event.email,
            employeeNumber: state.user.employeeNumber,
            role: state.user.role),
        displayError: emailValidationStatus == EmailValidationStatus.empty
            ? 'Please enter an email'
            : emailValidationStatus == EmailValidationStatus.invalid
                ? 'Please enter a valid email'
                : null,
      ),
    );
  }

  FutureOr<void> _passwordChanged(
      PasswordChanged event, Emitter<SignUpState> emit) {
    final PasswordValidationStatus passwordValidationStatus =
        _validatePassword(event.password);

    emit(
      state.copyWith(
        password: event.password,
        isValid: _validate(
            firstName: state.user.firstName,
            lastName: state.user.lastName,
            password: event.password,
            email: state.user.email,
            employeeNumber: state.user.employeeNumber,
            role: state.user.role),
        displayError: passwordValidationStatus == PasswordValidationStatus.empty
            ? 'Please enter a password'
            : passwordValidationStatus == PasswordValidationStatus.invalid
                ? 'Please enter a valid password of atleast 8 characters length'
                : null,
      ),
    );
  }

  FutureOr<void> _employeeNumberChanged(
      EmployeeNumberChanged event, Emitter<SignUpState> emit) {
    final EmployeeNumberValidationStatus employeeNumberValidationStatus =
        _validateEmployeeNumber(event.employeeNumber);
    emit(
      state.copyWith(
        user: state.user.copyWith(employeeNumber: event.employeeNumber),
        isValid: _validate(
            firstName: state.user.firstName,
            lastName: state.user.lastName,
            password: state.password,
            email: state.user.email,
            employeeNumber: event.employeeNumber,
            role: state.user.role),
        displayError: employeeNumberValidationStatus ==
                EmployeeNumberValidationStatus.empty
            ? 'Please enter an employee number'
            : null,
      ),
    );
  }

  FutureOr<void> _roleChanged(RoleChanged event, Emitter<SignUpState> emit) {
    final RoleValidationStatus roleValidationStatus = _validateRole(event.role);
    emit(
      state.copyWith(
        user: state.user.copyWith(role: event.role),
        isValid: _validate(
            firstName: state.user.firstName,
            lastName: state.user.lastName,
            password: state.password,
            email: state.user.email,
            employeeNumber: state.user.employeeNumber,
            role: event.role),
        displayError: roleValidationStatus == RoleValidationStatus.empty
            ? 'Please enter some role'
            : null,
      ),
    );
  }

  bool _validate({
    required firstName,
    required String lastName,
    required String password,
    required String email,
    required String employeeNumber,
    required String role,
  }) {
    final FirstNameValidationStatus firstNameValidationStatus =
        _validateFirstName(firstName);
    final LastNameValidationStatus lastNameValidationStatus =
        _validateLastName(lastName);
    final PasswordValidationStatus passwordValidationStatus =
        _validatePassword(password);
    final EmailValidationStatus emailValidationStatus = _validateEmail(email);
    final EmployeeNumberValidationStatus employeeNumberValidationStatus =
        _validateEmployeeNumber(employeeNumber);
    final RoleValidationStatus roleValidationStatus = _validateRole(role);

    return passwordValidationStatus == PasswordValidationStatus.valid &&
        emailValidationStatus == EmailValidationStatus.valid &&
        firstNameValidationStatus == FirstNameValidationStatus.valid &&
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

  EmailValidationStatus _validateEmail(String email) {
    if (email.isEmpty) {
      return EmailValidationStatus.empty;
    } else if (!emailRegExp.hasMatch(email)) {
      return EmailValidationStatus.invalid;
    } else {
      return EmailValidationStatus.valid;
    }
  }

  PasswordValidationStatus _validatePassword(String password) {
    if (password.isEmpty) {
      return PasswordValidationStatus.empty;
    } else if (password.length > 7) {
      return PasswordValidationStatus.valid;
    } else {
      return PasswordValidationStatus.invalid;
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

enum EmailValidationStatus { empty, invalid, valid }

enum PasswordValidationStatus { empty, invalid, valid }

enum FirstNameValidationStatus { empty, valid }

enum LastNameValidationStatus { empty, valid }

enum EmployeeNumberValidationStatus { empty, valid }

enum RoleValidationStatus { empty, valid }
