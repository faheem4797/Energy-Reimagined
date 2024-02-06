part of 'manager_nav_bloc.dart';

sealed class ManagerNavEvent extends Equatable {
  const ManagerNavEvent();

  @override
  List<Object> get props => [];
}

class TabChange extends ManagerNavEvent {
  final int tabIndex;

  const TabChange({required this.tabIndex});
}
