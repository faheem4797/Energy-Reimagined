import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';

import 'package:energy_reimagined/features/authentication/screens/forgot_password.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _sendEmail() {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto', path: 'support@gmail.com', query: 'subject=Re: app');
    launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: BlocListener<SignInBloc, SignInState>(
        listener: (BuildContext context, state) {
          if (state.status == SignInStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication Failure'),
                ),
              );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png'),
                  const SizedBox(
                    height: 30,
                  ),
                  BlocBuilder<SignInBloc, SignInState>(
                    buildWhen: (previous, current) =>
                        previous.email != current.email,
                    builder: (context, state) {
                      return SizedBox(
                        //width: MediaQuery.of(context).size.width,
                        child: CustomTextFormField(
                          labelText: "Email",
                          onChange: (email) {
                            context
                                .read<SignInBloc>()
                                .add(EmailChanged(email: email));
                          },
                          textInputType: TextInputType.emailAddress,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  BlocBuilder<SignInBloc, SignInState>(
                    buildWhen: (previous, current) =>
                        previous.password != current.password,
                    builder: (context, state) {
                      return SizedBox(
                        //width: 250.w,
                        child: CustomTextFormField(
                          onChange: (password) {
                            context
                                .read<SignInBloc>()
                                .add(PasswordChanged(password: password));
                          },
                          labelText: "Password",
                          obscureText: true,
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child: const Text("Forgot Password ?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16.0,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  loginButton(
                    () async {
                      context
                          .read<SignInBloc>()
                          .add(SignInWithEmailAndPassword());
                    },
                    'Login',
                  ),
                  SizedBox(height: 30.h),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _sendEmail();
                      },
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                              text:
                                  "If you have any complaints or suggestions?\nContact us at ",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w200,
                                fontSize: 16.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'sample@gmail.com',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                )
                              ])),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginButton(VoidCallback onPress, String buttonText) {
    return SizedBox(
      height: 60.h,
      width: 165.w,
      child: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.status == SignInStatus.inProgress ? null : onPress,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              //backgroundColor: kLightPinkColor,
            ),
            child: state.status == SignInStatus.inProgress
                ? const Center(
                    child: CircularProgressIndicator(
                        //color: kWhiteColor,
                        ),
                  )
                : Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      //color: kWhiteColor,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

// class SignIn extends StatefulWidget {
//   const SignIn({super.key});

//   @override
//   State<SignIn> createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   // void _sendEmail() {
//   //   final Uri emailLaunchUri = Uri(
//   //       scheme: 'mailto', path: 'support@gmail.com', query: 'subject=Re: app');
//   //   launchUrl(emailLaunchUri);
//   // }

//   // Assume this function is triggered on a login attempt
//   void attemptLogin(BuildContext context) async {
//     var connectivityResult = await Connectivity().checkConnectivity();

//     if (connectivityResult == ConnectivityResult.none) {
//       // No internet, show dialog
//       showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (_) => NetworkErrorDialog(
//           onPressed: () async {
//             // Check connectivity again
//             connectivityResult = await Connectivity().checkConnectivity();
//             if (connectivityResult == ConnectivityResult.none) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Please turn on your wifi or mobile data'),
//                 ),
//               );
//             } else {
//               // Internet available, close dialog and proceed with login
//               Navigator.pop(context);
//               // Call your login function here if internet is available
//               performLogin();
//             }
//           },
//         ),
//       );
//     } else {
//       // Internet available, proceed with login
//       performLogin();
//     }
//   }

//   void performLogin() {
//     // Replace these values with form values
//     String email = _email.text.toString(); //"admin@energy.com";
//     String password = _password.text.toString(); //"energy1234";
//     AuthenticationService.signIn(email, password, context);
//     // Your login logic here
//     // This function should be called when the user successfully connects to the internet
//     // and you want to proceed with the login process
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text(
//             'Sign In',
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'Poppins',
//             ),
//           ),
//           backgroundColor: ConstColors.backgroundDarkColor,
//         ),
//         body: isLoading == false
//             ? WillPopScope(
//                 onWillPop: () async {
//                   return await WillPopScoopService()
//                       .showCloseConfirmationDialog(context);
//                 },
//                 child: Center(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset('assets/images/logo.png'),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: TextFormField(
//                               controller: _email,
//                               validator: (value) {
//                                 if (value!.isEmpty || !value.contains('@')) {
//                                   return "Enter a valid email";
//                                 }
//                                 return null;
//                               },
//                               //autofocus: true,
//                               textInputAction: TextInputAction.next,
//                               focusNode: _emailFocus,
//                               onFieldSubmitted: (term) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_passwordFocus);
//                               },
//                               keyboardType: TextInputType.emailAddress,
//                               decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.black54, width: 2.0),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.black38, width: 2.0),
//                                   ),
//                                   labelText: "Email",
//                                   labelStyle: TextStyle(
//                                     color: Colors.black,
//                                     fontFamily: 'Poppins',
//                                   )),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: TextFormField(
//                               controller: _password,
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return "Password must not be empty";
//                                 }
//                                 return null;
//                               },
//                               textInputAction: TextInputAction.done,
//                               focusNode: _passwordFocus,
//                               obscureText: _obscureText,
//                               //autofocus: true,
//                               // inputFormatters: [
//                               //   LengthLimitingTextInputFormatter(8),
//                               // ],
//                               keyboardType: TextInputType.text,
//                               decoration: InputDecoration(
//                                   suffixIcon: IconButton(
//                                     icon: Icon(_obscureText
//                                         ? Icons.visibility_off
//                                         : Icons.visibility),
//                                     onPressed: () {
//                                       _toggle();
//                                     },
//                                   ),
//                                   border: const OutlineInputBorder(),
//                                   focusedBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.black54, width: 2.0),
//                                   ),
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.black38, width: 2.0),
//                                   ),
//                                   labelText: "Password",
//                                   labelStyle: const TextStyle(
//                                     color: Colors.black,
//                                     fontFamily: 'Poppins',
//                                   )),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 MouseRegion(
//                                   cursor: SystemMouseCursors.click,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const ForgetPassword()));
//                                     },
//                                     child: const Text("Forgot Password ?",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w200,
//                                           fontSize: 16.0,
//                                         )),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               if (_signinformKey.currentState!.validate()) {
//                                 attemptLogin(context);
//                               }
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 30, vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: ConstColors.foregroundColor,
//                                 borderRadius: BorderRadius.circular(15),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey[200]!,
//                                     spreadRadius: 10,
//                                     blurRadius: 12,
//                                   ),
//                                 ],
//                               ),
//                               child: const Text(
//                                 'Sign In',
//                                 style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 20,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           MouseRegion(
//                             cursor: SystemMouseCursors.click,
//                             child: GestureDetector(
//                               onTap: () {
//                                 _sendEmail();
//                                 // Navigator.push(
//                                 //     context,
//                                 //     MaterialPageRoute(
//                                 //         builder: (context) => const SignUp()));
//                               },
//                               child: RichText(
//                                   textAlign: TextAlign.center,
//                                   text: const TextSpan(
//                                       text:
//                                           "If you have any complaints or suggestions?\nContact us at ",
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w200,
//                                         fontSize: 16.0,
//                                       ),
//                                       children: <TextSpan>[
//                                         TextSpan(
//                                           text: 'sample@gmail.com',
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontFamily: 'Poppins',
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 16.0,
//                                           ),
//                                         )
//                                       ])),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             : const Center(
//                 child: CircularProgressIndicator(),
//               ));
//   }
// }
