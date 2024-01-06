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
      if (state.status == AuthenticationStatus.unknown) {
        //TODO: INCREASE DURATION TO 3 SECONDS
        Future.delayed(const Duration(seconds: 0), () {
          add(AuthenticationUserChanged(authUser));
        });
      } else {
        add(AuthenticationUserChanged(authUser));
      }
    });
    on<AuthenticationUserChanged>(_authenticationUserChanged);
    on<AuthenticationLogoutRequested>(_authenticationLogoutRequested);
  }

  FutureOr<void> _authenticationUserChanged(AuthenticationUserChanged event,
      Emitter<AuthenticationState> emit) async {
    try {
      if (event.user != null) {
        try {
          final currentUser =
              await _authenticationRepository.getUser(event.user!.uid);
          String role = currentUser.role;
          bool isRestricted = currentUser.isRestricted;
          if (isRestricted) {
            emit(const AuthenticationState.unauthenticated(
                'Your account is restricted'));
          } else if (role == 'admin') {
            emit(AuthenticationState.adminAuthenticated(
                event.user!, currentUser));
          } else if (role == 'manager') {
            emit(AuthenticationState.managerAuthenticated(
                event.user!, currentUser));
          } else if (role == 'technician') {
            emit(AuthenticationState.technicianAuthenticated(
                event.user!, currentUser));
          }
        } catch (e) {
          log(e.toString());
          emit(const AuthenticationState.unauthenticated(null));
        }
      } else {
        emit(const AuthenticationState.unauthenticated(null));
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
