part of 'qr_code_scanner_bloc.dart';

sealed class QrCodeScannerState extends Equatable {
  const QrCodeScannerState();

  @override
  List<Object> get props => [];
}

final class QrCodeScannerInitial extends QrCodeScannerState {}

final class QrCodeScannerLoading extends QrCodeScannerState {}

final class QrCodeScannerSuccess extends QrCodeScannerState {}

final class QrCodeScannerFailure extends QrCodeScannerState {
  final String errorMessage;
  const QrCodeScannerFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
