part of 'add_after_image_bloc.dart';

sealed class AddAfterImageEvent extends Equatable {
  const AddAfterImageEvent();

  @override
  List<Object> get props => [];
}

final class UpdateJobWithAfterImage extends AddAfterImageEvent {
  final JobModel job;
  const UpdateJobWithAfterImage({required this.job});
  @override
  List<Object> get props => [job];
}
