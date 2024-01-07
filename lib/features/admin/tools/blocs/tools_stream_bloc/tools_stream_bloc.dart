import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tools_repository/tools_repository.dart';

part 'tools_stream_event.dart';
part 'tools_stream_state.dart';

class ToolsStreamBloc extends Bloc<ToolsStreamEvent, ToolsStreamState> {
  final ToolsRepository _toolsRepository;
  late final StreamSubscription<List<ToolModel>?> _toolsSubscription;
  ToolsStreamBloc({required ToolsRepository toolsRepository})
      : _toolsRepository = toolsRepository,
        super(const ToolsStreamState.loading()) {
    _toolsSubscription = _toolsRepository.getToolsStream.listen((toolData) {
      add(GetToolStream(toolsStream: toolData));
    });
    on<GetToolStream>(_getToolStream);
  }

  FutureOr<void> _getToolStream(
      GetToolStream event, Emitter<ToolsStreamState> emit) async {
    try {
      emit(ToolsStreamState.success(event.toolsStream));
    } catch (e) {
      log(e.toString());
      emit(const ToolsStreamState.failure());
    }
  }

  @override
  Future<void> close() {
    _toolsSubscription.cancel();
    return super.close();
  }
}
