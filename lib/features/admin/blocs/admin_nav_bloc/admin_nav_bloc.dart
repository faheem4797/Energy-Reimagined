import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_nav_event.dart';
part 'admin_nav_state.dart';

class AdminNavBloc extends Bloc<AdminNavEvent, AdminNavState> {
  AdminNavBloc() : super(const AdminNavCurrent(tabIndex: 0)) {
    on<AdminNavEvent>((event, emit) {
      if (event is TabChange) {
        emit(AdminNavCurrent(tabIndex: event.tabIndex));
      }
    });
  }
}
