part of 'qr_code_scanner_bloc.dart';

sealed class QrCodeScannerEvent extends Equatable {
  const QrCodeScannerEvent();

  @override
  List<Object> get props => [];
}

class BarCodeDetected extends QrCodeScannerEvent {
  final BarcodeCapture capture;

  const BarCodeDetected({required this.capture});
}
