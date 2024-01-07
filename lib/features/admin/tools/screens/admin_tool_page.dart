import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/admin/tools/blocs/create_tool_bloc/create_tool_bloc.dart';
import 'package:energy_reimagined/features/admin/tools/blocs/delete_tool_bloc/delete_tool_bloc.dart';
import 'package:energy_reimagined/features/admin/tools/blocs/edit_tool_bloc/edit_tool_bloc.dart';
import 'package:energy_reimagined/features/admin/tools/blocs/tools_stream_bloc/tools_stream_bloc.dart';
import 'package:energy_reimagined/features/admin/tools/screens/admin_create_tool_page.dart';
import 'package:energy_reimagined/features/admin/tools/screens/admin_edit_tool_page.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tools_repository/tools_repository.dart';

class AdminToolPage extends StatelessWidget {
  const AdminToolPage({super.key});

  @override
  Widget build(BuildContext context) {
    final toolsStream = context.watch<ToolsStreamBloc>().state;

    return WillPopScope(
      onWillPop: () async {
        return await WillPopScoopService().showCloseConfirmationDialog(context);
      },
      child: BlocListener<DeleteToolBloc, DeleteToolState>(
        listener: (context, state) {
          if (state is DeleteToolSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Tool Removed Successfully'),
                ),
              );
          } else if (state is DeleteToolFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Tool Removed Failure'),
                ),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tools List",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ConstColors.foregroundColor),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => CreateToolBloc(
                                  toolsRepository:
                                      context.read<ToolsRepository>()),
                              child: const AdminCreateToolPage(),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Create Tool",
                        style: TextStyle(color: ConstColors.blackColor),
                      ),
                    ),
                  ],
                ),
              ),
              toolsStream.status == ToolsStreamStatus.loading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : toolsStream.status == ToolsStreamStatus.failure
                      ? const Expanded(
                          child: Center(
                            child: Text("Error Loading Stream"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: toolsStream.toolStream?.length,
                            itemBuilder: (context, index) {
                              final tools = toolsStream.toolStream!;
                              final bool isUnavailable =
                                  tools[index].quantity == 0;

                              return Stack(
                                children: [
                                  Card(
                                      color: ConstColors.backgroundColor,
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child: ListTile(
                                          title: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: tools[index].name,
                                                  style: const TextStyle(
                                                    color:
                                                        ConstColors.whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${'  [${tools[index].category}'}]',
                                                  style: const TextStyle(
                                                    color:
                                                        ConstColors.whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Quantity: ${tools[index].quantity.toString()}',
                                            style: const TextStyle(
                                              color: ConstColors.whiteColor,
                                            ),
                                          ),
                                          trailing: Wrap(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                color: ConstColors.whiteColor,
                                                onPressed: () {
                                                  context
                                                      .read<DeleteToolBloc>()
                                                      .add(ToolDeleteRequested(
                                                          tool: tools[index]));
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                color: ConstColors.whiteColor,
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                BlocProvider(
                                                                  create: (context) =>
                                                                      EditToolBloc(
                                                                          toolsRepository: context.read<
                                                                              ToolsRepository>(),
                                                                          oldToolModel:
                                                                              ToolModel(
                                                                            id: tools[index].id,
                                                                            name:
                                                                                tools[index].name,
                                                                            category:
                                                                                tools[index].category,
                                                                            quantity:
                                                                                tools[index].quantity,
                                                                            lastUpdated:
                                                                                tools[index].lastUpdated,
                                                                          )),
                                                                  child:
                                                                      const AdminEditToolPage(),
                                                                )),
                                                  );
                                                },
                                              ),
                                            ],
                                          ))),
                                  if (isUnavailable)
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Banner(
                                          message: 'Unavailable',
                                          location: BannerLocation.topEnd,
                                          color: ConstColors.redColor,
                                          textStyle: TextStyle(
                                            color: ConstColors.whiteColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
