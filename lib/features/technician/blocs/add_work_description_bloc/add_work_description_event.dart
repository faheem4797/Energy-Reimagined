part of 'add_work_description_bloc.dart';

sealed class AddWorkDescriptionEvent extends Equatable {
  const AddWorkDescriptionEvent();

  @override
  List<Object> get props => [];
}

final class UpdateJobWithWorkDescription extends AddWorkDescriptionEvent {
  final String workDescription;
  final JobModel job;
  const UpdateJobWithWorkDescription(
      {required this.workDescription, required this.job});
  @override
  List<Object> get props => [workDescription, job];
}
