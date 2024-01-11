import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/create_job_bloc/create_job_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/delete_job_bloc/delete_job_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/edit_job_bloc/edit_job_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/jobs_stream_bloc/jobs_stream_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/screens/admin_create_job_page.dart';
import 'package:energy_reimagined/features/admin/jobs/screens/admin_edit_job_page.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_repository/jobs_repository.dart';

class AdminJobPage extends StatelessWidget {
  const AdminJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsStream = context.watch<JobsStreamBloc>().state;

    return WillPopScope(
      onWillPop: () async {
        return await WillPopScoopService().showCloseConfirmationDialog(context);
      },
      child: BlocListener<DeleteJobBloc, DeleteJobState>(
        listener: (context, state) {
          if (state is DeleteJobSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Job Removed Successfully'),
                ),
              );
          } else if (state is DeleteJobFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Job Removed Failure'),
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
                      "Jobs List",
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
                              create: (context) => CreateJobBloc(
                                  jobsRepository:
                                      context.read<JobsRepository>()),
                              child: const AdminCreateJobPage(),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Create Job",
                        style: TextStyle(color: ConstColors.blackColor),
                      ),
                    ),
                  ],
                ),
              ),
              jobsStream.status == JobsStreamStatus.loading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : jobsStream.status == JobsStreamStatus.failure
                      ? const Expanded(
                          child: Center(
                            child: Text("Error Loading Stream"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: jobsStream.jobStream?.length,
                            itemBuilder: (context, index) {
                              final jobs = jobsStream.jobStream!;
                              final bool isOnHold =
                                  jobs[index].status == JobStatus.onHold;
                              final bool isCancelled =
                                  jobs[index].status == JobStatus.cancelled;

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
                                                  text: jobs[index].title,
                                                  style: const TextStyle(
                                                    color:
                                                        ConstColors.whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: jobs[index].status ==
                                                          JobStatus.pending
                                                      ? '  [Pending]'
                                                      : jobs[index].status ==
                                                              JobStatus.assigned
                                                          ? '  [Assigned]'
                                                          : jobs[index]
                                                                      .status ==
                                                                  JobStatus
                                                                      .cancelled
                                                              ? '  [Cancelled]'
                                                              : jobs[index]
                                                                          .status ==
                                                                      JobStatus
                                                                          .completed
                                                                  ? '  [Completed]'
                                                                  : jobs[index]
                                                                              .status ==
                                                                          JobStatus
                                                                              .started
                                                                      ? '  [Started]'
                                                                      : jobs[index].status ==
                                                                              JobStatus.onHold
                                                                          ? '  [On Hold]'
                                                                          : '',
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
                                            jobs[index].description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
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
                                                  checkConnectionFunc(context,
                                                      () {
                                                    context
                                                        .read<DeleteJobBloc>()
                                                        .add(
                                                          JobDeleteRequested(
                                                              job: jobs[index]),
                                                        );
                                                  });
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
                                                                      EditJobBloc(
                                                                    jobsRepository:
                                                                        context.read<
                                                                            JobsRepository>(),
                                                                    userId: context
                                                                        .read<
                                                                            AuthenticationBloc>()
                                                                        .state
                                                                        .userModel!
                                                                        .id,
                                                                    oldJobModel:
                                                                        JobModel(
                                                                      id: jobs[
                                                                              index]
                                                                          .id,
                                                                      title: jobs[
                                                                              index]
                                                                          .title,
                                                                      description:
                                                                          jobs[index]
                                                                              .description,
                                                                      status: jobs[
                                                                              index]
                                                                          .status,
                                                                      assignedTechnicianId:
                                                                          jobs[index]
                                                                              .assignedTechnicianId,
                                                                      locationName:
                                                                          jobs[index]
                                                                              .locationName,
                                                                      locationLatitude:
                                                                          jobs[index]
                                                                              .locationLatitude,
                                                                      locationLongitude:
                                                                          jobs[index]
                                                                              .locationLongitude,
                                                                      holdReason:
                                                                          jobs[index]
                                                                              .holdReason,
                                                                      cancelReason:
                                                                          jobs[index]
                                                                              .cancelReason,
                                                                      createdTimestamp:
                                                                          jobs[index]
                                                                              .createdTimestamp,
                                                                      assignedTimestamp:
                                                                          jobs[index]
                                                                              .assignedTimestamp,
                                                                      startedTimestamp:
                                                                          jobs[index]
                                                                              .startedTimestamp,
                                                                      holdTimestamp:
                                                                          jobs[index]
                                                                              .holdTimestamp,
                                                                      completedTimestamp:
                                                                          jobs[index]
                                                                              .completedTimestamp,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const AdminEditJobPage(),
                                                                )),
                                                  );
                                                },
                                              ),
                                            ],
                                          ))),
                                  if (isOnHold || isCancelled)
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Banner(
                                          message: isOnHold
                                              ? 'On Hold'
                                              : 'Cancelled',
                                          location: BannerLocation.topEnd,
                                          color: ConstColors.redColor,
                                          textStyle: const TextStyle(
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
