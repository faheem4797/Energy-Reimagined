part of 'jobs_stream_bloc.dart';

sealed class JobsStreamEvent extends Equatable {
  const JobsStreamEvent();

  @override
  List<Object> get props => [];
}

final class GetJobStream extends JobsStreamEvent {
  final List<JobModel> jobsStream;

  const GetJobStream({required this.jobsStream});

  @override
  List<Object> get props => [jobsStream];
}
