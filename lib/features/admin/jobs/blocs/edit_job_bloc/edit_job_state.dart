part of 'edit_job_bloc.dart';

sealed class EditJobState extends Equatable {
  const EditJobState();
  
  @override
  List<Object> get props => [];
}

final class EditJobInitial extends EditJobState {}
