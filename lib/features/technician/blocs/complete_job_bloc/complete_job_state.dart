part of 'complete_job_bloc.dart';

enum CompleteJobStatus { initial, inProgress, success, failure }

final class CompleteJobState extends Equatable {
  const CompleteJobState({
    required this.job,
    this.imageToolFileBytes,
    this.imageToolFileNameFromFilePicker,
    this.imageToolFilePathFromFilePicker,
    this.status = CompleteJobStatus.initial,
    this.errorMessage,
  });
  final JobModel job;
  final Uint8List? imageToolFileBytes;
  final String? imageToolFileNameFromFilePicker;
  final String? imageToolFilePathFromFilePicker;
  final CompleteJobStatus status;
  final String? errorMessage;

  CompleteJobState copyWith({
    JobModel? job,
    Uint8List? imageToolFileBytes,
    String? imageToolFileNameFromFilePicker,
    String? imageToolFilePathFromFilePicker,
    CompleteJobStatus? status,
    String? errorMessage,
  }) {
    return CompleteJobState(
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
