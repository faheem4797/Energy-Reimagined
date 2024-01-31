part of 'add_after_image_bloc.dart';

enum AddAfterImageStatus { initial, inProgress, success, failure }

final class AddAfterImageState extends Equatable {
  const AddAfterImageState({
    this.imageToolFileNameFromFilePicker,
    this.imageToolFilePathFromFilePicker,
    this.status = AddAfterImageStatus.initial,
    this.errorMessage,
  });

  final List<String>? imageToolFileNameFromFilePicker;
  final List<String>? imageToolFilePathFromFilePicker;
  final AddAfterImageStatus status;
  final String? errorMessage;

  AddAfterImageState copyWith({
    List<String>? imageToolFileNameFromFilePicker,
    List<String>? imageToolFilePathFromFilePicker,
    AddAfterImageStatus? status,
    String? errorMessage,
  }) {
    return AddAfterImageState(
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
        imageToolFileNameFromFilePicker,
        imageToolFilePathFromFilePicker,
        status,
        errorMessage,
      ];
}
