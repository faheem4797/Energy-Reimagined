import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/admin/users/blocs/create_user_bloc/create_user_bloc.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCreateUserPage extends StatelessWidget {
  const AdminCreateUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
        centerTitle: true,
        title: const Text(
          'Create User',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: BlocListener<CreateUserBloc, CreateUserState>(
        listener: (BuildContext context, state) {
          if (state.status == CreateUserStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to Create User'),
                ),
              );
          }
          if (state.status == CreateUserStatus.success) {
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<CreateUserBloc, CreateUserState>(
                  buildWhen: (previous, current) =>
                      previous.user.firstName != current.user.firstName,
                  builder: (context, state) {
                    return SizedBox(
                      child: CustomTextFormField(
                        labelText: "First Name",
                        onChange: (firstName) {
                          context
                              .read<CreateUserBloc>()
                              .add(FirstNameChanged(firstName: firstName));
                        },
                        textInputType: TextInputType.name,
                        errorText: state.displayError,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<CreateUserBloc, CreateUserState>(
                  buildWhen: (previous, current) =>
                      previous.user.lastName != current.user.lastName,
                  builder: (context, state) {
                    return SizedBox(
                      child: CustomTextFormField(
                        labelText: "Last Name",
                        onChange: (lastName) {
                          context
                              .read<CreateUserBloc>()
                              .add(LastNameChanged(lastName: lastName));
                        },
                        textInputType: TextInputType.name,
                        errorText: state.displayError,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<CreateUserBloc, CreateUserState>(
                  buildWhen: (previous, current) =>
                      previous.user.employeeNumber !=
                      current.user.employeeNumber,
                  builder: (context, state) {
                    return SizedBox(
                      child: CustomTextFormField(
                        labelText: "Employee Number",
                        onChange: (employeeNumber) {
                          context.read<CreateUserBloc>().add(
                              EmployeeNumberChanged(
                                  employeeNumber: employeeNumber));
                        },
                        textInputType: TextInputType.name,
                        errorText: state.displayError,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<CreateUserBloc, CreateUserState>(
                  buildWhen: (previous, current) =>
                      previous.user.email != current.user.email,
                  builder: (context, state) {
                    return SizedBox(
                      child: CustomTextFormField(
                        labelText: "Email",
                        onChange: (email) {
                          context
                              .read<CreateUserBloc>()
                              .add(EmailChanged(email: email));
                        },
                        textInputType: TextInputType.emailAddress,
                        errorText: state.displayError,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<CreateUserBloc, CreateUserState>(
                  buildWhen: (previous, current) =>
                      previous.password != current.password,
                  builder: (context, state) {
                    return SizedBox(
                      child: CustomTextFormField(
                        labelText: "Password",
                        onChange: (password) {
                          context
                              .read<CreateUserBloc>()
                              .add(PasswordChanged(password: password));
                        },
                        textInputType: TextInputType.name,
                        errorText: state.displayError,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text('Role',
                      style: TextStyle(
                        color: ConstColors.blackColor,
                      )),
                  subtitle: BlocBuilder<CreateUserBloc, CreateUserState>(
                    builder: (context, state) {
                      return Column(
                        children: <Widget>[
                          RadioListTile<String>(
                            title: const Text(
                              'Admin',
                            ),
                            value: 'admin',
                            groupValue: state.user.role,
                            onChanged: (role) {
                              role != null
                                  ? context
                                      .read<CreateUserBloc>()
                                      .add(RoleChanged(role: role))
                                  : null;
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text(
                              'Technician',
                            ),
                            value: 'technician',
                            groupValue: state.user.role,
                            onChanged: (role) {
                              role != null
                                  ? context
                                      .read<CreateUserBloc>()
                                      .add(RoleChanged(role: role))
                                  : null;
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text(
                              'Manager',
                            ),
                            value: 'manager',
                            groupValue: state.user.role,
                            onChanged: (role) {
                              role != null
                                  ? context
                                      .read<CreateUserBloc>()
                                      .add(RoleChanged(role: role))
                                  : null;
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: BlocBuilder<CreateUserBloc, CreateUserState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              state.status == CreateUserStatus.inProgress
                                  ? MaterialStateProperty.all<Color>(
                                      ConstColors.greyColor)
                                  : MaterialStateProperty.all<Color>(
                                      ConstColors.foregroundColor),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: state.status == CreateUserStatus.inProgress
                            ? null
                            : () {
                                checkConnectionFunc(context, () {
                                  context
                                      .read<CreateUserBloc>()
                                      .add(CreateUserWithEmailAndPassword());
                                });
                              },
                        child: state.status == CreateUserStatus.inProgress
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ConstColors.backgroundLightColor,
                                ),
                              )
                            : const Text(
                                "Create User",
                                style: TextStyle(
                                  color: ConstColors.whiteColor,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
