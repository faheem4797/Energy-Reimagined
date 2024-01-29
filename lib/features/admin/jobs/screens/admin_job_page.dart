import 'package:cached_network_image/cached_network_image.dart';
import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/tool_request_bloc/tool_request_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/create_job_bloc/create_job_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/delete_job_bloc/delete_job_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/edit_job_bloc/edit_job_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/jobs_stream_bloc/jobs_stream_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/screens/admin_create_job_page.dart';
import 'package:energy_reimagined/features/admin/jobs/screens/admin_edit_job_page.dart';
import 'package:energy_reimagined/features/admin/jobs/screens/admin_tools_request_page.dart';
import 'package:energy_reimagined/features/admin/users/blocs/users_stream_bloc/users_stream_bloc.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:tools_repository/tools_repository.dart';

class AdminJobPage extends StatelessWidget {
  const AdminJobPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: BlocBuilder<JobsStreamBloc, JobsStreamState>(
            builder: (context, state) {
              return state.status == JobsStreamStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state.status == JobsStreamStatus.failure
                      ? const Center(
                          child: Text("Error Loading Stream"),
                        )
                      : state.filteredJobs == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ConstColors.foregroundColor),
                                          padding: MaterialStateProperty.all<
                                              EdgeInsetsGeometry>(
                                            const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 10),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                create: (context) => CreateJobBloc(
                                                    jobsRepository: context
                                                        .read<JobsRepository>(),
                                                    currentUserStream: context
                                                            .read<
                                                                UsersStreamBloc>()
                                                            .state
                                                            .userStream ??
                                                        []),
                                                child:
                                                    const AdminCreateJobPage(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Create Job",
                                          style: TextStyle(
                                              color: ConstColors.blackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                MultiSelectDropDown(
                                  showClearIcon: true,
                                  onOptionSelected: (options) {
                                    context.read<JobsStreamBloc>().add(
                                        ChangeFilterStatus(
                                            filterStatusList: options));

                                    // debugPrint(options.toString());
                                  },
                                  options: const <ValueItem>[
                                    ValueItem(
                                        label: 'In Progress',
                                        value: JobStatus.workInProgress),
                                    ValueItem(
                                        label: 'On Hold',
                                        value: JobStatus.onHold),
                                    ValueItem(
                                        label: 'Assigned',
                                        value: JobStatus.assigned),
                                    ValueItem(
                                        label: 'Completed',
                                        value: JobStatus.completed),
                                    ValueItem(
                                        label: 'Rejected',
                                        value: JobStatus.rejected),
                                    ValueItem(
                                        label: 'Pending',
                                        value: JobStatus.pending),
                                  ],
                                  selectionType: SelectionType.multi,
                                  chipConfig: const ChipConfig(
                                      wrapType: WrapType.scroll,
                                      backgroundColor:
                                          ConstColors.backgroundDarkColor),
                                  dropdownHeight: 300,
                                  optionTextStyle:
                                      const TextStyle(fontSize: 16),
                                  selectedOptionBackgroundColor:
                                      ConstColors.backgroundDarkColor,
                                  selectedOptionTextColor:
                                      ConstColors.whiteColor,
                                  selectedOptionIcon: const Icon(
                                    Icons.check_circle,
                                    color: ConstColors.whiteColor,
                                  ),
                                  hint: 'Select Filter',
                                ),

                                // _buildFilterChips(),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: state.filteredJobs?.length,
                                    itemBuilder: (context, index) {
                                      final jobs = state.filteredJobs!;
                                      final bool isOnHold =
                                          jobs[index].status ==
                                              JobStatus.onHold;
                                      final bool isRejected =
                                          jobs[index].status ==
                                              JobStatus.rejected;

                                      return Stack(
                                        children: [
                                          Card(
                                              color:
                                                  ConstColors.backgroundColor,
                                              elevation: 4,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              child: ExpansionTile(
                                                  expandedCrossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  title: RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.sp,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              jobs[index].title,
                                                          style:
                                                              const TextStyle(
                                                            color: ConstColors
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: jobs[index]
                                                                      .status ==
                                                                  JobStatus
                                                                      .pending
                                                              ? '  [Pending]'
                                                              : jobs[index]
                                                                          .status ==
                                                                      JobStatus
                                                                          .assigned
                                                                  ? '  [Assigned]'
                                                                  : jobs[index]
                                                                              .status ==
                                                                          JobStatus
                                                                              .completed
                                                                      ? '  [Completed]'
                                                                      : jobs[index].status ==
                                                                              JobStatus.workInProgress
                                                                          ? '  [In Progress]'
                                                                          : jobs[index].status == JobStatus.onHold
                                                                              ? '  [On Hold]'
                                                                              : jobs[index].status == JobStatus.rejected
                                                                                  ? '  [Rejected]'
                                                                                  : '',
                                                          style:
                                                              const TextStyle(
                                                            color: ConstColors
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '  [${jobs[index].flagCounter.toString()}]',
                                                          style:
                                                              const TextStyle(
                                                            color: ConstColors
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    jobs[index].description,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: ConstColors
                                                          .whiteColor,
                                                    ),
                                                  ),
                                                  trailing: Wrap(
                                                    children: [
                                                      //TODO: DELETE COMMENTED FROM HERE
                                                      // IconButton(
                                                      //   icon: const Icon(
                                                      //       Icons.delete),
                                                      //   color: ConstColors
                                                      //       .whiteColor,
                                                      //   onPressed: () {
                                                      //     checkConnectionFunc(
                                                      //         context, () {
                                                      //       context
                                                      //           .read<
                                                      //               DeleteJobBloc>()
                                                      //           .add(
                                                      //             JobDeleteRequested(
                                                      //                 job: jobs[
                                                      //                     index]),
                                                      //           );
                                                      //     });
                                                      //   },
                                                      // ),

                                                      //
                                                      //
                                                      jobs[index]
                                                              .currentToolsRequestQrCode
                                                              .isNotEmpty
                                                          ? IconButton(
                                                              icon: const Icon(
                                                                  Icons.build),
                                                              color: ConstColors
                                                                  .whiteColor,
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (context) => BlocProvider(
                                                                              create: (context) => ToolRequestBloc(
                                                                                toolsRepository: context.read<ToolsRepository>(),
                                                                                jobModel: jobs[index],
                                                                              ),
                                                                              child: AdminToolsRequestPage(
                                                                                jobModel: jobs[index],
                                                                              ),
                                                                            )));
                                                              },
                                                            )
                                                          : const SizedBox(),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.edit),
                                                        color: ConstColors
                                                            .whiteColor,
                                                        onPressed: () {
                                                          final currentUserSteamList = context
                                                                  .read<
                                                                      UsersStreamBloc>()
                                                                  .state
                                                                  .userStream
                                                                  ?.where((user) =>
                                                                      user.role ==
                                                                      'technician')
                                                                  .toList() ??
                                                              [];
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BlocProvider(
                                                                          create: (context) =>
                                                                              EditJobBloc(
                                                                            jobsRepository:
                                                                                context.read<JobsRepository>(),
                                                                            userId:
                                                                                context.read<AuthenticationBloc>().state.userModel!.id,
                                                                            currentUserStream:
                                                                                currentUserSteamList,
                                                                            oldJobModel:
                                                                                JobModel(
                                                                              id: jobs[index].id,
                                                                              title: jobs[index].title,
                                                                              description: jobs[index].description,
                                                                              municipality: jobs[index].municipality,
                                                                              status: jobs[index].status,
                                                                              assignedTechnicianId: jobs[index].assignedTechnicianId,
                                                                              locationName: jobs[index].locationName,
                                                                              locationLatitude: jobs[index].locationLatitude,
                                                                              locationLongitude: jobs[index].locationLongitude,
                                                                              allToolsRequested: jobs[index].allToolsRequested,
                                                                              currentToolsRequestedIds: jobs[index].currentToolsRequestedIds,
                                                                              currentToolsRequestedQuantity: jobs[index].currentToolsRequestedQuantity,
                                                                              currentToolsRequestQrCode: jobs[index].currentToolsRequestQrCode,
                                                                              holdReason: jobs[index].holdReason,
                                                                              cancelReason: jobs[index].cancelReason,
                                                                              rejectedReason: jobs[index].rejectedReason,
                                                                              rejectedTimestamp: jobs[index].rejectedTimestamp,
                                                                              createdTimestamp: jobs[index].createdTimestamp,
                                                                              assignedTimestamp: jobs[index].assignedTimestamp,
                                                                              startedTimestamp: jobs[index].startedTimestamp,
                                                                              holdTimestamp: jobs[index].holdTimestamp,
                                                                              completedTimestamp: jobs[index].completedTimestamp,
                                                                              completeImageUrl: jobs[index].completeImageUrl,
                                                                              flagCounter: jobs[index].flagCounter,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              const AdminEditJobPage(),
                                                                        )),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  children: [
                                                    jobs[index].status ==
                                                            JobStatus.completed
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Completed on: ',
                                                                      style: TextStyle(
                                                                          color: ConstColors
                                                                              .whiteColor,
                                                                          fontSize: 16
                                                                              .sp
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      DateFormat(
                                                                              'dd-MM-yyyy HH:mm')
                                                                          .format(
                                                                              DateTime.fromMicrosecondsSinceEpoch(jobs[index].completedTimestamp)),
                                                                      style:
                                                                          TextStyle(
                                                                        color: ConstColors
                                                                            .whiteColor,
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        20.h),
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              7.r)),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    imageUrl: jobs[
                                                                            index]
                                                                        .completeImageUrl,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        const Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Center(
                                                                            child:
                                                                                Text('Error loading image')),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ])),
                                          if (isOnHold || isRejected)
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 8.h),
                                                child: Banner(
                                                  message: isOnHold
                                                      ? 'On Hold'
                                                      : 'Rejected',
                                                  location:
                                                      BannerLocation.topEnd,
                                                  color: ConstColors.redColor,
                                                  textStyle: const TextStyle(
                                                    color:
                                                        ConstColors.whiteColor,
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
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildFilterChips() {
  //   return SizedBox(
  //     height: 50,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       children: [
  //         _buildFilterChip(JobStatus.pending),
  //         _buildFilterChip(JobStatus.rejected),
  //         _buildFilterChip(JobStatus.onHold),
  //         _buildFilterChip(JobStatus.assigned),
  //         _buildFilterChip(JobStatus.workInProgress),
  //         _buildFilterChip(JobStatus.completed),
  //         _buildFilterChip(JobStatus.cancelled),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFilterChip(JobStatus status) {
  //   return BlocBuilder<JobsStreamBloc, JobsStreamState>(
  //     builder: (context, state) {
  //       return Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 8.w),
  //         child: FilterChip(
  //           label: Text(status == JobStatus.pending
  //               ? 'Pending'
  //               : status == JobStatus.assigned
  //                   ? 'Assigned'
  //                   : status == JobStatus.cancelled
  //                       ? 'Cancelled'
  //                       : status == JobStatus.completed
  //                           ? 'Completed'
  //                           : status == JobStatus.workInProgress
  //                               ? 'In Progress'
  //                               : status == JobStatus.onHold
  //                                   ? 'On Hold'
  //                                   : status == JobStatus.rejected
  //                                       ? 'Rejected'
  //                                       : ''),
  //           selected: state.selectedStatuses.contains(status),
  //           onSelected: (bool selected) {
  //             if (selected) {
  //               context
  //                   .read<JobsStreamBloc>()
  //                   .add(AddFilterStatus(status: status));
  //             } else {
  //               context
  //                   .read<JobsStreamBloc>()
  //                   .add(RemoveFilterStatus(status: status));
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
