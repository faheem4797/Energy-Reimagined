part of 'delete_tool_bloc.dart';

sealed class DeleteToolEvent extends Equatable {
  const DeleteToolEvent();

  @override
  List<Object> get props => [];
}

final class ToolDeleteRequested extends DeleteToolEvent {
  final ToolModel tool;

  const ToolDeleteRequested({required this.tool});
  @override
  List<Object> get props => [tool];
}
