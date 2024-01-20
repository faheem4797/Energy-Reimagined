import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/technician/blocs/tools_request_bloc/tools_request_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tools_repository/tools_repository.dart';

class TechnicianRequestToolsPage extends StatefulWidget {
  const TechnicianRequestToolsPage({super.key});

  @override
  State<TechnicianRequestToolsPage> createState() =>
      _TechnicianRequestToolsPageState();
}

class _TechnicianRequestToolsPageState
    extends State<TechnicianRequestToolsPage> {
  @override
  Widget build(BuildContext context) {
    //TODO: ADD A DROPDOWN OR SOME SORT OF SELECTION PROCESS for technician to choose from the added tools
    //TODO: IF NEED A NEW TOOL THEN FILL A FORM WITH NAME OF THE TOOL AND REQUEST
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tools Request',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
      ),
      body: BlocBuilder<ToolsRequestBloc, ToolsRequestState>(
        builder: (context, state) {
          return state.status == ToolsRequestStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.status == ToolsRequestStatus.loadingFailure
                  ? const Center(
                      child: Text('Error Loading Tools List'),
                    )
                  : Column(
                      children: [
                        state.selectedToolsList!.isEmpty
                            ? Container()
                            : SizedBox(
                                height: 50,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: state.selectedToolsList!
                                      .map((tool) => Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w),
                                            child: Chip(
                                              label: Text(tool.name),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.toolsList!.length,
                            itemBuilder: (context, index) {
                              ToolModel tool = state.toolsList![index];
                              bool isSelected =
                                  state.selectedToolsList!.contains(tool);

                              return Card(
                                color: ConstColors.backgroundColor,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: ListTile(
                                  title: Text(tool.name),
                                  trailing: Checkbox(
                                    activeColor:
                                        ConstColors.backgroundDarkColor,
                                    value: isSelected,
                                    onChanged: (value) {
                                      if (value!) {
                                        context
                                            .read<ToolsRequestBloc>()
                                            .add(AddSelectedTool(tool: tool));
                                      } else {
                                        context.read<ToolsRequestBloc>().add(
                                            RemoveSelectedTool(tool: tool));
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
        },
      ),
    );
  }
}
