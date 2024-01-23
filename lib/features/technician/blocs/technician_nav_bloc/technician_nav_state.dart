part of 'technician_nav_bloc.dart';

sealed class TechnicianNavState extends Equatable {
  final int tabIndex;

  const TechnicianNavState({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}

final class TechnicianNavCurrent extends TechnicianNavState {
  const TechnicianNavCurrent({required super.tabIndex});
}
