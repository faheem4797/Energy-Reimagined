part of 'edit_tool_bloc.dart';

enum EditToolStatus { initial, inProgress, success, failure }

final class EditToolState extends Equatable {
  const EditToolState({
    required this.tool,
    this.imageToolFileBytes,
    this.imageToolFileNameFromFilePicker,
    this.imageToolFilePathFromFilePicker,
    this.isValid = false,
    this.status = EditToolStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final ToolModel tool;
  final Uint8List? imageToolFileBytes;
  final String? imageToolFileNameFromFilePicker;
  final String? imageToolFilePathFromFilePicker;
  final bool isValid;
  final EditToolStatus status;
  final String? errorMessage;
  final String? displayError;

  EditToolState copyWith({
    ToolModel? tool,
    Uint8List? imageToolFileBytes,
    String? imageToolFileNameFromFilePicker,
    String? imageToolFilePathFromFilePicker,
    bool? isValid,
    EditToolStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return EditToolState(
      tool: tool ?? this.tool,
      imageToolFileBytes: imageToolFileBytes ?? this.imageToolFileBytes,
      imageToolFileNameFromFilePicker: imageToolFileNameFromFilePicker ??
          this.imageToolFileNameFromFilePicker,
      imageToolFilePathFromFilePicker: imageToolFilePathFromFilePicker ??
          this.imageToolFilePathFromFilePicker,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      displayError: displayError,
    );
  }

  @override
  List<Object?> get props => [
        tool,
        imageToolFileBytes,
        imageToolFileNameFromFilePicker,
        imageToolFilePathFromFilePicker,
        isValid,
        status,
        errorMessage,
        displayError
      ];
}
