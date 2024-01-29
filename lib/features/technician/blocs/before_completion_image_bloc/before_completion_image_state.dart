part of 'before_completion_image_bloc.dart';

enum BeforeCompletionImageStatus { initial, inProgress, success, failure }

final class BeforeCompletionImageState extends Equatable {
  const BeforeCompletionImageState({
    required this.job,
    this.imageToolFileBytes,
    this.imageToolFileNameFromFilePicker,
    this.imageToolFilePathFromFilePicker,
    this.status = BeforeCompletionImageStatus.initial,
    this.errorMessage,
  });
  final JobModel job;
  final Uint8List? imageToolFileBytes;
  final String? imageToolFileNameFromFilePicker;
  final String? imageToolFilePathFromFilePicker;
  final BeforeCompletionImageStatus status;
  final String? errorMessage;

  BeforeCompletionImageState copyWith({
    JobModel? job,
    Uint8List? imageToolFileBytes,
    String? imageToolFileNameFromFilePicker,
    String? imageToolFilePathFromFilePicker,
    BeforeCompletionImageStatus? status,
    String? errorMessage,
  }) {
    return BeforeCompletionImageState(
      job: job ?? this.job,
      imageToolFileBytes: imageToolFileBytes ?? this.imageToolFileBytes,
      imageToolFileNameFromFilePicker: imageToolFileNameFromFilePicker ??
          this.imageToolFileNameFromFilePicker,
      imageToolFilePathFromFilePicker: imageToolFilePathFromFilePicker ??
          this.imageToolFilePathFromFilePicker,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        job,
        imageToolFileBytes,
        imageToolFileNameFromFilePicker,
        imageToolFilePathFromFilePicker,
        status,
        errorMessage,
      ];
}
