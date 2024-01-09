part of 'delete_job_bloc.dart';

sealed class DeleteJobEvent extends Equatable {
  const DeleteJobEvent();

  @override
  List<Object> get props => [];
}

final class JobDeleteRequested extends DeleteJobEvent {
  final JobModel job;

  const JobDeleteRequested({required this.job});
  @override
  List<Object> get props => [job];
}
