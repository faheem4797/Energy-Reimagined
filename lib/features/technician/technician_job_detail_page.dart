import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/accept_job_bloc/accept_job_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/add_after_image_bloc/add_after_image_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/add_before_image_bloc/add_before_image_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/add_work_description_bloc/add_work_description_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/complete_job_bloc/complete_job_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/job_detail_bloc/job_detail_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/reject_job_bloc/reject_job_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/technician_jobs_stream_bloc/technician_jobs_stream_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/tools_request_bloc/tools_request_bloc.dart';
import 'package:energy_reimagined/features/technician/technician_request_tools.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:tools_repository/tools_repository.dart';

class TechnicianJobDetailPage extends StatefulWidget {
  final JobModel job;
  const TechnicianJobDetailPage({required this.job, super.key});

  @override
  State<TechnicianJobDetailPage> createState() =>
      _TechnicianJobDetailPageState();
}

class _TechnicianJobDetailPageState extends State<TechnicianJobDetailPage> {
  final TextEditingController myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myController.text = widget.job.workDoneDescription;
  }

  @override
  Widget build(BuildContext mainContext) {
    return BlocBuilder<JobDetailBloc, JobDetailState>(
      builder: (context, jobDetailState) {
        return jobDetailState.status == JobDetailStatus.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : jobDetailState.status == JobDetailStatus.failure
                ? const Center(
                    child: Text("Error Loading Job"),
                  )
                : Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        jobDetailState.job.title,
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
                              // Navigator.of(context).pop();
                            }
                          },
                        ),
                        BlocListener<AddWorkDescriptionBloc,
                                AddWorkDescriptionState>(
                            listener: (context, state) {
                          if (state.status ==
                              AddWorkDescriptionStatus.failure) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(state.errorMessage ??
                                      'Error Occured While Uploading Work Description'),
                                ),
                              );
                          } else if (state.status ==
                              AddWorkDescriptionStatus.success) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Work Description Uploaded Successfully'),
                                ),
                              );
                          }
                        }),
                        BlocListener<CompleteJobBloc, CompleteJobState>(
                            listener: (context, state) {
                          if (state.status == CompleteJobStatus.failure) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(state.errorMessage ??
                                      'Error Occured While Completing Job'),
                                ),
                              );
                          } else if (state.status ==
                              CompleteJobStatus.success) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Job Completed Successfully'),
                                ),
                              );
                            // Navigator.of(context).pop();
                          }
                        }),
                        BlocListener<AddBeforeImageBloc, AddBeforeImageState>(
                            listener: (context, state) {
                          if (state.status == AddBeforeImageStatus.failure) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(state.errorMessage ??
                                      'Failed to Upload Image'),
                                ),
                              );
                          } else if (state.status ==
                              AddBeforeImageStatus.success) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Uploaded Image Successfully'),
                                ),
                              );
                          }
                        }),
                        BlocListener<AddAfterImageBloc, AddAfterImageState>(
                            listener: (context, state) {
                          if (state.status == AddAfterImageStatus.failure) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(state.errorMessage ??
                                      'Failed to Upload Image'),
                                ),
                              );
                          } else if (state.status ==
                              AddAfterImageStatus.success) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Uploaded Image Successfully'),
                                ),
                              );
                          }
                        }),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    jobDetailState.job.status ==
                                            JobStatus.workInProgress
                                        ? 'In Progress'
                                        : jobDetailState.job.status ==
                                                JobStatus.onHold
                                            ? 'On Hold'
                                            : jobDetailState.job.status ==
                                                    JobStatus.assigned
                                                ? 'Assigned'
                                                : jobDetailState.job.status ==
                                                        JobStatus.completed
                                                    ? 'Completed'
                                                    : jobDetailState
                                                                .job.status ==
                                                            JobStatus.pending
                                                        ? 'Pending'
                                                        : jobDetailState.job
                                                                    .status ==
                                                                JobStatus
                                                                    .rejected
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
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: ConstColors.blackColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    jobDetailState.job.description,
                                  ),
                                  // Container(
                                  //     width: double.infinity,
                                  //     height: 175.h,
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.grey[300],
                                  //       borderRadius: BorderRadius.circular(20.r),
                                  //     ),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(16.0),
                                  //       child: SingleChildScrollView(
                                  //           child: Text(widget.jobModel.description)),
                                  //     )),
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
                                  Text(
                                    jobDetailState.job.locationName,
                                  ),
                                  // Container(
                                  //     width: double.infinity,
                                  //     height: 100.h,
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.grey[300],
                                  //       borderRadius: BorderRadius.circular(20.r),
                                  //     ),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(16.0),
                                  //       child: SingleChildScrollView(
                                  //           child: Text(widget.jobModel.locationName)),
                                  //     )),
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
                                    jobDetailState.job.municipality,
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
                              //
                              //
                              //
                              Visibility(
                                visible: jobDetailState.job.status !=
                                    JobStatus.assigned,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tools Requested: ',
                                      style: TextStyle(
                                          color: ConstColors.blackColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    jobDetailState.job.status ==
                                                JobStatus.onHold ||
                                            jobDetailState.job.status ==
                                                JobStatus.workInProgress
                                        ? requestToolsButton(
                                            mainContext, jobDetailState.job)
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: jobDetailState.job.status !=
                                    JobStatus.assigned,
                                child: BlocBuilder<ToolsRequestBloc,
                                    ToolsRequestState>(
                                  builder: (blocContext, state) {
                                    return state.status ==
                                                ToolsRequestStatus.loading ||
                                            state.status ==
                                                ToolsRequestStatus.inProgress
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : state.status ==
                                                ToolsRequestStatus
                                                    .loadingFailure
                                            ? const Center(
                                                child: Text(
                                                    'Error Loading Tools List'),
                                              )
                                            : state.allRequestedToolsList
                                                    .isEmpty
                                                ? const Text(
                                                    'No Tools Requested')
                                                : SizedBox(
                                                    height: 120.h,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: state
                                                                .allRequestedToolsList
                                                                .length,

                                                            //state.toolsList.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              ToolModel tool =
                                                                  state.allRequestedToolsList[
                                                                      index];

                                                              return Card(
                                                                color: ConstColors
                                                                    .backgroundColor,
                                                                elevation: 4,
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        8),
                                                                child:
                                                                    ExpansionTile(
                                                                  expandedCrossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  leading:
                                                                      CircleAvatar(
                                                                    backgroundImage:
                                                                        CachedNetworkImageProvider(
                                                                            tool.imageUrl),
                                                                  ),
                                                                  title:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                              tool.name,
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                ConstColors.whiteColor,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              '${'  [${tool.category}'}]',
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                ConstColors.whiteColor,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  subtitle:
                                                                      Text(
                                                                    'Requested Quantity: ${state.allRequestedToolsQuantityList[index].toString()}',
                                                                    style:
                                                                        const TextStyle(
                                                                      color: ConstColors
                                                                          .whiteColor,
                                                                    ),
                                                                  ),
                                                                  // trailing: Checkbox(
                                                                  //   activeColor: ConstColors
                                                                  //       .backgroundDarkColor,
                                                                  //   value: isSelected,
                                                                  //   onChanged: (value) {
                                                                  //     if (value!) {
                                                                  //       context
                                                                  //           .read<ToolsRequestBloc>()
                                                                  //           .add(AddSelectedTool(
                                                                  //               tool: tool,
                                                                  //               toolQuantity: 1));
                                                                  //     } else {
                                                                  //       context
                                                                  //           .read<ToolsRequestBloc>()
                                                                  //           .add(RemoveSelectedTool(
                                                                  //               tool: tool));
                                                                  //     }
                                                                  //   },
                                                                  // ),
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              16.0,
                                                                          vertical:
                                                                              8),
                                                                      child:
                                                                          Text(
                                                                        tool.description,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              ConstColors.whiteColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                      child: CachedNetworkImage(
                                                                          imageUrl:
                                                                              tool.imageUrl),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                  },
                                ),
                              ),
                              SizedBox(height: 20.h),

                              Visibility(
                                visible: jobDetailState.job.status !=
                                    JobStatus.assigned,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Site Evidence - Before Work',
                                          style: TextStyle(
                                              color: ConstColors.blackColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Visibility(
                                          visible: jobDetailState.job.status ==
                                                  JobStatus.workInProgress ||
                                              jobDetailState.job.status ==
                                                  JobStatus.onHold,
                                          child: IconButton(
                                              onPressed: () {
                                                checkConnectionFunc(context,
                                                    () {
                                                  context
                                                      .read<
                                                          AddBeforeImageBloc>()
                                                      .add(
                                                          UpdateJobWithBeforeImage(
                                                              job:
                                                                  jobDetailState
                                                                      .job));
                                                });
                                              },
                                              icon:
                                                  const Icon(Icons.add_circle)),
                                        )
                                      ],
                                    ),
                                    BlocBuilder<AddBeforeImageBloc,
                                        AddBeforeImageState>(
                                      builder: (context, state) {
                                        return state.status ==
                                                AddBeforeImageStatus.inProgress
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : jobDetailState
                                                    .job
                                                    .beforeCompleteImageUrl
                                                    .isEmpty
                                                ? const Text(
                                                    'No image added yet')
                                                : CarouselSlider(
                                                    options: CarouselOptions(
                                                      enableInfiniteScroll:
                                                          false,
                                                    ),
                                                    items: jobDetailState.job
                                                        .beforeCompleteImageUrl
                                                        .map((i) {
                                                      return Builder(
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5.w),
                                                            child:
                                                                CachedNetworkImage(
                                                              fit: BoxFit.fill,
                                                              imageUrl: i,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const Center(
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Center(
                                                                      child: Text(
                                                                          'Error loading image')),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }).toList(),
                                                  );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),

                              Visibility(
                                visible: jobDetailState.job.status !=
                                    JobStatus.assigned,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Site Evidence - After Work',
                                          style: TextStyle(
                                              color: ConstColors.blackColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Visibility(
                                          visible: jobDetailState.job.status ==
                                                  JobStatus.workInProgress ||
                                              jobDetailState.job.status ==
                                                  JobStatus.onHold,
                                          child: IconButton(
                                              onPressed: () {
                                                checkConnectionFunc(context,
                                                    () {
                                                  context
                                                      .read<AddAfterImageBloc>()
                                                      .add(
                                                          UpdateJobWithAfterImage(
                                                              job:
                                                                  jobDetailState
                                                                      .job));
                                                });
                                              },
                                              icon:
                                                  const Icon(Icons.add_circle)),
                                        )
                                      ],
                                    ),
                                    BlocBuilder<AddAfterImageBloc,
                                        AddAfterImageState>(
                                      builder: (context, state) {
                                        return state.status ==
                                                AddAfterImageStatus.inProgress
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : jobDetailState
                                                    .job
                                                    .afterCompleteImageUrl
                                                    .isEmpty
                                                ? const Text(
                                                    'No image added yet')
                                                : CarouselSlider(
                                                    options: CarouselOptions(
                                                      enableInfiniteScroll:
                                                          false,
                                                    ),
                                                    items: jobDetailState.job
                                                        .afterCompleteImageUrl
                                                        .map((i) {
                                                      return Builder(
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5.w),
                                                            child:
                                                                CachedNetworkImage(
                                                              fit: BoxFit.fill,
                                                              imageUrl: i,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const Center(
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Center(
                                                                      child: Text(
                                                                          'Error loading image')),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }).toList(),
                                                  );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),

                              //TODO: ADD PROPER TEXTFIELD SCENARIO
                              Visibility(
                                visible: jobDetailState.job.status !=
                                    JobStatus.assigned,
                                child: CustomTextFormField(
                                  labelText: 'Work Description',
                                  controller: myController,
                                  enabled: jobDetailState.job.status ==
                                          JobStatus.workInProgress ||
                                      jobDetailState.job.status ==
                                          JobStatus.onHold,
                                  // initialValue:
                                  //     jobDetailState.job.workDoneDescription,
                                  suffixIcon: jobDetailState.job.status ==
                                              JobStatus.workInProgress ||
                                          jobDetailState.job.status ==
                                              JobStatus.onHold
                                      ? IconButton(
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            checkConnectionFunc(context, () {
                                              context
                                                  .read<
                                                      AddWorkDescriptionBloc>()
                                                  .add(
                                                      UpdateJobWithWorkDescription(
                                                          workDescription:
                                                              myController.text,
                                                          job: jobDetailState
                                                              .job));
                                            });
                                          },
                                          icon: const Icon(Icons.add_circle))
                                      : null,
                                ),
                              ),
                              SizedBox(height: 20.h),

                              //
                              //
                              jobDetailState.job.status ==
                                      JobStatus
                                          .assigned //Accept job and reject job buttons
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        acceptJobButton(
                                            mainContext, jobDetailState.job),
                                        rejectJobButton(),
                                      ],
                                    )
                                  // : state.job.status ==
                                  //         JobStatus
                                  //             .completed //Completion time and image
                                  //     ? const Text('Completed')
                                  : jobDetailState.job.status ==
                                          JobStatus.onHold
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            rejectJobButton(),
                                          ],
                                        )
                                      : jobDetailState.job.status ==
                                              JobStatus.workInProgress
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                completeJobButton(
                                                    jobDetailState.job),
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
                    ));
        //);
      },
    );
  }

  ElevatedButton acceptJobButton(BuildContext mainContext, JobModel jobModel) {
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
        checkConnectionFunc(context, () {
          context.read<AcceptJobBloc>().add(const AcceptJob());
        });
        // Navigator.push(
        //   mainContext,
        //   MaterialPageRoute(
        //     builder: (context) => MultiBlocProvider(
        //       providers: [
        //         BlocProvider(
        //           create: (context) => ToolsRequestBloc(
        //               toolsRepository: context.read<ToolsRepository>(),
        //               jobsRepository: context.read<JobsRepository>(),
        //               oldJobModel: jobModel,
        //               userId: context
        //                   .read<AuthenticationBloc>()
        //                   .state
        //                   .userModel!
        //                   .id),
        //         ),
        //         //TODO: NOT GETTING STREAMBLOC
        //         BlocProvider.value(
        //           value: mainContext.read<TechnicianJobsStreamBloc>(),
        //         ),
        //       ],
        //       child: const TechnicianRequestToolsPage(),
        //     ),
        //   ),
        // );
      },
      child: const Text(
        "Accept Job",
        style: TextStyle(color: ConstColors.blackColor),
      ),
    );
  }

  BlocBuilder<CompleteJobBloc, CompleteJobState> completeJobButton(
      JobModel job) {
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
                  checkConnectionFunc(context, () {
                    context.read<CompleteJobBloc>().add(CompleteJob(job: job));
                  });
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

  // BlocBuilder<BeforeCompletionImageBloc, BeforeCompletionImageState>
  //     beforeCompletionImageButton() {
  //   return BlocBuilder<BeforeCompletionImageBloc, BeforeCompletionImageState>(
  //     builder: (context, state) {
  //       return ElevatedButton(
  //         style: ButtonStyle(
  //           backgroundColor:
  //               MaterialStateProperty.all<Color>(ConstColors.backgroundColor),
  //           padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
  //             const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  //           ),
  //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //             RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //           ),
  //         ),
  //         onPressed: state.status == BeforeCompletionImageStatus.inProgress
  //             ? null
  //             : () async {
  //                 await _showAddBeforeCompletionImagePopup(context);
  //               },
  //         child: state.status == BeforeCompletionImageStatus.inProgress
  //             ? Center(
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 16.w),
  //                   child: const CircularProgressIndicator(
  //                     color: ConstColors.whiteColor,
  //                   ),
  //                 ),
  //               )
  //             : const Text(
  //                 "Before Image",
  //                 style: TextStyle(color: ConstColors.whiteColor),
  //               ),
  //       );
  //     },
  //   );
  // }

  ElevatedButton requestToolsButton(
      BuildContext mainContext, JobModel jobModel) {
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
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ToolsRequestBloc(
                      toolsRepository: context.read<ToolsRepository>(),
                      jobsRepository: context.read<JobsRepository>(),
                      oldJobModel: jobModel,
                      userId: context
                          .read<AuthenticationBloc>()
                          .state
                          .userModel!
                          .id),
                ),
                BlocProvider.value(
                  value: mainContext.read<TechnicianJobsStreamBloc>(),
                ),
              ],
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

  // Future<void> _showCompleteJobPopup(BuildContext blocContext) async {
  //   final formKey = GlobalKey<FormState>();
  //   return showDialog<void>(
  //     context: blocContext,
  //     builder: (BuildContext context) {
  //       String workDoneDescription = '';

  //       return BlocProvider.value(
  //         value: blocContext.read<CompleteJobBloc>(),
  //         child: BlocBuilder<CompleteJobBloc, CompleteJobState>(
  //           builder: (context, state) {
  //             return AlertDialog(
  //               title: const Text(
  //                 'Upload an image showing the solved issue',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //               content: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.max,
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         context
  //                             .read<CompleteJobBloc>()
  //                             .add(const AfterCompletionImageChanged());
  //                       },
  //                       child: Container(
  //                           decoration: BoxDecoration(
  //                               color: ConstColors.greyColor,
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(7.r))),
  //                           height: 200.h,
  //                           width: double.maxFinite,
  //                           child: state.imageToolFileBytes == null ||
  //                                   state.imageToolFileNameFromFilePicker ==
  //                                       null
  //                               ? const Center(
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     children: [
  //                                       Icon(Icons.add_a_photo),
  //                                       Text(
  //                                         'Upload Image',
  //                                         //style: kSmallBlackTextStyle,
  //                                       )
  //                                     ],
  //                                   ),
  //                                 )
  //                               : ClipRRect(
  //                                   borderRadius:
  //                                       BorderRadius.all(Radius.circular(7.r)),
  //                                   child: Image.memory(
  //                                     state.imageToolFileBytes!,
  //                                     fit: BoxFit.fill,
  //                                   ),
  //                                 )),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     Form(
  //                       key: formKey,
  //                       child: TextFormField(
  //                         initialValue: workDoneDescription,
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return 'Please enter description of the work you have done';
  //                           }
  //                           return null;
  //                         },
  //                         decoration: const InputDecoration(
  //                             errorMaxLines: 2, labelText: 'Work Description'),
  //                         onChanged: (value) {
  //                           workDoneDescription = value;
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text('Cancel'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     if (formKey.currentState!.validate()) {
  //                       checkConnectionFunc(context, () {
  //                         context.read<CompleteJobBloc>().add(CompleteJob(
  //                             workDoneDescription: workDoneDescription));
  //                       });
  //                       Navigator.of(context).pop();
  //                     }
  //                   },
  //                   child: const Text('Submit'),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> _showAddBeforeCompletionImagePopup(
  //     BuildContext blocContext) async {
  //   return showDialog<void>(
  //     context: blocContext,
  //     builder: (BuildContext context) {
  //       return BlocProvider.value(
  //         value: blocContext.read<BeforeCompletionImageBloc>(),
  //         child: BlocBuilder<BeforeCompletionImageBloc,
  //             BeforeCompletionImageState>(
  //           builder: (context, state) {
  //             return AlertDialog(
  //               title: const Text(
  //                 'Upload an image showing the issue',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       context
  //                           .read<BeforeCompletionImageBloc>()
  //                           .add(const BeforeCompletionImageChanged());
  //                     },
  //                     child: Container(
  //                         decoration: BoxDecoration(
  //                             color: ConstColors.greyColor,
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(7.r))),
  //                         height: 200.h,
  //                         width: double.maxFinite,
  //                         child: state.imageToolFileBytes == null ||
  //                                 state.imageToolFileNameFromFilePicker == null
  //                             ? const Center(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Icon(Icons.add_a_photo),
  //                                     Text(
  //                                       'Upload Image',
  //                                       //style: kSmallBlackTextStyle,
  //                                     )
  //                                   ],
  //                                 ),
  //                               )
  //                             : ClipRRect(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(7.r)),
  //                                 child: Image.memory(
  //                                   state.imageToolFileBytes!,
  //                                   fit: BoxFit.fill,
  //                                 ),
  //                               )),
  //                   ),
  //                 ],
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text('Cancel'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     checkConnectionFunc(context, () {
  //                       context
  //                           .read<BeforeCompletionImageBloc>()
  //                           .add(const UpdateJobWithBeforeImage());
  //                     });
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text('Submit'),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget imageSelectContainer(BuildContext context) {
  //   return Column(
  //     children: [
  //       GestureDetector(
  //         onTap: () async {
  //           context
  //               .read<CompleteJobBloc>()
  //               .add(const AfterCompletionImageChanged());
  //         },
  //         child: BlocBuilder<CompleteJobBloc, CompleteJobState>(
  //           builder: (context, state) {
  //             return Container(
  //                 decoration: BoxDecoration(
  //                     color: ConstColors.greyColor,
  //                     borderRadius: BorderRadius.all(Radius.circular(7.r))),
  //                 height: 200.h,
  //                 width: double.maxFinite,
  //                 child: state.imageToolFileBytes == null ||
  //                         state.imageToolFileNameFromFilePicker == null
  //                     ? const Center(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Icon(Icons.add_a_photo),
  //                             Text(
  //                               'Upload Image',
  //                               //style: kSmallBlackTextStyle,
  //                             )
  //                           ],
  //                         ),
  //                       )
  //                     : ClipRRect(
  //                         borderRadius: BorderRadius.all(Radius.circular(7.r)),
  //                         child: Image.memory(
  //                           state.imageToolFileBytes!,
  //                           fit: BoxFit.fill,
  //                         ),
  //                       ));
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
