part of 'delete_job_bloc.dart';

sealed class DeleteJobState extends Equatable {
  const DeleteJobState();

  @override
  List<Object> get props => [];
}

final class DeleteJobInitial extends DeleteJobState {}

final class DeleteJobSuccess extends DeleteJobState {}

final class DeleteJobFailure extends DeleteJobState {
  final String? errorMessage;

  const DeleteJobFailure({required this.errorMessage});
}
