import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'technician_nav_event.dart';
part 'technician_nav_state.dart';

class TechnicianNavBloc extends Bloc<TechnicianNavEvent, TechnicianNavState> {
  TechnicianNavBloc() : super(const TechnicianNavCurrent(tabIndex: 0)) {
    on<TechnicianNavEvent>((event, emit) {
      if (event is TabChange) {
        emit(TechnicianNavCurrent(tabIndex: event.tabIndex));
      }
    });
  }
}
