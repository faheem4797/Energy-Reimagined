part of 'tool_request_bloc.dart';

sealed class ToolRequestEvent extends Equatable {
  const ToolRequestEvent();

  @override
  List<Object> get props => [];
}

final class LoadInitialData extends ToolRequestEvent {
  final job_repository.JobModel jobModel;
  const LoadInitialData({required this.jobModel});

  @override
  List<Object> get props => [jobModel];
}
