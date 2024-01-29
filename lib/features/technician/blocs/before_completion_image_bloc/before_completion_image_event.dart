part of 'before_completion_image_bloc.dart';

sealed class BeforeCompletionImageEvent extends Equatable {
  const BeforeCompletionImageEvent();

  @override
  List<Object> get props => [];
}

final class BeforeCompletionImageChanged extends BeforeCompletionImageEvent {
  const BeforeCompletionImageChanged();
}

final class UpdateJobWithBeforeImage extends BeforeCompletionImageEvent {
  const UpdateJobWithBeforeImage();
  @override
  List<Object> get props => [];
}
