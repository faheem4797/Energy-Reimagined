part of 'tool_request_bloc.dart';

sealed class ToolRequestState extends Equatable {
  const ToolRequestState();

  @override
  List<Object> get props => [];
}

final class ToolRequestInitial extends ToolRequestState {}

final class ToolRequestSuccess extends ToolRequestState {
  final List<ToolModel> toolsList;
  const ToolRequestSuccess({required this.toolsList});
  @override
  List<Object> get props => [toolsList];
}

final class ToolRequestFailure extends ToolRequestState {
  final String errorMessage;
  const ToolRequestFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
