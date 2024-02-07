part of 'tools_bloc.dart';

enum ToolsStatus { loading, success, failure }

class ToolsState extends Equatable {
  final ToolsStatus status;
  final List<ToolModel>? allTools;
  final List<ToolRequestModel>? listOfToolRequests;
  final List<ToolRequestModel>? filteredListOfToolRequests;
  final Set<ToolRequestStatus> selectedStatuses;

  const ToolsState._({
    this.status = ToolsStatus.loading,
    this.allTools,
    this.listOfToolRequests,
    this.filteredListOfToolRequests,
    required this.selectedStatuses,
  });

  ToolsState.loading() : this._(selectedStatuses: {});

  const ToolsState.success(
      List<ToolModel> allTools,
      List<ToolRequestModel> listOfToolRequests,
      List<ToolRequestModel> filteredListOfToolRequests,
      Set<ToolRequestStatus> selectedStatuses)
      : this._(
            status: ToolsStatus.success,
            allTools: allTools,
            listOfToolRequests: listOfToolRequests,
            filteredListOfToolRequests: filteredListOfToolRequests,
            selectedStatuses: selectedStatuses);

  ToolsState.failure()
      : this._(status: ToolsStatus.failure, selectedStatuses: {});

  @override
  List<Object?> get props => [
        status,
        allTools,
        listOfToolRequests,
        filteredListOfToolRequests,
        selectedStatuses
      ];
}
