import 'package:authentication_repository/authentication_repository.dart';
import 'package:energy_reimagined/features/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:energy_reimagined/features/authentication/blocs/sign_up_bloc/sign_up_bloc.dart'
    as sign_up_bloc;
import 'package:energy_reimagined/features/authentication/screens/signup_screen.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<SignInBloc, SignInState>(
          listener: (BuildContext context, state) {
            if (state.status == SignInStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content:
                        Text(state.errorMessage ?? 'Authentication Failure'),
                  ),
                );
            }
          },
          child: Container(
            //color: kDarkPinkColor,
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        'Welcome friends and family',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80.w),
                        child: Image.asset(
                          'assets/9.png',
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          BlocBuilder<SignInBloc, SignInState>(
                            buildWhen: (previous, current) =>
                                previous.email != current.email,
                            builder: (context, state) {
                              return SizedBox(
                                width: 250.w,
                                child: CustomTextFormField(
                                  // key: const Key(
                                  //     'signUpForm_emailInput_textField'),
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
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          BlocBuilder<SignInBloc, SignInState>(
                            buildWhen: (previous, current) =>
                                previous.password != current.password,
                            builder: (context, state) {
                              return SizedBox(
                                width: 250.w,
                                child: CustomTextFormField(
                                  onChange: (password) {
                                    context.read<SignInBloc>().add(
                                        PasswordChanged(password: password));
                                  },
                                  obscureText: true,
                                  textInputType: TextInputType.name,
                                  errorText: state.displayError,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 35.h),
                      loginButton(
                        () async {
                          context
                              .read<SignInBloc>()
                              .add(SignInWithEmailAndPassword());
                          // final isValid = _formKey.currentState?.validate();
                          // FocusScope.of(context).requestFocus(FocusNode());

                          // if (isValid == true) {
                          //   _formKey.currentState?.save();
                          //   // setState(() {
                          //   //   isLoading = true;
                          //   // });
                          //   final message = await AuthService().login(
                          //     email: _emailController.text,
                          //     password: _passwordController.text,
                          //   );
                          //   if (message!.contains('Success')) {
                          //     // setState(() {
                          //     //   isLoading = false;
                          //     // });
                          //     if (!mounted) return;
                          //     Navigator.of(context).pushReplacement(
                          //         MaterialPageRoute(
                          //             builder: (context) => const Welcome(),
                          //             settings: const RouteSettings(
                          //                 name: "/welcome")));
                          //   }
                          //   // setState(() {
                          //   //   isLoading = false;
                          //   // });
                          //   if (!mounted) return;
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text(message),
                          //     ),
                          //   );
                          // }
                        },
                        'Login',
                      ),
                      SizedBox(height: 15.h),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(
                                      //color: kWhiteColor,
                                      fontSize: 16)),
                              TextSpan(
                                  style: const TextStyle(
                                      //color: kBlueColor,
                                      fontSize: 18),
                                  text: 'Register',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                    create: (context) =>
                                                        sign_up_bloc.SignUpBloc(
                                                      authenticationRepository:
                                                          context.read<
                                                              AuthenticationRepository>(),
                                                    ),
                                                    child: const SignupScreen(),
                                                  )));
                                    }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
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
