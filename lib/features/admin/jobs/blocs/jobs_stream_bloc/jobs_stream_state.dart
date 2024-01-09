part of 'jobs_stream_bloc.dart';

enum JobsStreamStatus { loading, success, failure }

class JobsStreamState extends Equatable {
  final JobsStreamStatus status;
  final List<JobModel>? jobStream;

  const JobsStreamState._({
    this.status = JobsStreamStatus.loading,
    this.jobStream,
  });

  const JobsStreamState.loading() : this._();

  const JobsStreamState.success(List<JobModel> jobStream)
      : this._(status: JobsStreamStatus.success, jobStream: jobStream);

  const JobsStreamState.failure() : this._(status: JobsStreamStatus.failure);

  @override
  List<Object?> get props => [status, jobStream];
}
