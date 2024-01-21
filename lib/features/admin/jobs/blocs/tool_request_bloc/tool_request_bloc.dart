import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart' as job_repository;
import 'package:tools_repository/tools_repository.dart';

part 'tool_request_event.dart';
part 'tool_request_state.dart';

class ToolRequestBloc extends Bloc<ToolRequestEvent, ToolRequestState> {
  final job_repository.JobModel jobModel;
  final ToolsRepository _toolsRepository;
  ToolRequestBloc(
      {required ToolsRepository toolsRepository, required this.jobModel})
      : _toolsRepository = toolsRepository,
        super(ToolRequestInitial()) {
    on<LoadInitialData>(_loadInitialData);
    add(LoadInitialData(jobModel: jobModel));
  }

  FutureOr<void> _loadInitialData(
      LoadInitialData event, Emitter<ToolRequestState> emit) async {
    try {
      final listOfTools = await _toolsRepository
          .getSomeTools(event.jobModel.currentToolsRequested);
      emit(ToolRequestSuccess(toolsList: listOfTools));
    } on SetFirebaseDataFailure catch (e) {
      emit(ToolRequestFailure(errorMessage: e.message));
    } catch (e) {
      emit(const ToolRequestFailure(errorMessage: 'Error Loading Data'));
    }
  }
}
