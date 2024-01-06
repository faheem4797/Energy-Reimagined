// import 'package:energy_reimagined/features/authentication/blocs/sign_up_bloc/sign_up_bloc.dart';
// import 'package:energy_reimagined/widgets/custom_textfield.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocListener<CreateUserBloc, CreateUserState>(
//         listener: (BuildContext context, state) {
//           if (state.status == CreateUserStatus.failure) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: Text(state.errorMessage ?? 'Authentication Failure'),
//                 ),
//               );
//           }
//           if (state.status == CreateUserStatus.success) {
//             Navigator.of(context).pop();
//           }
//         },
//         child: Container(
//           //color: kDarkPinkColor,
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 // mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 20.h),
//                   Text(
//                     'Welcome friends and family',
//                     textAlign: TextAlign.center,
//                     //style: kFriendsAndFamilyTextStyle,
//                   ),
//                   SizedBox(height: 20.h),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 80.w),
//                     child: Image.asset(
//                       'assets/9.png',
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 20.w),
//                         child: Text(
//                           'First Name',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 24.sp,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                       BlocBuilder<CreateUserBloc, CreateUserState>(
//                         buildWhen: (previous, current) =>
//                             previous.user.firstName != current.user.firstName,
//                         builder: (context, state) {
//                           return SizedBox(
//                             width: 250.w,
//                             child: CustomTextFormField(
//                               onChange: (firstName) {
//                                 context.read<CreateUserBloc>().add(
//                                     FirstNameChanged(firstName: firstName));
//                               },
//                               textInputType: TextInputType.name,
//                               errorText: state.displayError,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 20.w),
//                         child: Text(
//                           'Email',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 24.sp,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                       BlocBuilder<CreateUserBloc, CreateUserState>(
//                         buildWhen: (previous, current) =>
//                             previous.user.email != current.user.email,
//                         builder: (context, state) {
//                           return SizedBox(
//                             width: 250.w,
//                             child: CustomTextFormField(
//                               // key: const Key(
//                               //     'signUpForm_emailInput_textField'),
//                               onChange: (email) {
//                                 context
//                                     .read<CreateUserBloc>()
//                                     .add(EmailChanged(email: email));
//                               },
//                               textInputType: TextInputType.emailAddress,

//                               errorText: state.displayError,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 20.w),
//                         child: Text(
//                           'Password',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 24.sp,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                       BlocBuilder<CreateUserBloc, CreateUserState>(
//                         buildWhen: (previous, current) =>
//                             previous.password != current.password,
//                         builder: (context, state) {
//                           return SizedBox(
//                             width: 250.w,
//                             child: CustomTextFormField(
//                               onChange: (password) {
//                                 context
//                                     .read<CreateUserBloc>()
//                                     .add(PasswordChanged(password: password));
//                               },
//                               obscureText: true,
//                               textInputType: TextInputType.name,
//                               errorText: state.displayError,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 35.h),
//                   signupButton(
//                     () async {
//                       context
//                           .read<CreateUserBloc>()
//                           .add(CreateUserWithEmailAndPassword());
//                     },
//                     'Register',
//                   ),
//                   SizedBox(height: 15.h),
//                   Center(
//                     child: RichText(
//                       text: TextSpan(
//                         children: <TextSpan>[
//                           const TextSpan(
//                               text: 'Already have an account? ',
//                               style: TextStyle(
//                                   //color: kWhiteColor,
//                                   fontSize: 16)),
//                           TextSpan(
//                               style: const TextStyle(
//                                   //color: kBlueColor,
//                                   fontSize: 18),
//                               text: 'Login',
//                               recognizer: TapGestureRecognizer()
//                                 ..onTap = () {
//                                   Navigator.of(context).pop();
//                                 }),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   signupButton(VoidCallback onPress, String buttonText) {
//     return SizedBox(
//       height: 60.h,
//       width: 165.w,
//       child: BlocBuilder<CreateUserBloc, CreateUserState>(
//         builder: (context, state) {
//           return ElevatedButton(
//             onPressed:
//                 state.status == CreateUserStatus.inProgress ? null : onPress,
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               //backgroundColor: kLightPinkColor,
//             ),
//             child: state.status == CreateUserStatus.inProgress
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                         //color: kWhiteColor,
//                         ),
//                   )
//                 : Text(
//                     buttonText,
//                     style: TextStyle(
//                       fontSize: 32.sp,
//                       fontWeight: FontWeight.w900,
//                       //color: kWhiteColor
//                     ),
//                   ),
//           );
//         },
//       ),
//     );
//   }
// }
