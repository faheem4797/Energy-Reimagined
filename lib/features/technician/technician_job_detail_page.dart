import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/technician/blocs/tools_request_bloc/tools_request_bloc.dart';
import 'package:energy_reimagined/features/technician/technician_request_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:tools_repository/tools_repository.dart';

class TechnicianJobDetailPage extends StatelessWidget {
  final JobModel jobModel;
  const TechnicianJobDetailPage({required this.jobModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          jobModel.title,
          style: const TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
      ),
      body:
          // WillPopScope(
          //   onWillPop: () async {
          //     return await WillPopScoopService()
          //         .showCloseConfirmationDialog(context);
          //   },
          // child:
          Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Current Status: '),
              Text(jobModel.status == JobStatus.workInProgress
                  ? 'In Progress'
                  : jobModel.status == JobStatus.onHold
                      ? 'On Hold'
                      : jobModel.status == JobStatus.assigned
                          ? 'Assigned'
                          : jobModel.status == JobStatus.cancelled
                              ? 'Cancelled'
                              : jobModel.status == JobStatus.completed
                                  ? 'Completed'
                                  : jobModel.status == JobStatus.pending
                                      ? 'Pending'
                                      : '')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Job Description: '),
              Text(jobModel.description),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Location: '),
              Text(jobModel.locationName),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Municipality'),
              Text(jobModel.municipality),
            ],
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(ConstColors.foregroundColor),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      // const TechnicianRequestToolsPage()
                      BlocProvider(
                    create: (context) => ToolsRequestBloc(
                        toolsRepository: context.read<ToolsRepository>()),
                    child: const TechnicianRequestToolsPage(),
                  ),
                ),
              );
            },
            child: const Text(
              "Request Tools",
              style: TextStyle(color: ConstColors.blackColor),
            ),
          ),
        ],
      ),
      //),
    );
  }
}