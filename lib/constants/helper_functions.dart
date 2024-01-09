import 'package:energy_reimagined/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:energy_reimagined/widgets/network_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void checkConnectionFunc(BuildContext context, void Function() onPressed) {
  final connectivityState = context.read<ConnectivityBloc>().state;
  if (connectivityState is ConnectivityFailureState) {
    showDialog(
      context: context,
      builder: (_) => const NetworkErrorDialog(),
    );
  } else if (connectivityState is ConnectivitySuccessState) {
    onPressed();
  }
}
