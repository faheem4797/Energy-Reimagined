part of 'tools_request_bloc.dart';

enum ToolsRequestStatus {
  loading,
  loadingFailure,
  initial,
  inProgress,
  success,
  failure
}

final class ToolsRequestState extends Equatable {
  const ToolsRequestState({
    this.toolsList = const [],
    this.allRequestedToolsList = const [],
    this.allRequestedToolsQuantityList = const [],
    this.selectedToolsList = const [],
    this.selectedToolsQuantityList = const [],
    this.isValid = false,
    this.status = ToolsRequestStatus.loading,
    this.errorMessage,
  });
  final List<ToolModel> toolsList;
  final List<ToolModel> allRequestedToolsList;
  final List<int> allRequestedToolsQuantityList;
  final List<ToolModel> selectedToolsList;
  final List<int> selectedToolsQuantityList;
  final bool isValid;
  final ToolsRequestStatus status;
  final String? errorMessage;

  ToolsRequestState copyWith({
    List<ToolModel>? toolsList,
    List<ToolModel>? allRequestedToolsList,
    List<int>? allRequestedToolsQuantityList,
    List<ToolModel>? selectedToolsList,
    List<int>? selectedToolsQuantityList,
    bool? isValid,
    ToolsRequestStatus? status,
    String? errorMessage,
  }) {
    return ToolsRequestState(
      toolsList: toolsList ?? this.toolsList,
      allRequestedToolsList:
          allRequestedToolsList ?? this.allRequestedToolsList,
      allRequestedToolsQuantityList:
          allRequestedToolsQuantityList ?? this.allRequestedToolsQuantityList,
      selectedToolsList: selectedToolsList ?? this.selectedToolsList,
      selectedToolsQuantityList:
          selectedToolsQuantityList ?? this.selectedToolsQuantityList,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        toolsList,
        allRequestedToolsList,
        allRequestedToolsQuantityList,
        selectedToolsList,
        selectedToolsQuantityList,
        isValid,
        status,
        errorMessage,
      ];
}
