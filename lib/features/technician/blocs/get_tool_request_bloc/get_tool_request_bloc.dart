import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';

part 'get_tool_request_event.dart';
part 'get_tool_request_state.dart';

class GetToolRequestBloc
    extends Bloc<GetToolRequestEvent, GetToolRequestState> {
  final JobsRepository _jobsRepository;

  GetToolRequestBloc({required JobsRepository jobsRepository})
      : _jobsRepository = jobsRepository,
        super(const GetToolRequestState()) {
    on<GetToolRequestData>(_getToolRequestData);
  }

  FutureOr<void> _getToolRequestData(
      GetToolRequestData event, Emitter<GetToolRequestState> emit) async {
    if (event.toolRequestId == '') {
      emit(const GetToolRequestState(
          toolRequestModel: ToolRequestModel.empty,
          status: GetToolRequestStatus.success));
    }
    try {
      final toolData =
          await _jobsRepository.getToolRequestData(event.toolRequestId);
      emit(GetToolRequestState(
              toolRequestModel: toolData, status: GetToolRequestStatus.success)
          // GetToolRequestSuccess(toolRequestModel: toolData)
          );
    } on SetFirebaseDataFailure catch (e) {
      emit(GetToolRequestState(
          errorMessage: e.message, status: GetToolRequestStatus.failure));
    } catch (e) {
      log(e.toString());
      emit(const GetToolRequestState(
          errorMessage: 'Error Occured', status: GetToolRequestStatus.failure));
    }
  }
}
