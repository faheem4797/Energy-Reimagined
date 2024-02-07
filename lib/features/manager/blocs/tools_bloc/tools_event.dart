part of 'tools_bloc.dart';

sealed class ToolsEvent extends Equatable {
  const ToolsEvent();

  @override
  List<Object> get props => [];
}

final class GetToolRequests extends ToolsEvent {
  final List<ToolModel> allTools;
  final List<ToolRequestModel> listOfToolRequests;
  final List<ToolRequestModel> filteredListOfToolRequests;
  final Set<ToolRequestStatus> selectedStatuses;

  const GetToolRequests(
      {required this.allTools,
      required this.listOfToolRequests,
      required this.filteredListOfToolRequests,
      required this.selectedStatuses});

  @override
  List<Object> get props => [
        allTools,
        listOfToolRequests,
        filteredListOfToolRequests,
        selectedStatuses
      ];
}

final class ChangeFilterStatus extends ToolsEvent {
  final List<ValueItem<dynamic>> filterStatusList;
  const ChangeFilterStatus({required this.filterStatusList});
  @override
  List<Object> get props => [filterStatusList];
}
