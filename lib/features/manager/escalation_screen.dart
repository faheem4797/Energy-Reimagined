import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/manager/blocs/escalations_bloc/escalations_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class EscalationsScreen extends StatelessWidget {
  const EscalationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO SHOW A LIST OF JOBS THAT HAVE BEEN ESCALATED
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<EscalationsBloc, EscalationsState>(
        builder: (blocContext, state) {
          return state.status == EscalationsStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.status == EscalationsStatus.failure
                  ? const Center(
                      child: Text("Error Loading Stream"),
                    )
                  : state.filteredEscalations == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Escalations List",
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
                                context.read<EscalationsBloc>().add(
                                    ChangeFilterStatus(
                                        filterStatusList: options));

                                // debugPrint(options.toString());
                              },
                              options: const <ValueItem>[
                                ValueItem(
                                    label: 'In Progress',
                                    value: JobStatus.workInProgress),
                                ValueItem(
                                    label: 'On Hold', value: JobStatus.onHold),
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
                                    label: 'Pending', value: JobStatus.pending),
                              ],
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
                            // _buildFilterChips(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.filteredEscalations?.length,
                                itemBuilder: (context, index) {
                                  final jobs = state.filteredEscalations!;
                                  final bool isOnHold =
                                      jobs[index].status == JobStatus.onHold;
                                  final bool isRejected =
                                      jobs[index].status == JobStatus.rejected;

                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Navigator.of(context)
                                          //     .push(MaterialPageRoute(
                                          //         builder:
                                          //             (context) =>
                                          //                 MultiBlocProvider(
                                          //                   providers: [
                                          //                     BlocProvider(
                                          //                         create: (context) => RejectJobBloc(
                                          //                             jobsRepository: context.read<
                                          //                                 JobsRepository>(),
                                          //                             oldJobModel: jobs[
                                          //                                 index],
                                          //                             userId: context
                                          //                                 .read<AuthenticationBloc>()
                                          //                                 .state
                                          //                                 .userModel!
                                          //                                 .id)),
                                          //                     BlocProvider(
                                          //                         create: (context) => AcceptJobBloc(
                                          //                             jobsRepository: context.read<
                                          //                                 JobsRepository>(),
                                          //                             oldJobModel: jobs[
                                          //                                 index],
                                          //                             userId: context
                                          //                                 .read<AuthenticationBloc>()
                                          //                                 .state
                                          //                                 .userModel!
                                          //                                 .id)),
                                          //                     BlocProvider(
                                          //                         create: (context) => CompleteJobBloc(
                                          //                             jobsRepository: context.read<
                                          //                                 JobsRepository>(),
                                          //                             userId: context
                                          //                                 .read<AuthenticationBloc>()
                                          //                                 .state
                                          //                                 .userModel!
                                          //                                 .id)),

                                          //                     BlocProvider(
                                          //                         create: (context) => AddAfterImageBloc(
                                          //                             jobsRepository: context.read<
                                          //                                 JobsRepository>(),
                                          //                             userId: context
                                          //                                 .read<AuthenticationBloc>()
                                          //                                 .state
                                          //                                 .userModel!
                                          //                                 .id)),
                                          //                     BlocProvider(
                                          //                         create: (context) => AddBeforeImageBloc(
                                          //                             jobsRepository: context.read<
                                          //                                 JobsRepository>(),
                                          //                             userId: context
                                          //                                 .read<AuthenticationBloc>()
                                          //                                 .state
                                          //                                 .userModel!
                                          //                                 .id)),
                                          //                     BlocProvider(
                                          //                         create: (context) => AddWorkDescriptionBloc(
                                          //                             jobsRepository: context.read<
                                          //                                 JobsRepository>(),
                                          //                             userId: context
                                          //                                 .read<AuthenticationBloc>()
                                          //                                 .state
                                          //                                 .userModel!
                                          //                                 .id)),

                                          //                     BlocProvider(
                                          //                       create: (context) => ToolsRequestBloc(
                                          //                           toolsRepository:
                                          //                               context.read<
                                          //                                   ToolsRepository>(),
                                          //                           jobsRepository:
                                          //                               context.read<
                                          //                                   JobsRepository>(),
                                          //                           oldJobModel:
                                          //                               jobs[
                                          //                                   index],
                                          //                           userId: context
                                          //                               .read<AuthenticationBloc>()
                                          //                               .state
                                          //                               .userModel!
                                          //                               .id),
                                          //                     ),
                                          //                     BlocProvider(
                                          //                       create: (context) =>
                                          //                           JobDetailBloc(
                                          //                         jobsRepository:
                                          //                             context
                                          //                                 .read<JobsRepository>(),
                                          //                         jobId: jobs[
                                          //                                 index]
                                          //                             .id,
                                          //                       ),
                                          //                     ),
                                          //                     BlocProvider
                                          //                         .value(
                                          //                       value: blocContext
                                          //                           .read<
                                          //                               TechnicianJobsStreamBloc>(),
                                          //                     ),

                                          //                     //
                                          //                     //
                                          //                   ],
                                          //                   child: TechnicianJobDetailPage(
                                          //                       job: jobs[
                                          //                           index]),
                                          //                 )));
                                        },
                                        child: Card(
                                            color: ConstColors.backgroundColor,
                                            elevation: 4,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
                                            child: ListTile(
                                              title: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                    color:
                                                        ConstColors.whiteColor,
                                                    fontSize: 16,
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
                                                              JobStatus.pending
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
                                                                  : jobs[index]
                                                                              .status ==
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
                                                    )
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
                                            )),
                                      ),
                                      if (isOnHold || isRejected)
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 8.h),
                                            child: Banner(
                                              message: isOnHold
                                                  ? 'On Hold'
                                                  : 'Rejected',
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
                        );
        },
      ),
    );
  }
}
