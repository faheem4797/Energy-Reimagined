import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart' as job_repository;
import 'package:tools_repository/tools_repository.dart';
import 'package:uuid/uuid.dart';

part 'tools_request_event.dart';
part 'tools_request_state.dart';

class ToolsRequestBloc extends Bloc<ToolsRequestEvent, ToolsRequestState> {
  final ToolsRepository _toolsRepository;
  final job_repository.JobsRepository _jobsRepository;
  final job_repository.JobModel oldJobModel;
  final String userId;
  ToolsRequestBloc(
      {required ToolsRepository toolsRepository,
      required job_repository.JobsRepository jobsRepository,
      required this.oldJobModel,
      required this.userId})
      : _toolsRepository = toolsRepository,
        _jobsRepository = jobsRepository,
        super(const ToolsRequestState()) {
    on<RequestSelectedTools>(_requestSelectedTools);
    on<LoadToolsList>(_loadToolsList);
    on<AddSelectedTool>(_addSelectedTool);
    on<RemoveSelectedTool>(_removeSelectedTool);
    add(LoadToolsList());
  }

  FutureOr<void> _requestSelectedTools(
      RequestSelectedTools event, Emitter<ToolsRequestState> emit) async {
//TODO: TEST THIS FUNCTION
    emit(state.copyWith(isValid: state.selectedToolsList.isNotEmpty));
    if (!state.isValid) {
      emit(state.copyWith(
          status: ToolsRequestStatus.failure,
          errorMessage: 'No Tools Selected'));
      emit(state.copyWith(status: ToolsRequestStatus.initial));
      return;
    }
    emit(state.copyWith(status: ToolsRequestStatus.inProgress));
    try {
      final newSelectedToolsList =
          state.selectedToolsList.map((tool) => tool.id).toList();
      final newAllRequestedToolsList = oldJobModel.allToolsRequested
          .where((element) => element.isNotEmpty)
          .toList();
      for (var element in newSelectedToolsList) {
        if (!newAllRequestedToolsList.contains(element)) {
          newAllRequestedToolsList.add(element);
        }
      }

      final currentTime = DateTime.now().microsecondsSinceEpoch;
      job_repository.JobModel newJobModel = oldJobModel.copyWith(
        currentToolsRequestQrCode: const Uuid().v1(),
        currentToolsRequestedIds: newSelectedToolsList,
        allToolsRequested: newAllRequestedToolsList,
        status: job_repository.JobStatus.onHold,
        holdReason: 'Tools Requested',
        holdTimestamp: currentTime,
      );

      final mapOfUpdatedFields = oldJobModel.getChangedFields(newJobModel);
      final update = job_repository.UpdateJobModel(
          id: const Uuid().v1(),
          updatedFields: mapOfUpdatedFields,
          updatedBy: userId,
          updatedTimeStamp: currentTime);

      await _jobsRepository.updateJobData(newJobModel, oldJobModel, update);
      emit(state.copyWith(status: ToolsRequestStatus.success));
    } on SetFirebaseDataFailure catch (e) {
      emit(state.copyWith(
          status: ToolsRequestStatus.failure, errorMessage: e.message));
      emit(state.copyWith(status: ToolsRequestStatus.initial));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: ToolsRequestStatus.failure));
      emit(state.copyWith(status: ToolsRequestStatus.initial));
    }
  }

  FutureOr<void> _loadToolsList(
      LoadToolsList event, Emitter<ToolsRequestState> emit) async {
    try {
      final List<ToolModel> listOfTools = await _toolsRepository.getAllTools();
      if (oldJobModel.currentToolsRequestedIds.isNotEmpty) {
        List<ToolModel> selectedTools = oldJobModel.currentToolsRequestedIds
            .where((toolId) => listOfTools.any((tool) => tool.id == toolId))
            .map(
                (toolId) => listOfTools.firstWhere((tool) => tool.id == toolId))
            .toList();

        emit(state.copyWith(selectedToolsList: selectedTools));
      }
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
    final List<ToolModel> tempSelectedList = List.from(state.selectedToolsList);
    tempSelectedList.add(event.tool);
    emit(state.copyWith(selectedToolsList: tempSelectedList));
  }

  FutureOr<void> _removeSelectedTool(
      RemoveSelectedTool event, Emitter<ToolsRequestState> emit) {
    final List<ToolModel> tempSelectedList = List.from(state.selectedToolsList);
    tempSelectedList.remove(event.tool);
    emit(state.copyWith(selectedToolsList: tempSelectedList));
  }
}
