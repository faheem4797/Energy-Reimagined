import 'package:cached_network_image/cached_network_image.dart';
import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
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
  Future<void> _showToolsPopup(BuildContext blocContext) async {
    return showDialog<void>(
      context: blocContext,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: blocContext.read<ToolsRequestBloc>(),
          child: BlocBuilder<ToolsRequestBloc, ToolsRequestState>(
            builder: (context, state) {
              return AlertDialog(
                title: const Text(
                  'Are you sure you want to request these tools?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                content: state.selectedToolsList.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No Tools Selected',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var tool in state.selectedToolsList)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  tool.name,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove,
                                        color: ConstColors.blackColor,
                                      ),
                                      onPressed: () {
                                        if (state.selectedToolsQuantityList[
                                                state.selectedToolsList
                                                    .indexOf(tool)] >
                                            1) {
                                          context.read<ToolsRequestBloc>().add(
                                              DecreaseQuantity(
                                                  index: state.selectedToolsList
                                                      .indexOf(tool)));
                                        }
                                      },
                                    ),
                                    Text(
                                      state.selectedToolsQuantityList[state
                                              .selectedToolsList
                                              .indexOf(tool)]
                                          .toString(),
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: ConstColors.blackColor,
                                      ),
                                      onPressed: () {
                                        context.read<ToolsRequestBloc>().add(
                                            IncreaseQuantity(
                                                index: state.selectedToolsList
                                                    .indexOf(tool)));
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: ConstColors.blackColor,
                                      ),
                                      onPressed: () {
                                        context.read<ToolsRequestBloc>().add(
                                            RemoveSelectedTool(tool: tool));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      checkConnectionFunc(context, () {
                        context
                            .read<ToolsRequestBloc>()
                            .add(RequestSelectedTools());
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Proceed'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        actions: <Widget>[
          BlocBuilder<ToolsRequestBloc, ToolsRequestState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(
                  Icons.remove_from_queue,
                  color: ConstColors.whiteColor,
                ),
                onPressed: state.status == ToolsRequestStatus.inProgress
                    ? null
                    : () async {
                        _showToolsPopup(context);
                        // if (!context.mounted) return;
                        // checkConnectionFunc(context, () {
                        //   context
                        //       .read<ToolsRequestBloc>()
                        //       .add(RequestSelectedTools());
                        // });
                      },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ToolsRequestBloc, ToolsRequestState>(
        listener: (context, state) {
          if (state.status == ToolsRequestStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Error occured'),
                ),
              );
          }
          if (state.status == ToolsRequestStatus.success) {
            Navigator.of(context)
              ..pop()
              ..pop();
          }
        },
        builder: (blocContext, state) {
          return state.status == ToolsRequestStatus.loading ||
                  state.status == ToolsRequestStatus.inProgress
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.status == ToolsRequestStatus.loadingFailure
                  ? const Center(
                      child: Text('Error Loading Tools List'),
                    )
                  : Column(
                      children: [
                        // state.selectedToolsList.isEmpty
                        //     ? Container()
                        //     : SizedBox(
                        //         height: 50,
                        //         child: ListView(
                        //           scrollDirection: Axis.horizontal,
                        //           children: state.selectedToolsList
                        //               .map((tool) => Padding(
                        //                     padding: EdgeInsets.symmetric(
                        //                         horizontal: 8.w),
                        //                     child: Chip(
                        //                       label: Text(tool.name),
                        //                     ),
                        //                   ))
                        //               .toList(),
                        //         ),
                        //       ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.toolsList.length,
                            itemBuilder: (context, index) {
                              ToolModel tool = state.toolsList[index];
                              bool isSelected =
                                  state.selectedToolsList.contains(tool);

                              return Card(
                                color: ConstColors.backgroundColor,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: ExpansionTile(
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        tool.imageUrl),
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: tool.name,
                                          style: const TextStyle(
                                            color: ConstColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${'  [${tool.category}'}]',
                                          style: const TextStyle(
                                            color: ConstColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Available Quantity: ${tool.quantity.toString()}',
                                    style: const TextStyle(
                                      color: ConstColors.whiteColor,
                                    ),
                                  ),
                                  trailing: Checkbox(
                                    activeColor:
                                        ConstColors.backgroundDarkColor,
                                    value: isSelected,
                                    onChanged: (value) {
                                      if (value!) {
                                        context.read<ToolsRequestBloc>().add(
                                            AddSelectedTool(
                                                tool: tool, toolQuantity: 1));
                                      } else {
                                        context.read<ToolsRequestBloc>().add(
                                            RemoveSelectedTool(tool: tool));
                                      }
                                    },
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8),
                                      child: Text(
                                        tool.description,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: ConstColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CachedNetworkImage(
                                          imageUrl: tool.imageUrl),
                                    ),
                                  ],
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
