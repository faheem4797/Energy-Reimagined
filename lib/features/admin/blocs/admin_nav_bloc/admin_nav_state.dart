part of 'admin_nav_bloc.dart';

sealed class AdminNavState extends Equatable {
  final int tabIndex;
  const AdminNavState({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}

final class AdminNavCurrent extends AdminNavState {
  const AdminNavCurrent({required super.tabIndex});
}
