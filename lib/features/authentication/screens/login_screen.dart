import 'package:authentication_repository/authentication_repository.dart';
import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/authentication/blocs/forgot_password_bloc/forgot_password_bloc.dart'
    as forgot_password_bloc;
import 'package:energy_reimagined/features/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';

import 'package:energy_reimagined/features/authentication/screens/forgot_password.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: ConstColors.whiteColor,
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
                                      builder: (context) => BlocProvider(
                                            create: (context) => forgot_password_bloc
                                                .ForgotPasswordBloc(
                                                    authenticationRepository:
                                                        context.read<
                                                            AuthenticationRepository>()),
                                            child: const ForgotPasswordScreen(),
                                          )));
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
                        context.read<SignInBloc>().add(SendSupportEmail());
                        //_sendEmail();
                      },
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                              text:
                                  "If you have any complaints or suggestions?\nContact us at ",
                              style: TextStyle(
                                color: ConstColors.blackColor,
                                fontWeight: FontWeight.w200,
                                fontSize: 16.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'sample@gmail.com',
                                  style: TextStyle(
                                    color: ConstColors.blackColor,
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
