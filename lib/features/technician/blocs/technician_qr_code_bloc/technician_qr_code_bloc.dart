import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:tools_repository/tools_repository.dart' as tools_Repository;
import 'package:uuid/uuid.dart';

part 'technician_qr_code_event.dart';
part 'technician_qr_code_state.dart';

class TechnicianQrCodeBloc
    extends Bloc<TechnicianQrCodeEvent, TechnicianQrCodeState> {
  final JobsRepository _jobsRepository;
  final tools_Repository.ToolsRepository _toolsRepository;
  final JobModel jobModel;
  final tools_Repository.ToolRequestModel toolRequestModel;
  final String userId;
  TechnicianQrCodeBloc(
      {required JobsRepository jobsRepository,
      required tools_Repository.ToolsRepository toolsRepository,
      required this.jobModel,
      required this.toolRequestModel,
      required this.userId})
      : _jobsRepository = jobsRepository,
        _toolsRepository = toolsRepository,
        super(TechnicianQrCodeInitial()) {
    on<ConfirmToolsDelivery>(_confirmToolsDelivery);
  }

  FutureOr<void> _confirmToolsDelivery(
      ConfirmToolsDelivery event, Emitter<TechnicianQrCodeState> emit) async {
    emit(TechnicianQrCodeLoading());

    try {
      final currentTime = DateTime.now().microsecondsSinceEpoch;
      tools_Repository.ToolRequestModel newToolRequestModel =
          toolRequestModel.copyWith(
              status: tools_Repository.ToolRequestStatus.completed,
              completedTimestamp: currentTime);
      JobModel newJobModel = jobModel.copyWith(
        currentToolRequestId: '',
        currentToolsRequestQrCode: '',
        currentToolsRequestedIds: [],
        currentToolsRequestedQuantity: [],
        status: JobStatus.workInProgress,
        startedTimestamp: currentTime,
      );

      final mapOfUpdatedFields = jobModel.getChangedFields(newJobModel);
      final update = UpdateJobModel(
          id: const Uuid().v1(),
          updatedFields: mapOfUpdatedFields,
          updatedBy: userId,
          updatedTimeStamp: currentTime);

      await _jobsRepository.updateJobData(newJobModel, jobModel, update);
      await _toolsRepository.setToolRequestData(newToolRequestModel);

      emit(TechnicianQrCodeSuccess());
    } on SetFirebaseDataFailure catch (e) {
      emit(TechnicianQrCodeFailure(errorMessage: e.message));
    } catch (e) {
      log(e.toString());
      emit(const TechnicianQrCodeFailure(errorMessage: 'Error Occured'));
    }
  }
}
