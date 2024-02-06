part of 'get_tool_request_bloc.dart';

enum GetToolRequestStatus { initial, success, failure }

final class GetToolRequestState extends Equatable {
  const GetToolRequestState({
    this.status = GetToolRequestStatus.initial,
    this.toolRequestModel = ToolRequestModel.empty,
    this.errorMessage,
  });
  final ToolRequestModel toolRequestModel;
  final GetToolRequestStatus status;
  final String? errorMessage;

  GetToolRequestState copyWith({
    ToolRequestModel? toolRequestModel,
    GetToolRequestStatus? status,
    String? errorMessage,
  }) {
    return GetToolRequestState(
      toolRequestModel: toolRequestModel ?? this.toolRequestModel,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        toolRequestModel,
        status,
        errorMessage,
      ];
}
