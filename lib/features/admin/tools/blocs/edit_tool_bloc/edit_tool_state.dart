part of 'edit_tool_bloc.dart';

enum EditToolStatus { initial, inProgress, success, failure }

final class EditToolState extends Equatable {
  const EditToolState({
    required this.tool,
    this.isValid = false,
    this.status = EditToolStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final ToolModel tool;
  final bool isValid;
  final EditToolStatus status;
  final String? errorMessage;
  final String? displayError;

  EditToolState copyWith({
    ToolModel? tool,
    bool? isValid,
    EditToolStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return EditToolState(
      tool: tool ?? this.tool,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      displayError: displayError,
    );
  }

  @override
  List<Object?> get props =>
      [tool, isValid, status, errorMessage, displayError];
}
