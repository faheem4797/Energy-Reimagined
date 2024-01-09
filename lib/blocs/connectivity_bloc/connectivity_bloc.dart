import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  StreamSubscription? _subscription;

  ConnectivityBloc() : super(ConnectivityInitialState()) {
    on<ConnectedEvent>((event, emit) => emit(ConnectivitySuccessState()));
    on<DisconnectedEvent>((event, emit) => emit(ConnectivityFailureState()));
    on<CheckConnectionEvent>(_checkConnectionEvent);

    // Subscribe to connectivity changes using the `Connectivity` plugin.
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // If the connectivity result is mobile or wifi, add an 'ConnectedEvent'.
        add(ConnectedEvent());
      } else {
        // Otherwise, add an 'DisconnectedEvent'.
        add(DisconnectedEvent());
      }
    });
  }
  FutureOr<void> _checkConnectionEvent(
      CheckConnectionEvent event, Emitter<ConnectivityState> emit) async {
    final connectionResult = await Connectivity().checkConnectivity();
    if (connectionResult == ConnectivityResult.mobile ||
        connectionResult == ConnectivityResult.wifi) {
      // If the connectivity result is mobile or wifi, add an 'ConnectedEvent'.
      add(ConnectedEvent());
    } else {
      // Otherwise, add an 'DisconnectedEvent'.
      add(DisconnectedEvent());
    }

    /// Closes the BLoC and performs necessary cleanup.

    @override
    Future<void> close() {
      _subscription
          ?.cancel(); // Cancel the subscription to stop listening for connectivity changes.
      return super.close(); // Close the BLoC and release any resources.
    }
  }
}
