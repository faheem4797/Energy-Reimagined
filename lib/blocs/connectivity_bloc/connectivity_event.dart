part of 'connectivity_bloc.dart';

/// The base abstract class for different connectivity events.
/// It is marked as immutable, indicating that its subclasses should also be immutable.
@immutable
abstract class ConnectivityEvent {}

class CheckConnectionEvent extends ConnectivityEvent {}

/// Represents an event when connectivity is established.
class ConnectedEvent extends ConnectivityEvent {}

/// Represents an event when connectivity is lost.
class DisconnectedEvent extends ConnectivityEvent {}
