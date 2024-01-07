import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthenticationRepository _authenticationRepository;

  ForgotPasswordBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const ForgotPasswordState()) {
    on<ForgotPassword>(_forgotPassword);
    on<EmailChanged>(_emailChanged);
  }
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  FutureOr<void> _forgotPassword(
      ForgotPassword event, Emitter<ForgotPasswordState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: 'Invalid Form Data'));
      emit(state.copyWith(status: ForgotPasswordStatus.initial));
      return;
    }
    emit(state.copyWith(status: ForgotPasswordStatus.inProgress));
    try {
      await _authenticationRepository.forgotPassword(state.email);
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } on SendPasswordResetEmailFailure catch (e) {
      emit(state.copyWith(
          status: ForgotPasswordStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: ForgotPasswordStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: ForgotPasswordStatus.failure));
      emit(state.copyWith(status: ForgotPasswordStatus.initial));
    }
  }

  FutureOr<void> _emailChanged(
      EmailChanged event, Emitter<ForgotPasswordState> emit) {
    final EmailValidationStatus emailValidationStatus =
        _validateEmail(event.email);
    emit(
      state.copyWith(
        email: event.email,
        isValid: _validate(event.email),
        displayError: emailValidationStatus == EmailValidationStatus.empty
            ? 'Please enter an email'
            : emailValidationStatus == EmailValidationStatus.invalid
                ? 'Please enter a valid email'
                : null,
      ),
    );
  }

  bool _validate(String email) {
    final EmailValidationStatus emailValidationStatus = _validateEmail(email);

    return emailValidationStatus == EmailValidationStatus.valid;
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
}

enum EmailValidationStatus { empty, invalid, valid }
