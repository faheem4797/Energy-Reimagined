import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'jobs_stream_event.dart';
part 'jobs_stream_state.dart';

class JobsStreamBloc extends Bloc<JobsStreamEvent, JobsStreamState> {
  JobsStreamBloc() : super(JobsStreamInitial()) {
    on<JobsStreamEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
