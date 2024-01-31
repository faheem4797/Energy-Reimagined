import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:uuid/uuid.dart';

part 'technician_qr_code_event.dart';
part 'technician_qr_code_state.dart';

class TechnicianQrCodeBloc
    extends Bloc<TechnicianQrCodeEvent, TechnicianQrCodeState> {
  final JobsRepository _jobsRepository;
  final JobModel jobModel;
  final String userId;
  TechnicianQrCodeBloc(
      {required JobsRepository jobsRepository,
      required this.jobModel,
      required this.userId})
      : _jobsRepository = jobsRepository,
        super(TechnicianQrCodeInitial()) {
    on<ConfirmToolsDelivery>(_confirmToolsDelivery);
  }

  FutureOr<void> _confirmToolsDelivery(
      ConfirmToolsDelivery event, Emitter<TechnicianQrCodeState> emit) async {
    emit(TechnicianQrCodeLoading());

    try {
      final currentTime = DateTime.now().microsecondsSinceEpoch;
      JobModel newJobModel = jobModel.copyWith(
        currentToolsRequestQrCode: '',
        currentToolsRequestedIds: [],
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
      emit(TechnicianQrCodeSuccess());
    } on SetFirebaseDataFailure catch (e) {
      emit(TechnicianQrCodeFailure(errorMessage: e.message));
    } catch (e) {
      log(e.toString());
      emit(const TechnicianQrCodeFailure(errorMessage: 'Error Occured'));
    }
  }
}
