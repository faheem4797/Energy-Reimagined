part of 'delete_job_bloc.dart';

sealed class DeleteJobState extends Equatable {
  const DeleteJobState();
  
  @override
  List<Object> get props => [];
}

final class DeleteJobInitial extends DeleteJobState {}
