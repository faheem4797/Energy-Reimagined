import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tools_repository/tools_repository.dart';

part 'delete_tool_event.dart';
part 'delete_tool_state.dart';

class DeleteToolBloc extends Bloc<DeleteToolEvent, DeleteToolState> {
  final ToolsRepository _toolsRepository;

  DeleteToolBloc({required ToolsRepository toolsRepository})
      : _toolsRepository = toolsRepository,
        super(DeleteToolInitial()) {
    on<ToolDeleteRequested>(_toolDeleteRequested);
  }

  FutureOr<void> _toolDeleteRequested(
      ToolDeleteRequested event, Emitter<DeleteToolState> emit) async {
    try {
      await _toolsRepository.deleteTool(event.tool);

      emit(DeleteToolSuccess());
    } on SetFirebaseDataFailure catch (e) {
      emit(DeleteToolFailure(errorMessage: e.message));
    } catch (e) {
      log(e.toString());
      emit(DeleteToolFailure(errorMessage: e.toString()));
    }
  }
}
