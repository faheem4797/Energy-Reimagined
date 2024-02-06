import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'manager_nav_event.dart';
part 'manager_nav_state.dart';

class ManagerNavBloc extends Bloc<ManagerNavEvent, ManagerNavState> {
  ManagerNavBloc() : super(const ManagerNavCurrent(tabIndex: 0)) {
    on<ManagerNavEvent>((event, emit) {
      if (event is TabChange) {
        emit(ManagerNavCurrent(tabIndex: event.tabIndex));
      }
    });
  }
}
