import 'package:cached_network_image/cached_network_image.dart';
import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/manager/blocs/tools_bloc/tools_bloc.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await WillPopScoopService().showCloseConfirmationDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ToolsBloc, ToolsState>(
          builder: (context, state) {
            return state.status == ToolsStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.status == ToolsStatus.failure
                    ? const Center(
                        child: Text("Error Loading Stream"),
                      )
                    : state.filteredListOfToolRequests == null
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
                                    "Tools List",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // MultiSelectDropDown(
                              //   showClearIcon: true,
                              //   onOptionSelected: (options) {
                              //     context.read<ToolsBloc>().add(
                              //         ChangeFilterStatus(
                              //             filterStatusList: options));
                              //   },
                              //   options: categories.map((String category) {
                              //     return ValueItem(
                              //       value: category,
                              //       label: category,
                              //     );
                              //   }).toList(),
                              //   selectionType: SelectionType.multi,
                              //   chipConfig: const ChipConfig(
                              //       wrapType: WrapType.scroll,
                              //       backgroundColor:
                              //           ConstColors.backgroundDarkColor),
                              //   dropdownHeight: 300,
                              //   optionTextStyle: const TextStyle(fontSize: 16),
                              //   selectedOptionBackgroundColor:
                              //       ConstColors.backgroundDarkColor,
                              //   selectedOptionTextColor: ConstColors.whiteColor,
                              //   selectedOptionIcon: const Icon(
                              //     Icons.check_circle,
                              //     color: ConstColors.whiteColor,
                              //   ),
                              //   hint: 'Select Filter',
                              // ),

                              SizedBox(height: 10.h),

                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.allTools?.length,
                                  itemBuilder: (context, index) {
                                    final tool = state.allTools![index];
                                    final toolRequests = state
                                        .filteredListOfToolRequests!
                                        .where((element) =>
                                            element.toolsRequestedIds.contains(
                                                state.allTools![index].id))
                                        .toList();
                                    print(state.allTools![index].id);
                                    print(toolRequests.length);
                                    var requestedQuantity;
                                    var requestedTimestamp;
                                    var completedTimestamp;
                                    toolRequests.forEach((element) {
                                      final a = (element.toolsRequestedIds
                                          .indexOf(state.allTools![index].id));
                                      requestedQuantity =
                                          element.toolsRequestedQuantity[a];
                                      requestedTimestamp =
                                          element.requestedTimestamp;
                                      completedTimestamp =
                                          element.completedTimestamp;
                                      print(element.toolsRequestedIds);
                                      print(element.toolsRequestedQuantity);
                                    });

                                    // final bool isOnHold =
                                    //     jobs[index].status == JobStatus.onHold;
                                    // final bool isRejected =
                                    //     jobs[index].status ==
                                    //         JobStatus.rejected;

                                    return Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             BlocProvider(
                                            //               create: (context) => ToolsRequestBloc(
                                            //                   toolsRepository:
                                            //                       context.read<
                                            //                           ToolsRepository>(),
                                            //                   jobsRepository:
                                            //                       context.read<
                                            //                           JobsRepository>(),
                                            //                   oldJobModel:
                                            //                       toolRequests[
                                            //                           index],
                                            //                   userId: context
                                            //                       .read<
                                            //                           AuthenticationBloc>()
                                            //                       .state
                                            //                       .userModel!
                                            //                       .id),
                                            //               child: ManagerJobDetailPage(
                                            //                   job: toolRequests[
                                            //                       index]),
                                            //             )));
                                          },
                                          child: Card(
                                            color: ConstColors.backgroundColor,
                                            elevation: 4,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
                                            child: ExpansionTile(
                                              expandedCrossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              leading: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        tool.imageUrl),
                                              ),
                                              title: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: tool.name,
                                                      style: const TextStyle(
                                                        color: ConstColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${'  [${tool.category}'}]',
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
                                                'Available Quantity: ${tool.quantity.toString()}',
                                                style: const TextStyle(
                                                  color: ConstColors.whiteColor,
                                                ),
                                              ),
                                              children: [
                                                Text(
                                                    'Requested Quantity:$requestedQuantity'),
                                                requestedTimestamp == null
                                                    ? Text('')
                                                    : Text(
                                                        'Requested Time:${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.fromMicrosecondsSinceEpoch(requestedTimestamp))}',
                                                      ),
                                                completedTimestamp == null
                                                    ? Text('')
                                                    : Text(
                                                        'Completed Time:${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.fromMicrosecondsSinceEpoch(completedTimestamp))}',
                                                      ),

                                                // Padding(
                                                //   padding: const EdgeInsets
                                                //       .symmetric(
                                                //       horizontal: 16.0,
                                                //       vertical: 8),
                                                //   child: Text(
                                                //     tool.description,
                                                //     textAlign: TextAlign.left,
                                                //     style: const TextStyle(
                                                //       color: ConstColors
                                                //           .whiteColor,
                                                //     ),
                                                //   ),
                                                // ),
                                                // Padding(
                                                //   padding: const EdgeInsets.all(
                                                //       16.0),
                                                //   child: CachedNetworkImage(
                                                //       imageUrl: tool.imageUrl),
                                                // ),

                                                // ListTile(title: toolRequests[],),
                                              ],
                                            ),
                                            // ListTile(
                                            //   // expandedCrossAxisAlignment:
                                            //   //     CrossAxisAlignment.start,
                                            //   shape: RoundedRectangleBorder(
                                            //     borderRadius:
                                            //         BorderRadius.circular(
                                            //             10.0),
                                            //   ),
                                            //   title: RichText(
                                            //     text: TextSpan(
                                            //       style: TextStyle(
                                            //         color: Colors.white,
                                            //         fontSize: 18.sp,
                                            //       ),
                                            //       children: [
                                            //         TextSpan(
                                            //           text:
                                            //               toolRequests[index]
                                            //                   .id,
                                            //           style: const TextStyle(
                                            //             color: ConstColors
                                            //                 .whiteColor,
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //           ),
                                            //         ),
                                            //         // TextSpan(
                                            //         //   text: toolRequests[
                                            //         //                   index]
                                            //         //               .status ==
                                            //         //           JobStatus
                                            //         //               .pending
                                            //         //       ? '  [Pending]'
                                            //         //       : toolRequests[index]
                                            //         //                   .status ==
                                            //         //               JobStatus
                                            //         //                   .assigned
                                            //         //           ? '  [Assigned]'
                                            //         //           : toolRequests[index]
                                            //         //                       .status ==
                                            //         //                   JobStatus
                                            //         //                       .completed
                                            //         //               ? '  [Completed]'
                                            //         //               : toolRequests[index].status ==
                                            //         //                       JobStatus
                                            //         //                           .workInProgress
                                            //         //                   ? '  [In Progress]'
                                            //         //                   : toolRequests[index].status ==
                                            //         //                           JobStatus.onHold
                                            //         //                       ? '  [On Hold]'
                                            //         //                       : toolRequests[index].status == JobStatus.rejected
                                            //         //                           ? '  [Rejected]'
                                            //         //                           : '',
                                            //         //   style: const TextStyle(
                                            //         //     color: ConstColors
                                            //         //         .whiteColor,
                                            //         //     fontWeight:
                                            //         //         FontWeight.bold,
                                            //         //   ),
                                            //         // ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            //   subtitle: Text(
                                            //     toolRequests[index]
                                            //         .toolsRequestedIds
                                            //         .toString(),
                                            //     maxLines: 2,
                                            //     overflow:
                                            //         TextOverflow.ellipsis,
                                            //     style: const TextStyle(
                                            //       color:
                                            //           ConstColors.whiteColor,
                                            //     ),
                                            //   ),
                                            //   // children: [
                                            //   // jobs[index].status ==
                                            //   //         JobStatus.completed
                                            //   //     ? Padding(
                                            //   //         padding:
                                            //   //             const EdgeInsets
                                            //   //                 .symmetric(
                                            //   //                 horizontal:
                                            //   //                     16.0),
                                            //   //         child: Column(
                                            //   //           children: [
                                            //   //             Row(
                                            //   //               mainAxisAlignment:
                                            //   //                   MainAxisAlignment
                                            //   //                       .start,
                                            //   //               children: [
                                            //   //                 Text(
                                            //   //                   'Completed on: ',
                                            //   //                   style: TextStyle(
                                            //   //                       color: ConstColors
                                            //   //                           .whiteColor,
                                            //   //                       fontSize: 16
                                            //   //                           .sp
                                            //   //                           .sp,
                                            //   //                       fontWeight:
                                            //   //                           FontWeight.bold),
                                            //   //                 ),
                                            //   //                 Text(
                                            //   //                   DateFormat(
                                            //   //                           'dd-MM-yyyy HH:mm')
                                            //   //                       .format(
                                            //   //                           DateTime.fromMicrosecondsSinceEpoch(jobs[index].completedTimestamp)),
                                            //   //                   style:
                                            //   //                       TextStyle(
                                            //   //                     color: ConstColors
                                            //   //                         .whiteColor,
                                            //   //                     fontSize:
                                            //   //                         16.sp,
                                            //   //                   ),
                                            //   //                 ),
                                            //   //               ],
                                            //   //             ),
                                            //   //             SizedBox(
                                            //   //                 height: 20.h),
                                            //   //             ClipRRect(
                                            //   //               borderRadius: BorderRadius
                                            //   //                   .all(Radius
                                            //   //                       .circular(
                                            //   //                           7.r)),
                                            //   //               child:
                                            //   //                   CarouselSlider(
                                            //   //                 options:
                                            //   //                     CarouselOptions(
                                            //   //                   enableInfiniteScroll:
                                            //   //                       false,
                                            //   //                 ),
                                            //   //                 items: jobs[
                                            //   //                         index]
                                            //   //                     .afterCompleteImageUrl
                                            //   //                     .map((i) {
                                            //   //                   return Builder(
                                            //   //                     builder:
                                            //   //                         (BuildContext
                                            //   //                             context) {
                                            //   //                       return Container(
                                            //   //                         width: MediaQuery.of(context)
                                            //   //                             .size
                                            //   //                             .width,
                                            //   //                         margin:
                                            //   //                             EdgeInsets.symmetric(horizontal: 5.w),
                                            //   //                         child:
                                            //   //                             CachedNetworkImage(
                                            //   //                           fit:
                                            //   //                               BoxFit.fill,
                                            //   //                           imageUrl:
                                            //   //                               i,
                                            //   //                           placeholder: (context, url) =>
                                            //   //                               const Center(child: CircularProgressIndicator()),
                                            //   //                           errorWidget: (context, url, error) =>
                                            //   //                               const Center(child: Text('Error loading image')),
                                            //   //                         ),
                                            //   //                       );
                                            //   //                     },
                                            //   //                   );
                                            //   //                 }).toList(),
                                            //   //               ),
                                            //   //             ),
                                            //   //           ],
                                            //   //         ),
                                            //   //       )
                                            //   //     : const SizedBox()
                                            //   // ]
                                            // )),
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
                                        )
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
}
