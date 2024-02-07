import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tools_repository/tools_repository.dart';

part 'get_tool_request_event.dart';
part 'get_tool_request_state.dart';

class GetToolRequestBloc
    extends Bloc<GetToolRequestEvent, GetToolRequestState> {
  final ToolsRepository _toolsRepository;
  GetToolRequestBloc({required ToolsRepository toolsRepository})
      : _toolsRepository = toolsRepository,
        super(GetToolRequestInitial()) {
    on<GetToolRequestData>(_getToolRequestData);
  }

  FutureOr<void> _getToolRequestData(
      GetToolRequestData event, Emitter<GetToolRequestState> emit) async {
    try {
      final toolData =
          await _toolsRepository.getToolRequestData(event.toolRequestId);
      emit(GetToolRequestSuccess(toolRequestModel: toolData));
    } on SetFirebaseDataFailure catch (e) {
      emit(GetToolRequestFailure(errorMessage: e.message));
    } catch (e) {
      log(e.toString());
      emit(const GetToolRequestFailure(errorMessage: 'Error Occured'));
    }
  }
}
