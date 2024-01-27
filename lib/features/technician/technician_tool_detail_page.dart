// import 'package:energy_reimagined/constants/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tools_repository/tools_repository.dart';

// class TechnicianToolDetailPage extends StatelessWidget {
//   final ToolModel toolModel;
//   const TechnicianToolDetailPage({required this.toolModel, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           toolModel.name,
//           style: const TextStyle(
//             color: ConstColors.whiteColor,
//           ),
//         ),
//         backgroundColor: ConstColors.backgroundDarkColor,
//         iconTheme: const IconThemeData(
//           color: ConstColors.whiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               SizedBox(
//                 height: 20.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Current Status: ',
//                     style: TextStyle(
//                         color: ConstColors.blackColor,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     '',
//                     style: TextStyle(
//                       color: ConstColors.blackColor,
//                       fontSize: 16.sp,
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Tool Description',
//                       style: TextStyle(
//                           color: ConstColors.blackColor,
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   Container(
//                       width: double.infinity,
//                       height: 175.h,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: SingleChildScrollView(
//                             child: Text('jobModel.description')),
//                       )),
//                 ],
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Location',
//                       style: TextStyle(
//                           color: ConstColors.blackColor,
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   Container(
//                       width: double.infinity,
//                       height: 100.h,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: SingleChildScrollView(
//                             child: Text('jobModel.locationName')),
//                       )),
//                 ],
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Municipality: ',
//                     style: TextStyle(
//                         color: ConstColors.blackColor,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     ' jobModel.municipality',
//                     style: TextStyle(
//                       color: ConstColors.blackColor,
//                       fontSize: 16.sp,
//                     ),
//                   ),
//                 ],
//               ),
//               // SizedBox(
//               //   height: 20.h,
//               // ),
//               // ElevatedButton(
//               //   style: ButtonStyle(
//               //     backgroundColor: MaterialStateProperty.all<Color>(
//               //         ConstColors.foregroundColor),
//               //     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//               //       const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               //     ),
//               //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//               //       RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(8.0),
//               //       ),
//               //     ),
//               //   ),
//               //   onPressed: () {
//               //     Navigator.push(
//               //       context,
//               //       MaterialPageRoute(
//               //         builder: (context) => BlocProvider(
//               //           create: (context) => ToolsRequestBloc(
//               //               toolsRepository: context.read<ToolsRepository>(),
//               //               jobsRepository: context.read<JobsRepository>(),
//               //               oldJobModel: jobModel,
//               //               userId: context
//               //                   .read<AuthenticationBloc>()
//               //                   .state
//               //                   .userModel!
//               //                   .id),
//               //           child: const TechnicianRequestToolsPage(),
//               //         ),
//               //       ),
//               //     );
//               //   },
//               //   //TODO: CHANGE TO ACCEPT JOB AND THEN PROCEED TO TOOLS SELECT
//               //   child: const Text(
//               //     "Request Tools",
//               //     style: TextStyle(color: ConstColors.blackColor),
//               //   ),
//               // ),

//               SizedBox(
//                 height: 40.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           ConstColors.foregroundColor),
//                       padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                         const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 10),
//                       ),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                     ),
//                     onPressed: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => BlocProvider(
//                       //       create: (context) => ToolsRequestBloc(
//                       //           toolsRepository:
//                       //               context.read<ToolsRepository>(),
//                       //           jobsRepository: context.read<JobsRepository>(),
//                       //           oldJobModel: jobModel,
//                       //           userId: context
//                       //               .read<AuthenticationBloc>()
//                       //               .state
//                       //               .userModel!
//                       //               .id),
//                       //       child: const TechnicianRequestToolsPage(),
//                       //     ),
//                       //   ),
//                       // );
//                     },
//                     child: const Text(
//                       "Accept Job",
//                       style: TextStyle(color: ConstColors.blackColor),
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.red),
//                       padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                         const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 10),
//                       ),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                     ),
//                     onPressed: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => BlocProvider(
//                       //       create: (context) => ToolsRequestBloc(
//                       //           toolsRepository: context.read<ToolsRepository>(),
//                       //           jobsRepository: context.read<JobsRepository>(),
//                       //           oldJobModel: jobModel,
//                       //           userId: context
//                       //               .read<AuthenticationBloc>()
//                       //               .state
//                       //               .userModel!
//                       //               .id),
//                       //       child: const TechnicianRequestToolsPage(),
//                       //     ),
//                       //   ),
//                       // );
//                     },
//                     child: const Text(
//                       "Reject Job",
//                       style: TextStyle(color: ConstColors.whiteColor),
//                     ),
//                   ),
//                 ],
//               ),
//               // SizedBox(
//               //   height: 20.h,
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
