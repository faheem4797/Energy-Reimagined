import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationRepository _authenticationRepository;
  SignInBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignInState()) {
    on<SignInWithEmailAndPassword>(_logInWithEmailAndPassword);
    on<SendSupportEmail>(_sendSupportEmail);
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
  }

  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //final passwordRegExp =RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //Add a proper password regexp for validation

  FutureOr<void> _logInWithEmailAndPassword(
      SignInWithEmailAndPassword event, Emitter<SignInState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(
          status: SignInStatus.failure, errorMessage: 'Invalid Form Data'));
      emit(state.copyWith(status: SignInStatus.initial));
      return;
    }
    emit(state.copyWith(status: SignInStatus.inProgress));
    try {
      await _authenticationRepository.signIn(
          email: state.email, password: state.password);
      emit(state.copyWith(status: SignInStatus.success));
    } on SignInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
          status: SignInStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: SignInStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: SignInStatus.failure));
      emit(state.copyWith(status: SignInStatus.initial));
    }
  }

  FutureOr<void> _sendSupportEmail(
      SendSupportEmail event, Emitter<SignInState> emit) {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto', path: 'support@gmail.com', query: 'subject=Re: app');
    launchUrl(emailLaunchUri);
  }

  FutureOr<void> _emailChanged(EmailChanged event, Emitter<SignInState> emit) {
    final EmailValidationStatus emailValidationStatus =
        _validateEmail(event.email);
    emit(
      state.copyWith(
        email: event.email,
        isValid: _validate(state.password, event.email),
        displayError: emailValidationStatus == EmailValidationStatus.empty
            ? 'Please enter an email'
            : emailValidationStatus == EmailValidationStatus.invalid
                ? 'Please enter a valid email'
                : null,
      ),
    );
  }

  FutureOr<void> _passwordChanged(
      PasswordChanged event, Emitter<SignInState> emit) {
    final PasswordValidationStatus passwordValidationStatus =
        _validatePassword(event.password);
    emit(
      state.copyWith(
        password: event.password,
        isValid: _validate(event.password, state.email),
        displayError: passwordValidationStatus == PasswordValidationStatus.empty
            ? 'Please enter a password'
            : passwordValidationStatus == PasswordValidationStatus.invalid
                ? 'Please enter a valid password of atleast 8 characters length'
                : null,
      ),
    );
  }

  bool _validate(String password, String email) {
    final PasswordValidationStatus passwordValidationStatus =
        _validatePassword(password);
    final EmailValidationStatus emailValidationStatus = _validateEmail(email);

    return passwordValidationStatus == PasswordValidationStatus.valid &&
        emailValidationStatus == EmailValidationStatus.valid;
  }

  EmailValidationStatus _validateEmail(String email) {
    if (email.isEmpty) {
      return EmailValidationStatus.empty;
    } else if (emailRegExp.hasMatch(email)) {
      return EmailValidationStatus.valid;
    } else {
      return EmailValidationStatus.invalid;
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
}

enum EmailValidationStatus { empty, invalid, valid }

enum PasswordValidationStatus { empty, invalid, valid }
