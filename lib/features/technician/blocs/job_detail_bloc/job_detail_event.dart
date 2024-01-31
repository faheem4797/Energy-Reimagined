part of 'job_detail_bloc.dart';

sealed class JobDetailEvent extends Equatable {
  const JobDetailEvent();

  @override
  List<Object> get props => [];
}

final class GetCurrentJobStream extends JobDetailEvent {
  final JobModel job;

  const GetCurrentJobStream({required this.job});

  @override
  List<Object> get props => [job];
}
