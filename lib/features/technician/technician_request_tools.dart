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
                        if (!context.mounted) return;
                        checkConnectionFunc(context, () {
                          context
                              .read<ToolsRequestBloc>()
                              .add(RequestSelectedTools());
                        });
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
        builder: (context, state) {
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
                        state.selectedToolsList.isEmpty
                            ? Container()
                            : SizedBox(
                                height: 50,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: state.selectedToolsList
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
                                child: ListTile(
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
                                    'Quantity: ${tool.quantity.toString()}',
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
