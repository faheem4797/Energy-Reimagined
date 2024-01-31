part of 'complete_job_bloc.dart';

sealed class CompleteJobEvent extends Equatable {
  const CompleteJobEvent();

  @override
  List<Object> get props => [];
}

final class CompleteJob extends CompleteJobEvent {
  final JobModel job;
  const CompleteJob({required this.job});
  @override
  List<Object> get props => [job];
}
