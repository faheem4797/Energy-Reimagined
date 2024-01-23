part of 'technician_nav_bloc.dart';

sealed class TechnicianNavEvent extends Equatable {
  const TechnicianNavEvent();

  @override
  List<Object> get props => [];
}

class TabChange extends TechnicianNavEvent {
  final int tabIndex;

  const TabChange({required this.tabIndex});
}
