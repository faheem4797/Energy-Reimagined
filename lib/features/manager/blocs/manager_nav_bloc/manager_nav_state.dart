part of 'manager_nav_bloc.dart';

sealed class ManagerNavState extends Equatable {
  final int tabIndex;
  const ManagerNavState({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}

final class ManagerNavCurrent extends ManagerNavState {
  const ManagerNavCurrent({required super.tabIndex});
}
