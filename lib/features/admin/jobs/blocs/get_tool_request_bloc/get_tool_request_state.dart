part of 'get_tool_request_bloc.dart';

sealed class GetToolRequestState extends Equatable {
  const GetToolRequestState();

  @override
  List<Object> get props => [];
}

final class GetToolRequestInitial extends GetToolRequestState {}

final class GetToolRequestSuccess extends GetToolRequestState {
  final ToolRequestModel toolRequestModel;
  const GetToolRequestSuccess({required this.toolRequestModel});
  @override
  List<Object> get props => [toolRequestModel];
}

final class GetToolRequestFailure extends GetToolRequestState {
  final String errorMessage;
  const GetToolRequestFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
