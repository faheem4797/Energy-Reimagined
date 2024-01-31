part of 'technician_qr_code_bloc.dart';

sealed class TechnicianQrCodeEvent extends Equatable {
  const TechnicianQrCodeEvent();

  @override
  List<Object> get props => [];
}

class ConfirmToolsDelivery extends TechnicianQrCodeEvent {
  const ConfirmToolsDelivery();
}
