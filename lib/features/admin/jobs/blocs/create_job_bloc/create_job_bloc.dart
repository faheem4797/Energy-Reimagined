import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_job_event.dart';
part 'create_job_state.dart';

class CreateJobBloc extends Bloc<CreateJobEvent, CreateJobState> {
  CreateJobBloc() : super(CreateJobInitial()) {
    on<CreateJobEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
