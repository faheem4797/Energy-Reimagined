part of 'reject_job_bloc.dart';

sealed class RejectJobEvent extends Equatable {
  const RejectJobEvent();

  @override
  List<Object> get props => [];
}

final class RejectJob extends RejectJobEvent {
  final String rejectReason;
  const RejectJob({required this.rejectReason});
  @override
  List<Object> get props => [rejectReason];
}
