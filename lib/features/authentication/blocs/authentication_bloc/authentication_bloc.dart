import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User?> _userSubscription;
  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen((authUser) {
      add(AuthenticationUserChanged(authUser));
    });
    on<AuthenticationUserChanged>(_authenticationUserChanged);
    on<AuthenticationLogoutRequested>(_authenticationLogoutRequested);
  }

  FutureOr<void> _authenticationUserChanged(AuthenticationUserChanged event,
      Emitter<AuthenticationState> emit) async {
    //TODO: GET CURRENT USER DATA FROM FIREBASE HERE
    try {
      if (event.user != null) {
        if (event.user!.uid == 'adminUid') {
          emit(AuthenticationState.adminauthenticated(event.user!));
        } else {
          try {
            final currentUser =
                await _authenticationRepository.getUser(event.user!.uid);
            emit(AuthenticationState.authenticated(
                event.user!, currentUser, null));
          } catch (e) {
            log(e.toString());
            emit(const AuthenticationState.unauthenticated());
          }
        }
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    } catch (e) {
      log(e.toString());
      // rethrow;
    }
  }

  void _authenticationLogoutRequested(
      AuthenticationLogoutRequested event, Emitter<AuthenticationState> emit) {
    try {
      unawaited(_authenticationRepository.signOut());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
