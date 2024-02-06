import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/features/manager/blocs/reports_bloc/reports_bloc.dart';
import 'package:energy_reimagined/features/manager/manager_job_detail_page.dart';
import 'package:energy_reimagined/features/technician/blocs/tools_request_bloc/tools_request_bloc.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:tools_repository/tools_repository.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await WillPopScoopService().showCloseConfirmationDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            return state.status == ReportsStreamStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.status == ReportsStreamStatus.failure
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
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Jobs List",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              MultiSelectDropDown(
                                showClearIcon: true,
                                onOptionSelected: (options) {
                                  context.read<ReportsBloc>().add(
                                      ChangeFilterStatus(
                                          filterStatusList: options));
                                },
                                options: categories.map((String category) {
                                  return ValueItem(
                                    value: category,
                                    label: category,
                                  );
                                }).toList(),
                                selectionType: SelectionType.multi,
                                chipConfig: const ChipConfig(
                                    wrapType: WrapType.scroll,
                                    backgroundColor:
                                        ConstColors.backgroundDarkColor),
                                dropdownHeight: 300,
                                optionTextStyle: const TextStyle(fontSize: 16),
                                selectedOptionBackgroundColor:
                                    ConstColors.backgroundDarkColor,
                                selectedOptionTextColor: ConstColors.whiteColor,
                                selectedOptionIcon: const Icon(
                                  Icons.check_circle,
                                  color: ConstColors.whiteColor,
                                ),
                                hint: 'Select Filter',
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  statusCard(
                                      state, 'On Hold', JobStatus.onHold),
                                  statusCard(
                                      state, 'Rejected', JobStatus.rejected),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  statusCard(
                                      state, 'Completed', JobStatus.completed),
                                  statusCard(state, 'In Progress',
                                      JobStatus.workInProgress),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.filteredJobs?.length,
                                  itemBuilder: (context, index) {
                                    final jobs = state.filteredJobs!;
                                    // final bool isOnHold =
                                    //     jobs[index].status == JobStatus.onHold;
                                    // final bool isRejected =
                                    //     jobs[index].status ==
                                    //         JobStatus.rejected;

                                    return Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BlocProvider(
                                                          create: (context) => ToolsRequestBloc(
                                                              toolsRepository:
                                                                  context.read<
                                                                      ToolsRepository>(),
                                                              jobsRepository:
                                                                  context.read<
                                                                      JobsRepository>(),
                                                              oldJobModel:
                                                                  jobs[index],
                                                              userId: context
                                                                  .read<
                                                                      AuthenticationBloc>()
                                                                  .state
                                                                  .userModel!
                                                                  .id),
                                                          child:
                                                              ManagerJobDetailPage(
                                                                  job: jobs[
                                                                      index]),
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
                                                // expandedCrossAxisAlignment:
                                                //     CrossAxisAlignment.start,
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
                                                        text: jobs[index].title,
                                                        style: const TextStyle(
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
                                                                            JobStatus
                                                                                .workInProgress
                                                                        ? '  [In Progress]'
                                                                        : jobs[index].status ==
                                                                                JobStatus.onHold
                                                                            ? '  [On Hold]'
                                                                            : jobs[index].status == JobStatus.rejected
                                                                                ? '  [Rejected]'
                                                                                : '',
                                                        style: const TextStyle(
                                                          color: ConstColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '  [${jobs[index].flagCounter.toString()}]',
                                                        style: const TextStyle(
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
                                                    color:
                                                        ConstColors.whiteColor,
                                                  ),
                                                ),
                                                // children: [
                                                // jobs[index].status ==
                                                //         JobStatus.completed
                                                //     ? Padding(
                                                //         padding:
                                                //             const EdgeInsets
                                                //                 .symmetric(
                                                //                 horizontal:
                                                //                     16.0),
                                                //         child: Column(
                                                //           children: [
                                                //             Row(
                                                //               mainAxisAlignment:
                                                //                   MainAxisAlignment
                                                //                       .start,
                                                //               children: [
                                                //                 Text(
                                                //                   'Completed on: ',
                                                //                   style: TextStyle(
                                                //                       color: ConstColors
                                                //                           .whiteColor,
                                                //                       fontSize: 16
                                                //                           .sp
                                                //                           .sp,
                                                //                       fontWeight:
                                                //                           FontWeight.bold),
                                                //                 ),
                                                //                 Text(
                                                //                   DateFormat(
                                                //                           'dd-MM-yyyy HH:mm')
                                                //                       .format(
                                                //                           DateTime.fromMicrosecondsSinceEpoch(jobs[index].completedTimestamp)),
                                                //                   style:
                                                //                       TextStyle(
                                                //                     color: ConstColors
                                                //                         .whiteColor,
                                                //                     fontSize:
                                                //                         16.sp,
                                                //                   ),
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //             SizedBox(
                                                //                 height: 20.h),
                                                //             ClipRRect(
                                                //               borderRadius: BorderRadius
                                                //                   .all(Radius
                                                //                       .circular(
                                                //                           7.r)),
                                                //               child:
                                                //                   CarouselSlider(
                                                //                 options:
                                                //                     CarouselOptions(
                                                //                   enableInfiniteScroll:
                                                //                       false,
                                                //                 ),
                                                //                 items: jobs[
                                                //                         index]
                                                //                     .afterCompleteImageUrl
                                                //                     .map((i) {
                                                //                   return Builder(
                                                //                     builder:
                                                //                         (BuildContext
                                                //                             context) {
                                                //                       return Container(
                                                //                         width: MediaQuery.of(context)
                                                //                             .size
                                                //                             .width,
                                                //                         margin:
                                                //                             EdgeInsets.symmetric(horizontal: 5.w),
                                                //                         child:
                                                //                             CachedNetworkImage(
                                                //                           fit:
                                                //                               BoxFit.fill,
                                                //                           imageUrl:
                                                //                               i,
                                                //                           placeholder: (context, url) =>
                                                //                               const Center(child: CircularProgressIndicator()),
                                                //                           errorWidget: (context, url, error) =>
                                                //                               const Center(child: Text('Error loading image')),
                                                //                         ),
                                                //                       );
                                                //                     },
                                                //                   );
                                                //                 }).toList(),
                                                //               ),
                                                //             ),
                                                //           ],
                                                //         ),
                                                //       )
                                                //     : const SizedBox()
                                                // ]
                                              )),
                                        ),
                                        // if (isOnHold || isRejected)
                                        //   Positioned(
                                        //     top: 0,
                                        //     left: 0,
                                        //     right: 0,
                                        //     child: Container(
                                        //       padding: EdgeInsets.symmetric(
                                        //           horizontal: 8.w,
                                        //           vertical: 8.h),
                                        //       child: Banner(
                                        //         message: isOnHold
                                        //             ? 'On Hold'
                                        //             : 'Rejected',
                                        //         location: BannerLocation.topEnd,
                                        //         color: ConstColors.redColor,
                                        //         textStyle: const TextStyle(
                                        //           color: ConstColors.whiteColor,
                                        //           fontSize: 12,
                                        //           fontWeight: FontWeight.bold,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
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
    );
  }

  SizedBox statusCard(ReportsState state, String label, JobStatus status) {
    return SizedBox(
      height: 80.h,
      width: 140.w,
      child: Card(
        color: ConstColors.backgroundLightColor,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ConstColors.whiteColor,
                ),
              ),
              Text(
                state.filteredJobs
                        ?.where((job) => job.status == status)
                        .length
                        .toString() ??
                    '',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ConstColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
