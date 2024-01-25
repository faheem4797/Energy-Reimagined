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
  final int toolQuantity;
  const AddSelectedTool({required this.tool, required this.toolQuantity});
  @override
  List<Object> get props => [tool, toolQuantity];
}

final class RemoveSelectedTool extends ToolsRequestEvent {
  final ToolModel tool;
  const RemoveSelectedTool({required this.tool});
  @override
  List<Object> get props => [tool];
}

final class IncreaseQuantity extends ToolsRequestEvent {
  final int index;
  const IncreaseQuantity({required this.index});
  @override
  List<Object> get props => [index];
}

final class DecreaseQuantity extends ToolsRequestEvent {
  final int index;
  const DecreaseQuantity({required this.index});
  @override
  List<Object> get props => [index];
}
