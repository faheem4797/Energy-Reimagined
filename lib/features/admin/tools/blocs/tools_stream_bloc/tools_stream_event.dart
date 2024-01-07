part of 'tools_stream_bloc.dart';

sealed class ToolsStreamEvent extends Equatable {
  const ToolsStreamEvent();

  @override
  List<Object> get props => [];
}

final class GetToolStream extends ToolsStreamEvent {
  final List<ToolModel> toolsStream;

  const GetToolStream({required this.toolsStream});

  @override
  List<Object> get props => [toolsStream];
}
