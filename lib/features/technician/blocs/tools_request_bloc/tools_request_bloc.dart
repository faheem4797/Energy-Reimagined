import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tools_repository/tools_repository.dart';

part 'tools_request_event.dart';
part 'tools_request_state.dart';

class ToolsRequestBloc extends Bloc<ToolsRequestEvent, ToolsRequestState> {
  final ToolsRepository _toolsRepository;
  ToolsRequestBloc({required ToolsRepository toolsRepository})
      : _toolsRepository = toolsRepository,
        super(const ToolsRequestState()) {
    add(LoadToolsList());
    on<RequestSelectedTools>(_requestSelectedTools);
    on<LoadToolsList>(_loadToolsList);
    on<AddSelectedTool>(_addSelectedTool);
    on<RemoveSelectedTool>(_removeSelectedTool);
  }

  FutureOr<void> _requestSelectedTools(
      RequestSelectedTools event, Emitter<ToolsRequestState> emit) {}

  FutureOr<void> _loadToolsList(
      LoadToolsList event, Emitter<ToolsRequestState> emit) async {
    try {
      final List<ToolModel> listOfTools = await _toolsRepository.getAllTools();
      emit(state.copyWith(
          toolsList: listOfTools, status: ToolsRequestStatus.initial));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: ToolsRequestStatus.loadingFailure, errorMessage: e.message));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: ToolsRequestStatus.loadingFailure));
    }
  }

  FutureOr<void> _addSelectedTool(
      AddSelectedTool event, Emitter<ToolsRequestState> emit) {
    final List<ToolModel> tempSelectedList =
        List.from(state.selectedToolsList!);
    tempSelectedList.add(event.tool);
    emit(state.copyWith(selectedToolsList: tempSelectedList));
  }

  FutureOr<void> _removeSelectedTool(
      RemoveSelectedTool event, Emitter<ToolsRequestState> emit) {
    final List<ToolModel> tempSelectedList =
        List.from(state.selectedToolsList!);
    tempSelectedList.remove(event.tool);
    emit(state.copyWith(selectedToolsList: tempSelectedList));
  }
}
