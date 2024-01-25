import 'package:cached_network_image/cached_network_image.dart';
import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/qr_code_scanner_bloc/qr_code_scanner_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/tool_request_bloc/tool_request_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/screens/admin_qrcode_scanner_page.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_repository/jobs_repository.dart';

class AdminToolsRequestPage extends StatelessWidget {
  final JobModel jobModel;
  const AdminToolsRequestPage({required this.jobModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
        centerTitle: true,
        title: const Text(
          'Tools Request',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ToolRequestBloc, ToolRequestState>(
          builder: (context, state) {
            if (state is ToolRequestInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ToolRequestFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else if (state is ToolRequestSuccess) {
              return Column(
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
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) => QrCodeScannerBloc(
                                        jobsRepository:
                                            context.read<JobsRepository>(),
                                        jobModel: jobModel,
                                        userId: context
                                            .read<AuthenticationBloc>()
                                            .state
                                            .userModel!
                                            .id,
                                      ),
                                      child: const AdminQRCodeScannerPage(),
                                    )));
                          },
                          child: const Text(
                            "Scan QR Code",
                            style: TextStyle(color: ConstColors.blackColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.toolsList.length,
                      itemBuilder: (context, index) {
                        final bool isUnavailable =
                            state.toolsList[index].quantity == 0;
                        return Stack(
                          children: [
                            Card(
                                color: ConstColors.backgroundColor,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        state.toolsList[index].imageUrl),
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: state.toolsList[index].name,
                                          style: const TextStyle(
                                            color: ConstColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${'  [${state.toolsList[index].category}'}]',
                                          style: const TextStyle(
                                            color: ConstColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Quantity Requested: ${state.toolsListQuantity[index].toString()}',
                                    style: const TextStyle(
                                      color: ConstColors.whiteColor,
                                    ),
                                  ),
                                )),
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
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
