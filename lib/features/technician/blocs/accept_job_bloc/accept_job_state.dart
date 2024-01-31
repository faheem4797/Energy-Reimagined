part of 'accept_job_bloc.dart';

sealed class AcceptJobState extends Equatable {
  const AcceptJobState();

  @override
  List<Object> get props => [];
}

final class AcceptJobInitial extends AcceptJobState {}

final class AcceptJobLoading extends AcceptJobState {}

final class AcceptJobSuccess extends AcceptJobState {}

final class AcceptJobFailure extends AcceptJobState {
  final String errorMessage;
  const AcceptJobFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
