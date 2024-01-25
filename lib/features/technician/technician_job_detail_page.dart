import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/reject_job_bloc/reject_job_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/tools_request_bloc/tools_request_bloc.dart';
import 'package:energy_reimagined/features/technician/technician_request_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      body: BlocListener<RejectJobBloc, RejectJobState>(
        listener: (context, state) {
          if (state is RejectJobFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
          }
          if (state is RejectJobSuccess) {
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Current Status: ',
                      style: TextStyle(
                          color: ConstColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      jobModel.status == JobStatus.workInProgress
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
                                              : jobModel.status ==
                                                      JobStatus.rejected
                                                  ? 'Rejected'
                                                  : '',
                      style: TextStyle(
                        color: ConstColors.blackColor,
                        fontSize: 16.sp,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Job Description',
                        style: TextStyle(
                            color: ConstColors.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                        width: double.infinity,
                        height: 175.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                              child: Text(jobModel.description)),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location',
                        style: TextStyle(
                            color: ConstColors.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                        width: double.infinity,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                              child: Text(jobModel.locationName)),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Municipality: ',
                      style: TextStyle(
                          color: ConstColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      jobModel.municipality,
                      style: TextStyle(
                        color: ConstColors.blackColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                jobModel.status == JobStatus.assigned
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => ToolsRequestBloc(
                                        toolsRepository:
                                            context.read<ToolsRepository>(),
                                        jobsRepository:
                                            context.read<JobsRepository>(),
                                        oldJobModel: jobModel,
                                        userId: context
                                            .read<AuthenticationBloc>()
                                            .state
                                            .userModel!
                                            .id),
                                    child: const TechnicianRequestToolsPage(),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Accept Job",
                              style: TextStyle(color: ConstColors.blackColor),
                            ),
                          ),
                          BlocBuilder<RejectJobBloc, RejectJobState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
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
                                onPressed: state is RejectJobLoading
                                    ? null
                                    : () async {
                                        String? rejectionReason =
                                            await showRejectionDialog(context);

                                        if (rejectionReason != null) {
                                          if (!context.mounted) return;
                                          context.read<RejectJobBloc>().add(
                                              RejectJob(
                                                  rejectReason:
                                                      rejectionReason));
                                        }
                                      },
                                child: state is RejectJobLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Text(
                                        "Reject Job",
                                        style: TextStyle(
                                            color: ConstColors.whiteColor),
                                      ),
                              );
                            },
                          ),
                        ],
                      )
                    : jobModel.status == JobStatus.cancelled ||
                            jobModel.status == JobStatus.rejected
                        ? Container()
                        : ElevatedButton(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => ToolsRequestBloc(
                                        toolsRepository:
                                            context.read<ToolsRepository>(),
                                        jobsRepository:
                                            context.read<JobsRepository>(),
                                        oldJobModel: jobModel,
                                        userId: context
                                            .read<AuthenticationBloc>()
                                            .state
                                            .userModel!
                                            .id),
                                    child: const TechnicianRequestToolsPage(),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Request Tools",
                              style: TextStyle(color: ConstColors.whiteColor),
                            ),
                          ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
      //),
    );
  }

  Future<String?> showRejectionDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String rejectionReason = '';

        return AlertDialog(
          title: const Text('Provide a Reason for Rejection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  initialValue: rejectionReason,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Reason'),
                  onChanged: (value) {
                    rejectionReason = value;
                  },
                ),
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
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(rejectionReason);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
