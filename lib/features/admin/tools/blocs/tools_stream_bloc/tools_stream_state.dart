part of 'tools_stream_bloc.dart';

enum ToolsStreamStatus { loading, success, failure }

class ToolsStreamState extends Equatable {
  final ToolsStreamStatus status;
  final List<ToolModel>? toolStream;

  const ToolsStreamState._({
    this.status = ToolsStreamStatus.loading,
    this.toolStream,
  });

  const ToolsStreamState.loading() : this._();

  const ToolsStreamState.success(List<ToolModel> toolStream)
      : this._(status: ToolsStreamStatus.success, toolStream: toolStream);

  const ToolsStreamState.failure() : this._(status: ToolsStreamStatus.failure);

  @override
  List<Object?> get props => [status, toolStream];
}
