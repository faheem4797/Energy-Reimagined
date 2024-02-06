import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/technician/blocs/tools_request_bloc/tools_request_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:tools_repository/tools_repository.dart';

class ManagerJobDetailPage extends StatelessWidget {
  final JobModel job;
  const ManagerJobDetailPage({required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          job.title,
          style: const TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
      ),
      body: Padding(
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
                    job.status == JobStatus.workInProgress
                        ? 'In Progress'
                        : job.status == JobStatus.onHold
                            ? 'On Hold'
                            : job.status == JobStatus.assigned
                                ? 'Assigned'
                                : job.status == JobStatus.completed
                                    ? 'Completed'
                                    : job.status == JobStatus.pending
                                        ? 'Pending'
                                        : job.status == JobStatus.rejected
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
                  // Text(
                  //   jobDetailState.job.description,
                  // ),
                  Container(
                      width: double.infinity,
                      // height: 175.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:
                            SingleChildScrollView(child: Text(job.description)),
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
                      // height: 100.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                            child: Text(job.locationName)),
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
                    job.municipality,
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
              Text(
                'Tools Requested: ',
                style: TextStyle(
                    color: ConstColors.blackColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
              ),
              BlocBuilder<ToolsRequestBloc, ToolsRequestState>(
                builder: (blocContext, state) {
                  return state.status == ToolsRequestStatus.loading ||
                          state.status == ToolsRequestStatus.inProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : state.status == ToolsRequestStatus.loadingFailure
                          ? const Center(
                              child: Text('Error Loading Tools List'),
                            )
                          : state.allRequestedToolsList.isEmpty
                              ? const Text('No Tools Requested')
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.allRequestedToolsList.length,
                                  itemBuilder: (context, index) {
                                    ToolModel tool =
                                        state.allRequestedToolsList[index];

                                    return Card(
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
                                                  color: ConstColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${'  [${tool.category}'}]',
                                                style: const TextStyle(
                                                  color: ConstColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Requested Quantity: ${state.allRequestedToolsQuantityList[index].toString()}',
                                          style: const TextStyle(
                                            color: ConstColors.whiteColor,
                                          ),
                                        ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 8),
                                            child: Text(
                                              tool.description,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                color: ConstColors.whiteColor,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: CachedNetworkImage(
                                                imageUrl: tool.imageUrl),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                },
              ),
              SizedBox(height: 20.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Site Evidence - Before Work',
                    style: TextStyle(
                        color: ConstColors.blackColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  job.beforeCompleteImageUrl.isEmpty
                      ? const Text('No image added yet')
                      : CarouselSlider(
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                          ),
                          items: job.beforeCompleteImageUrl.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: i,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                            child: Text('Error loading image')),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                  SizedBox(height: 20.h),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Site Evidence - After Work',
                    style: TextStyle(
                        color: ConstColors.blackColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  job.afterCompleteImageUrl.isEmpty
                      ? const Text('No image added yet')
                      : CarouselSlider(
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                          ),
                          items: job.afterCompleteImageUrl.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: i,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                            child: Text('Error loading image')),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                  SizedBox(height: 20.h),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Work Description',
                      style: TextStyle(
                          color: ConstColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                      width: double.infinity,
                      // height: 100.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                            child: Text(job.workDoneDescription == ''
                                ? 'Not Added Yet'
                                : job.workDoneDescription)),
                      )),
                ],
              ),

              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
    //);
  }
}
