part of 'add_before_image_bloc.dart';

enum AddBeforeImageStatus { initial, inProgress, success, failure }

final class AddBeforeImageState extends Equatable {
  const AddBeforeImageState({
    this.imageToolFileNameFromFilePicker,
    this.imageToolFilePathFromFilePicker,
    this.status = AddBeforeImageStatus.initial,
    this.errorMessage,
  });

  final List<String>? imageToolFileNameFromFilePicker;
  final List<String>? imageToolFilePathFromFilePicker;
  final AddBeforeImageStatus status;
  final String? errorMessage;

  AddBeforeImageState copyWith({
    List<String>? imageToolFileNameFromFilePicker,
    List<String>? imageToolFilePathFromFilePicker,
    AddBeforeImageStatus? status,
    String? errorMessage,
  }) {
    return AddBeforeImageState(
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
