part of 'complete_job_bloc.dart';

sealed class CompleteJobEvent extends Equatable {
  const CompleteJobEvent();

  @override
  List<Object> get props => [];
}

final class ImageChanged extends CompleteJobEvent {
  const ImageChanged();
}

final class CompleteJob extends CompleteJobEvent {
  const CompleteJob();
}
