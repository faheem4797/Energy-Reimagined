import 'package:cached_network_image/cached_network_image.dart';
import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/complete_job_bloc/complete_job_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/reject_job_bloc/reject_job_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/tools_request_bloc/tools_request_bloc.dart';
import 'package:energy_reimagined/features/technician/technician_request_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:tools_repository/tools_repository.dart';

class TechnicianJobDetailPage extends StatefulWidget {
  final JobModel jobModel;
  const TechnicianJobDetailPage({required this.jobModel, super.key});

  @override
  State<TechnicianJobDetailPage> createState() =>
      _TechnicianJobDetailPageState();
}

class _TechnicianJobDetailPageState extends State<TechnicianJobDetailPage> {
  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.jobModel.title,
          style: const TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RejectJobBloc, RejectJobState>(
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
          ),
          BlocListener<CompleteJobBloc, CompleteJobState>(
              listener: (context, state) {
            if (state.status == CompleteJobStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content:
                        Text(state.errorMessage ?? 'Failed to Upload iamge'),
                  ),
                );
            } else if (state.status == CompleteJobStatus.success) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Job Completed Successfully'),
                  ),
                );
              Navigator.of(context).pop();
            }
          }),
        ],
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
                      widget.jobModel.status == JobStatus.workInProgress
                          ? 'In Progress'
                          : widget.jobModel.status == JobStatus.onHold
                              ? 'On Hold'
                              : widget.jobModel.status == JobStatus.assigned
                                  ? 'Assigned'
                                  : widget.jobModel.status ==
                                          JobStatus.completed
                                      ? 'Completed'
                                      : widget.jobModel.status ==
                                              JobStatus.pending
                                          ? 'Pending'
                                          : widget.jobModel.status ==
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
                              child: Text(widget.jobModel.description)),
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
                              child: Text(widget.jobModel.locationName)),
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
                      widget.jobModel.municipality,
                      style: TextStyle(
                        color: ConstColors.blackColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                widget.jobModel.status ==
                        JobStatus.assigned //Accept job and reject job buttons
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          acceptJobButton(mainContext),
                          rejectJobButton(),
                        ],
                      )
                    : widget.jobModel.status ==
                            JobStatus.completed //Completion time and image
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Completed on: ',
                                    style: TextStyle(
                                        color: ConstColors.blackColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat('dd-MM-yyyy HH:mm').format(
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            widget
                                                .jobModel.completedTimestamp)),
                                    style: TextStyle(
                                      color: ConstColors.blackColor,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.r)),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      widget.jobModel.afterCompleteImageUrl,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                          child: Text('Error loading image')),
                                ),
                              ),
                            ],
                          )
                        : widget.jobModel.status == JobStatus.onHold
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  requestToolsButton(mainContext),
                                  rejectJobButton(),
                                ],
                              )
                            : widget.jobModel.status == JobStatus.workInProgress
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          requestToolsButton(mainContext),
                                          completeJobButton(),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      rejectJobButton(),
                                    ],
                                  )
                                : Container(),
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

  ElevatedButton acceptJobButton(BuildContext mainContext) {
    return ElevatedButton(
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
          mainContext,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ToolsRequestBloc(
                  toolsRepository: context.read<ToolsRepository>(),
                  jobsRepository: context.read<JobsRepository>(),
                  oldJobModel: widget.jobModel,
                  userId:
                      context.read<AuthenticationBloc>().state.userModel!.id),
              child: const TechnicianRequestToolsPage(),
            ),
          ),
        );
      },
      child: const Text(
        "Accept Job",
        style: TextStyle(color: ConstColors.blackColor),
      ),
    );
  }

  BlocBuilder<CompleteJobBloc, CompleteJobState> completeJobButton() {
    return BlocBuilder<CompleteJobBloc, CompleteJobState>(
      builder: (context, state) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(ConstColors.greenColor),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          onPressed: state.status == CompleteJobStatus.inProgress
              ? null
              : () async {
                  await _showCompleteJobPopup(context);
                },
          child: state.status == CompleteJobStatus.inProgress
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const CircularProgressIndicator(
                      color: ConstColors.whiteColor,
                    ),
                  ),
                )
              : const Text(
                  "Complete Job",
                  style: TextStyle(color: ConstColors.whiteColor),
                ),
        );
      },
    );
  }

  ElevatedButton requestToolsButton(BuildContext mainContext) {
    return ElevatedButton(
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
          mainContext,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ToolsRequestBloc(
                  toolsRepository: context.read<ToolsRepository>(),
                  jobsRepository: context.read<JobsRepository>(),
                  oldJobModel: widget.jobModel,
                  userId:
                      context.read<AuthenticationBloc>().state.userModel!.id),
              child: const TechnicianRequestToolsPage(),
            ),
          ),
        );
      },
      child: const Text(
        "Request Tools",
        style: TextStyle(color: ConstColors.whiteColor),
      ),
    );
  }

  BlocBuilder<RejectJobBloc, RejectJobState> rejectJobButton() {
    return BlocBuilder<RejectJobBloc, RejectJobState>(
      builder: (context, state) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          onPressed: state is RejectJobLoading
              ? null
              : () async {
                  String? rejectionReason = await showRejectionDialog(context);

                  if (rejectionReason != null) {
                    if (!context.mounted) return;
                    context
                        .read<RejectJobBloc>()
                        .add(RejectJob(rejectReason: rejectionReason));
                  }
                },
          child: state is RejectJobLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Text(
                  "Reject Job",
                  style: TextStyle(color: ConstColors.whiteColor),
                ),
        );
      },
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

  Future<void> _showCompleteJobPopup(BuildContext blocContext) async {
    final formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: blocContext,
      builder: (BuildContext context) {
        String workDoneDescription = '';

        return BlocProvider.value(
          value: blocContext.read<CompleteJobBloc>(),
          child: BlocBuilder<CompleteJobBloc, CompleteJobState>(
            builder: (context, state) {
              return AlertDialog(
                title: const Text(
                  'Upload an image showing the solved issue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<CompleteJobBloc>()
                            .add(const AfterCompletionImageChanged());
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: ConstColors.greyColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.r))),
                          height: 200.h,
                          width: double.maxFinite,
                          child: state.imageToolFileBytes == null ||
                                  state.imageToolFileNameFromFilePicker == null
                              ? const Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo),
                                      Text(
                                        'Upload Image',
                                        //style: kSmallBlackTextStyle,
                                      )
                                    ],
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.r)),
                                  child: Image.memory(
                                    state.imageToolFileBytes!,
                                    fit: BoxFit.fill,
                                  ),
                                )),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        initialValue: workDoneDescription,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a reason';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(labelText: 'Reason'),
                        onChanged: (value) {
                          workDoneDescription = value;
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
                        checkConnectionFunc(context, () {
                          context.read<CompleteJobBloc>().add(CompleteJob(
                              workDoneDescription: workDoneDescription));
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget imageSelectContainer(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            context
                .read<CompleteJobBloc>()
                .add(const AfterCompletionImageChanged());
          },
          child: BlocBuilder<CompleteJobBloc, CompleteJobState>(
            builder: (context, state) {
              return Container(
                  decoration: BoxDecoration(
                      color: ConstColors.greyColor,
                      borderRadius: BorderRadius.all(Radius.circular(7.r))),
                  height: 200.h,
                  width: double.maxFinite,
                  child: state.imageToolFileBytes == null ||
                          state.imageToolFileNameFromFilePicker == null
                      ? const Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo),
                              Text(
                                'Upload Image',
                                //style: kSmallBlackTextStyle,
                              )
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(7.r)),
                          child: Image.memory(
                            state.imageToolFileBytes!,
                            fit: BoxFit.fill,
                          ),
                        ));
            },
          ),
        ),
      ],
    );
  }
}
