part of 'technician_qr_code_bloc.dart';

sealed class TechnicianQrCodeState extends Equatable {
  const TechnicianQrCodeState();

  @override
  List<Object> get props => [];
}

final class TechnicianQrCodeInitial extends TechnicianQrCodeState {}

final class TechnicianQrCodeLoading extends TechnicianQrCodeState {}

final class TechnicianQrCodeSuccess extends TechnicianQrCodeState {}

final class TechnicianQrCodeFailure extends TechnicianQrCodeState {
  final String errorMessage;
  const TechnicianQrCodeFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
