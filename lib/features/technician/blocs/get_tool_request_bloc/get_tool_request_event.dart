part of 'get_tool_request_bloc.dart';

sealed class GetToolRequestEvent extends Equatable {
  const GetToolRequestEvent();

  @override
  List<Object> get props => [];
}

class GetToolRequestData extends GetToolRequestEvent {
  final String toolRequestId;

  const GetToolRequestData({required this.toolRequestId});
  @override
  List<Object> get props => [toolRequestId];
}
