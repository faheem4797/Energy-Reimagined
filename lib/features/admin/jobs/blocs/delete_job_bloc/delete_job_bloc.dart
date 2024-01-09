import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_job_event.dart';
part 'delete_job_state.dart';

class DeleteJobBloc extends Bloc<DeleteJobEvent, DeleteJobState> {
  DeleteJobBloc() : super(DeleteJobInitial()) {
    on<DeleteJobEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
