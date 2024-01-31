part of 'accept_job_bloc.dart';

sealed class AcceptJobEvent extends Equatable {
  const AcceptJobEvent();

  @override
  List<Object> get props => [];
}

final class AcceptJob extends AcceptJobEvent {
  const AcceptJob();
  @override
  List<Object> get props => [];
}
