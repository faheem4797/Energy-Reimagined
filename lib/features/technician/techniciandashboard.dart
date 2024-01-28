import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/complete_job_bloc/complete_job_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/reject_job_bloc/reject_job_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/technician_jobs_stream_bloc/technician_jobs_stream_bloc.dart';
import 'package:energy_reimagined/features/technician/technician_job_detail_page.dart';
import 'package:energy_reimagined/features/technician/technician_qrcode_page.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class TechnicianDashboard extends StatelessWidget {
  const TechnicianDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return await WillPopScoopService()
              .showCloseConfirmationDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              BlocBuilder<TechnicianJobsStreamBloc, TechnicianJobsStreamState>(
            builder: (blocContext, state) {
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
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Jobs List",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                MultiSelectDropDown(
                                  showClearIcon: true,
                                  onOptionSelected: (options) {
                                    context
                                        .read<TechnicianJobsStreamBloc>()
                                        .add(ChangeFilterStatus(
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
                                        label: 'Cancelled',
                                        value: JobStatus.cancelled),
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
                                      final bool isCancelled =
                                          jobs[index].status ==
                                              JobStatus.cancelled;

                                      return Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              MultiBlocProvider(
                                                                providers: [
                                                                  BlocProvider(
                                                                      create: (context) => RejectJobBloc(
                                                                          jobsRepository: context.read<
                                                                              JobsRepository>(),
                                                                          oldJobModel: jobs[
                                                                              index],
                                                                          userId: context
                                                                              .read<AuthenticationBloc>()
                                                                              .state
                                                                              .userModel!
                                                                              .id)),
                                                                  BlocProvider(
                                                                      create: (context) => CompleteJobBloc(
                                                                          jobsRepository: context.read<
                                                                              JobsRepository>(),
                                                                          jobModel: jobs[
                                                                              index],
                                                                          userId: context
                                                                              .read<AuthenticationBloc>()
                                                                              .state
                                                                              .userModel!
                                                                              .id))
                                                                ],
                                                                child:
                                                                    TechnicianJobDetailPage(
                                                                  jobModel: jobs[
                                                                      index],
                                                                ),
                                                              )));
                                            },
                                            child: Card(
                                                color:
                                                    ConstColors.backgroundColor,
                                                elevation: 4,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                child: ListTile(
                                                    title: RichText(
                                                      text: TextSpan(
                                                        style: const TextStyle(
                                                          color: ConstColors
                                                              .whiteColor,
                                                          fontSize: 16,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: jobs[index]
                                                                .title,
                                                            style:
                                                                const TextStyle(
                                                              color: ConstColors
                                                                  .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                                    : jobs[index].status ==
                                                                            JobStatus
                                                                                .cancelled
                                                                        ? '  [Cancelled]'
                                                                        : jobs[index].status ==
                                                                                JobStatus.completed
                                                                            ? '  [Completed]'
                                                                            : jobs[index].status == JobStatus.workInProgress
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
                                                                  FontWeight
                                                                      .bold,
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
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
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
                                                    trailing: jobs[index]
                                                            .currentToolsRequestQrCode
                                                            .isNotEmpty
                                                        ? IconButton(
                                                            icon: const Icon(Icons
                                                                .qr_code_scanner),
                                                            color: ConstColors
                                                                .whiteColor,
                                                            onPressed: () {
                                                              Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          BlocProvider
                                                                              .value(
                                                                            value:
                                                                                blocContext.read<TechnicianJobsStreamBloc>(),
                                                                            child:
                                                                                TechnicianQRCodePage(
                                                                              jobModel: jobs[index],
                                                                            ),
                                                                          )));
                                                            },
                                                          )
                                                        : null)),
                                          ),
                                          if (isOnHold ||
                                              isCancelled ||
                                              isRejected)
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
                                                      : isCancelled
                                                          ? 'Cancelled'
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
        ));
  }

  // Widget _buildFilterChips() {
  //   return SizedBox(
  //     height: 150,
  //     child: Wrap(
  //       // direction: Axis.vertical,
  //       // scrollDirection: Axis.horizontal,
  //       children: [
  //         _buildFilterChip(JobStatus.workInProgress),
  //         _buildFilterChip(JobStatus.onHold),
  //         _buildFilterChip(JobStatus.assigned),
  //         _buildFilterChip(JobStatus.completed),
  //         _buildFilterChip(JobStatus.cancelled),
  //         _buildFilterChip(JobStatus.rejected),
  //         _buildFilterChip(JobStatus.pending),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFilterChip(JobStatus status) {
  //   return BlocBuilder<TechnicianJobsStreamBloc, TechnicianJobsStreamState>(
  //     builder: (context, state) {
  //       return Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 8.w),
  //         child: FilterChip(
  //           label: Text(status == JobStatus.workInProgress
  //               ? 'In Progress'
  //               : status == JobStatus.onHold
  //                   ? 'On Hold'
  //                   : status == JobStatus.assigned
  //                       ? 'Assigned'
  //                       : status == JobStatus.cancelled
  //                           ? 'Cancelled'
  //                           : status == JobStatus.completed
  //                               ? 'Completed'
  //                               : status == JobStatus.pending
  //                                   ? 'Pending'
  //                                   : status == JobStatus.rejected
  //                                       ? 'Rejected'
  //                                       : ''),
  //           selected: state.selectedStatuses.contains(status),
  //           onSelected: (bool selected) {
  //             if (selected) {
  //               context
  //                   .read<TechnicianJobsStreamBloc>()
  //                   .add(AddFilterStatus(status: status));
  //             } else {
  //               context
  //                   .read<TechnicianJobsStreamBloc>()
  //                   .add(RemoveFilterStatus(status: status));
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
