part of 'create_tool_bloc.dart';

enum CreateToolStatus { initial, inProgress, success, failure }

final class CreateToolState extends Equatable {
  const CreateToolState({
    this.tool = ToolModel.empty,
    this.isValid = false,
    this.status = CreateToolStatus.initial,
    this.errorMessage,
    this.displayError,
  });
  final ToolModel tool;
  final bool isValid;
  final CreateToolStatus status;
  final String? errorMessage;
  final String? displayError;

  CreateToolState copyWith({
    ToolModel? tool,
    bool? isValid,
    CreateToolStatus? status,
    String? errorMessage,
    String? displayError,
  }) {
    return CreateToolState(
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
