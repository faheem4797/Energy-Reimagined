import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

part 'qr_code_scanner_event.dart';
part 'qr_code_scanner_state.dart';

class QrCodeScannerBloc extends Bloc<QrCodeScannerEvent, QrCodeScannerState> {
  final JobsRepository _jobsRepository;
  final JobModel jobModel;
  final String userId;
  QrCodeScannerBloc(
      {required JobsRepository jobsRepository,
      required this.jobModel,
      required this.userId})
      : _jobsRepository = jobsRepository,
        super(QrCodeScannerInitial()) {
    on<BarCodeDetected>(_barCodeDetected);
  }

  FutureOr<void> _barCodeDetected(
      BarCodeDetected event, Emitter<QrCodeScannerState> emit) async {
    final List<Barcode> barcodes = event.capture.barcodes;

    for (final barcode in barcodes) {
      log('Barcode found! ${barcode.rawValue}');
      if (jobModel.currentToolsRequestQrCode == barcode.rawValue) {
        emit(QrCodeScannerLoading());

        try {
          final currentTime = DateTime.now().microsecondsSinceEpoch;
          JobModel newJobModel = jobModel.copyWith(
            currentToolsRequestQrCode: '',
            currentToolsRequested: [],
            // allToolsRequested: newAllRequestedToolsList,
            status: JobStatus.workInProgress,
            startedTimestamp: currentTime,
            // holdReason: 'Tools Requested',
            // holdTimestamp: currentTime,
          );

          final mapOfUpdatedFields = jobModel.getChangedFields(newJobModel);
          final update = UpdateJobModel(
              id: const Uuid().v1(),
              updatedFields: mapOfUpdatedFields,
              updatedBy: userId,
              updatedTimeStamp: currentTime);

          await _jobsRepository.updateJobData(newJobModel, jobModel, update);
          emit(QrCodeScannerSuccess());
        } on SetFirebaseDataFailure catch (e) {
          emit(QrCodeScannerFailure(errorMessage: e.message));
        } catch (e) {
          log(e.toString());
          emit(const QrCodeScannerFailure(errorMessage: 'Error Occured'));
        }
      }
    }
  }
}
