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
    on<NameChanged>(_nameChanged);
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

      await _authenticationRepository.setUserData(authUser);

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

  FutureOr<void> _nameChanged(NameChanged event, Emitter<SignUpState> emit) {
    final NameValidationStatus nameValidationStatus = _validateName(event.name);
    emit(
      state.copyWith(
        user: state.user.copyWith(name: event.name),
        isValid: _validate(event.name, state.password, state.user.email),
        displayError: nameValidationStatus == NameValidationStatus.empty
            ? 'Please enter a name'
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
        isValid: _validate(state.user.name, state.password, event.email),
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
        isValid: _validate(state.user.name, event.password, state.user.email),
        displayError: passwordValidationStatus == PasswordValidationStatus.empty
            ? 'Please enter a password'
            : passwordValidationStatus == PasswordValidationStatus.invalid
                ? 'Please enter a valid password of atleast 8 characters length'
                : null,
      ),
    );
  }

  bool _validate(String name, String password, String email) {
    final PasswordValidationStatus passwordValidationStatus =
        _validatePassword(password);
    final EmailValidationStatus emailValidationStatus = _validateEmail(email);
    final NameValidationStatus nameValidationStatus = _validateName(name);

    return passwordValidationStatus == PasswordValidationStatus.valid &&
        emailValidationStatus == EmailValidationStatus.valid &&
        nameValidationStatus == NameValidationStatus.valid;
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

  NameValidationStatus _validateName(String name) {
    if (name.isEmpty) {
      return NameValidationStatus.empty;
    } else {
      return NameValidationStatus.valid;
    }
  }
}

enum EmailValidationStatus { empty, invalid, valid }

enum PasswordValidationStatus { empty, invalid, valid }

enum NameValidationStatus { empty, valid }
