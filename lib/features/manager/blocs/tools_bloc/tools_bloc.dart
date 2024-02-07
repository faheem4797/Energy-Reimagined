import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:tools_repository/tools_repository.dart';

part 'tools_event.dart';
part 'tools_state.dart';

class ToolsBloc extends Bloc<ToolsEvent, ToolsState> {
  final ToolsRepository _toolsRepository;
  late final StreamSubscription<List<ToolRequestModel>?>
      _toolRequestSubscription;
  late final StreamSubscription<List<ToolModel>?> _toolsSubscription;

  ToolsBloc({required ToolsRepository toolsRepository})
      : _toolsRepository = toolsRepository,
        super(ToolsState.loading()) {
    _toolRequestSubscription =
        _toolsRepository.getToolRequestsStream.listen((toolRequestData) {
      Set<ToolRequestModel> set = Set.from(toolRequestData);
      final listOfToolRequests = set.toList();

      // escalatedJobsList
      //     .sort((a, b) => b.createdTimestamp.compareTo(a.createdTimestamp));

      final newFilteredList =
          _filterToolRequestList(listOfToolRequests, state.selectedStatuses);

      add(GetToolRequests(
          allTools: state.allTools ?? [],
          listOfToolRequests: listOfToolRequests,
          filteredListOfToolRequests: newFilteredList,
          selectedStatuses: state.selectedStatuses));
    });
    _toolsSubscription = _toolsRepository.getToolsStream.listen((toolData) {
      Set<ToolModel> set = Set.from(toolData);
      final listOfTools = set.toList();

      add(GetToolRequests(
          allTools: listOfTools,
          listOfToolRequests: state.listOfToolRequests ?? [],
          filteredListOfToolRequests: state.filteredListOfToolRequests ?? [],
          selectedStatuses: state.selectedStatuses));
    });
    on<GetToolRequests>(_getToolRequests);
    on<ChangeFilterStatus>(_changeFilterStatus);
  }

  FutureOr<void> _getToolRequests(
      GetToolRequests event, Emitter<ToolsState> emit) {
    try {
      emit(ToolsState.success(event.allTools, event.listOfToolRequests,
          event.filteredListOfToolRequests, event.selectedStatuses));
    } catch (e) {
      log(e.toString());
      emit(ToolsState.failure());
    }
  }

  FutureOr<void> _changeFilterStatus(
      ChangeFilterStatus event, Emitter<ToolsState> emit) {}

  List<ToolRequestModel> _filterToolRequestList(
      List<ToolRequestModel> toolRequestData,
      Set<ToolRequestStatus> filterSet) {
    final List<ToolRequestModel> tempFilteredToolRequests;

    if (filterSet.isEmpty) {
      tempFilteredToolRequests = List.from(toolRequestData);
    } else {
      tempFilteredToolRequests = toolRequestData
          .where((job) => filterSet.contains(job.status))
          .toList();
    }

    tempFilteredToolRequests
        .sort((a, b) => b.requestedTimestamp.compareTo(a.requestedTimestamp));

    return tempFilteredToolRequests;
  }

  // List<ToolModel> _filterAllToolsList(List<ToolModel> toolData,
  //     // Set<ToolModel> filterSet
  //     ) {
  //   final List<ToolModel> tempFilteredToolList;

  //   if (filterSet.isEmpty) {
  //     tempFilteredToolList = List.from(toolData);
  //   } else {
  //     tempFilteredToolList = toolData
  //         .where((job) => filterSet.contains(job.status))
  //         .toList();
  //   }

  //   tempFilteredToolList
  //       .sort((a, b) => b.requestedTimestamp.compareTo(a.requestedTimestamp));

  //   return tempFilteredToolList;
  // }

  @override
  Future<void> close() {
    _toolRequestSubscription.cancel();
    _toolsSubscription.cancel();
    return super.close();
  }
}
