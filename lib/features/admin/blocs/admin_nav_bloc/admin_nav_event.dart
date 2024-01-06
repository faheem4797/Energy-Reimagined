part of 'admin_nav_bloc.dart';

sealed class AdminNavEvent extends Equatable {
  const AdminNavEvent();

  @override
  List<Object> get props => [];
}

class TabChange extends AdminNavEvent {
  final int tabIndex;

  const TabChange({required this.tabIndex});
}
