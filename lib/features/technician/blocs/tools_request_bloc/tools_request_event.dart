part of 'tools_request_bloc.dart';

sealed class ToolsRequestEvent extends Equatable {
  const ToolsRequestEvent();

  @override
  List<Object> get props => [];
}

final class RequestSelectedTools extends ToolsRequestEvent {}

final class LoadToolsList extends ToolsRequestEvent {}

final class AddSelectedTool extends ToolsRequestEvent {
  final ToolModel tool;
  const AddSelectedTool({required this.tool});
  @override
  List<Object> get props => [tool];
}

final class RemoveSelectedTool extends ToolsRequestEvent {
  final ToolModel tool;
  const RemoveSelectedTool({required this.tool});
  @override
  List<Object> get props => [tool];
}
