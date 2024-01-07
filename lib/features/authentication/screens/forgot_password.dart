import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/authentication/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: ConstColors.whiteColor),
          centerTitle: true,
          title: const Text(
            "Forget Password",
            style: TextStyle(
              color: ConstColors.whiteColor,
            ),
          ),
          backgroundColor: ConstColors.backgroundDarkColor,
        ),
        body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (BuildContext context, state) {
            if (state.status == ForgotPasswordStatus.success) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(
                        'Recovery password email has been sent. Please check your mail.'),
                  ),
                );
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(context);
              });
            } else if (state.status == ForgotPasswordStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Error Sending Email'),
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
                    const Text(
                      'Reset Your Password',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Don't worry! It happens to the best of us. Enter your email address below, and we'll send you a link to reset your password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:
                          BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                        buildWhen: (previous, current) =>
                            previous.email != current.email,
                        builder: (context, state) {
                          return SizedBox(
                            child: CustomTextFormField(
                              labelText: "Email",
                              onChange: (email) {
                                context
                                    .read<ForgotPasswordBloc>()
                                    .add(EmailChanged(email: email));
                              },
                              textInputType: TextInputType.emailAddress,
                              errorText: state.displayError,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child:
                          BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap:
                                state.status == ForgotPasswordStatus.inProgress
                                    ? null
                                    : () {
                                        checkConnectionFunc(context, () {
                                          context
                                              .read<ForgotPasswordBloc>()
                                              .add(ForgotPassword());
                                        });
                                      },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              decoration: BoxDecoration(
                                color: state.status ==
                                        ForgotPasswordStatus.inProgress
                                    ? ConstColors.greyColor
                                    : ConstColors.foregroundColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[200]!,
                                    spreadRadius: 10,
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: state.status ==
                                      ForgotPasswordStatus.inProgress
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        color: ConstColors.blackColor,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
