part of 'job_detail_bloc.dart';

enum JobDetailStatus { loading, success, failure }

class JobDetailState extends Equatable {
  final JobDetailStatus status;
  final JobModel job;

  const JobDetailState._({
    this.status = JobDetailStatus.loading,
    this.job = JobModel.empty,
  });

  const JobDetailState.loading() : this._();

  const JobDetailState.success(JobModel job)
      : this._(status: JobDetailStatus.success, job: job);

  const JobDetailState.failure() : this._(status: JobDetailStatus.failure);

  @override
  List<Object?> get props => [status, job];
}
