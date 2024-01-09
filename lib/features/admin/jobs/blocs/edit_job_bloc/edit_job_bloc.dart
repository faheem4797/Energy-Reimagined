import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_job_event.dart';
part 'edit_job_state.dart';

class EditJobBloc extends Bloc<EditJobEvent, EditJobState> {
  EditJobBloc() : super(EditJobInitial()) {
    on<EditJobEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
