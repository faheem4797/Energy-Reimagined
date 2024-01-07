import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_tool_event.dart';
part 'delete_tool_state.dart';

class DeleteToolBloc extends Bloc<DeleteToolEvent, DeleteToolState> {
  DeleteToolBloc() : super(DeleteToolInitial()) {
    on<DeleteToolEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
