part of 'reject_job_bloc.dart';

sealed class RejectJobState extends Equatable {
  const RejectJobState();

  @override
  List<Object> get props => [];
}

final class RejectJobInitial extends RejectJobState {}

final class RejectJobLoading extends RejectJobState {}

final class RejectJobSuccess extends RejectJobState {}

final class RejectJobFailure extends RejectJobState {
  final String errorMessage;
  const RejectJobFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
