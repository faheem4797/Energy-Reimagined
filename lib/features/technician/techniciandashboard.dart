import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/technician_jobs_stream_bloc/technician_jobs_stream_bloc.dart';
import 'package:energy_reimagined/features/technician/technician_job_detail_page.dart';
import 'package:energy_reimagined/features/technician/technician_qrcode_page.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_repository/jobs_repository.dart';

class TechnicianDashboard extends StatelessWidget {
  const TechnicianDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Technician Dashboard',
            style: TextStyle(
              color: ConstColors.whiteColor,
            ),
          ),
          backgroundColor: ConstColors.backgroundDarkColor,
          iconTheme: const IconThemeData(
            color: ConstColors.whiteColor,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: ConstColors.whiteColor,
              ),
              onPressed: () async {
                var logout = await WillPopScoopService()
                    .showLogoutConfirmationDialog(context);
                if (logout) {
                  if (!context.mounted) return;
                  checkConnectionFunc(context, () {
                    context
                        .read<AuthenticationBloc>()
                        .add(const AuthenticationLogoutRequested());
                  });
                }
              },
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            return await WillPopScoopService()
                .showCloseConfirmationDialog(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<TechnicianJobsStreamBloc,
                TechnicianJobsStreamState>(
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
                                  _buildFilterChips(),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: state.filteredJobs?.length,
                                      itemBuilder: (context, index) {
                                        final jobs = state.filteredJobs!;
                                        final bool isOnHold =
                                            jobs[index].status ==
                                                JobStatus.onHold;
                                        final bool isCancelled =
                                            jobs[index].status ==
                                                JobStatus.cancelled;

                                        return Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TechnicianJobDetailPage(
                                                              jobModel:
                                                                  jobs[index],
                                                            )));
                                              },
                                              child: Card(
                                                  color: ConstColors
                                                      .backgroundColor,
                                                  elevation: 4,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                                  child: ListTile(
                                                      title: RichText(
                                                        text: TextSpan(
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
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
                                                                              JobStatus.cancelled
                                                                          ? '  [Cancelled]'
                                                                          : jobs[index].status == JobStatus.completed
                                                                              ? '  [Completed]'
                                                                              : jobs[index].status == JobStatus.workInProgress
                                                                                  ? '  [In Progress]'
                                                                                  : jobs[index].status == JobStatus.onHold
                                                                                      ? '  [On Hold]'
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
                                                          ],
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        jobs[index].description,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                                //TODO: TAPPING ON THIS OPENS A NEW PAGE WITH QR CODE DISPLAYING ON SCREEN
                                                                //TODO: WHEN ADMIN SCANS THIS QR CODE THEN IT SHOULD COMPLETE THE TOOL TRANSACTION and pop the screen
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (context) => TechnicianQRCodePage(
                                                                              qrCodeText: jobs[index].currentToolsRequestQrCode,
                                                                            )));
                                                              },
                                                            )
                                                          : null)),
                                            ),
                                            if (isOnHold || isCancelled)
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
                                                        : 'Cancelled',
                                                    location:
                                                        BannerLocation.topEnd,
                                                    color: ConstColors.redColor,
                                                    textStyle: const TextStyle(
                                                      color: ConstColors
                                                          .whiteColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
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
        ));
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(JobStatus.workInProgress),
          _buildFilterChip(JobStatus.onHold),
          _buildFilterChip(JobStatus.assigned),
          _buildFilterChip(JobStatus.completed),
          _buildFilterChip(JobStatus.cancelled),
          _buildFilterChip(JobStatus.pending),
        ],
      ),
    );
  }

  Widget _buildFilterChip(JobStatus status) {
    return BlocBuilder<TechnicianJobsStreamBloc, TechnicianJobsStreamState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: FilterChip(
            label: Text(status == JobStatus.workInProgress
                ? 'In Progress'
                : status == JobStatus.onHold
                    ? 'On Hold'
                    : status == JobStatus.assigned
                        ? 'Assigned'
                        : status == JobStatus.cancelled
                            ? 'Cancelled'
                            : status == JobStatus.completed
                                ? 'Completed'
                                : status == JobStatus.pending
                                    ? 'Pending'
                                    : ''),
            selected: state.selectedStatuses.contains(status),
            onSelected: (bool selected) {
              if (selected) {
                context
                    .read<TechnicianJobsStreamBloc>()
                    .add(AddFilterStatus(status: status));
              } else {
                context
                    .read<TechnicianJobsStreamBloc>()
                    .add(RemoveFilterStatus(status: status));
              }
            },
          ),
        );
      },
    );
  }
}
