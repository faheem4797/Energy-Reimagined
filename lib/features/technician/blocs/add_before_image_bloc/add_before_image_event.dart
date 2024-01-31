part of 'add_before_image_bloc.dart';

sealed class AddBeforeImageEvent extends Equatable {
  const AddBeforeImageEvent();

  @override
  List<Object> get props => [];
}

final class UpdateJobWithBeforeImage extends AddBeforeImageEvent {
  final JobModel job;
  const UpdateJobWithBeforeImage({required this.job});
  @override
  List<Object> get props => [job];
}
