part of 'create_tool_bloc.dart';

enum CreateToolStatus { initial, inProgress, success, failure }

final class CreateToolState extends Equatable {
  const CreateToolState({
    this.tool = ToolModel.empty,
    this.imageToolFileBytes,
    this.imageToolFileNameFromFilePicker,
    this.imageToolFilePathFromFilePicker,
    this.isValid = false,
    this.status = CreateToolStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final ToolModel tool;
  final Uint8List? imageToolFileBytes;
  final String? imageToolFileNameFromFilePicker;
  final String? imageToolFilePathFromFilePicker;
  final bool isValid;
  final CreateToolStatus status;
  final String? errorMessage;
  final String? displayError;

  CreateToolState copyWith({
    ToolModel? tool,
    Uint8List? imageToolFileBytes,
    String? imageToolFileNameFromFilePicker,
    String? imageToolFilePathFromFilePicker,
    bool? isValid,
    CreateToolStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return CreateToolState(
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
