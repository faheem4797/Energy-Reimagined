part of 'create_job_bloc.dart';

sealed class CreateJobState extends Equatable {
  const CreateJobState();
  
  @override
  List<Object> get props => [];
}

final class CreateJobInitial extends CreateJobState {}
