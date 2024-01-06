import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/admin/blocs/edit_user_bloc/edit_user_bloc.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminEditUserPage extends StatelessWidget {
  const AdminEditUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
        centerTitle: true,
        title: const Text(
          'Edit User',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: BlocListener<EditUserBloc, EditUserState>(
        listener: (BuildContext context, state) {
          if (state.status == EditUserStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to Edit'),
                ),
              );
          }
          if (state.status == EditUserStatus.success) {
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<EditUserBloc, EditUserState>(
                  buildWhen: (previous, current) =>
                      previous.user.isRestricted != current.user.isRestricted,
                  builder: (context, state) {
                    return Switch(
                      value: state.user.isRestricted,
                      onChanged: (isRestricted) async {
                        context.read<EditUserBloc>().add(
                            RestrictionChanged(isRestricted: isRestricted));
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),

                BlocBuilder<EditUserBloc, EditUserState>(
                  buildWhen: (previous, current) =>
                      previous.user.firstName != current.user.firstName,
                  builder: (context, state) {
                    return SizedBox(
                      child: CustomTextFormField(
                        initialValue: state.user.firstName,
                        labelText: "First Name",
                        onChange: (firstName) {
                          context
                              .read<EditUserBloc>()
                              .add(FirstNameChanged(firstName: firstName));
                        },
                        textInputType: TextInputType.name,
                        errorText: state.displayError,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: TextFormField(
                //     controller: _firstNameController,
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return "Enter the first name";
                //       }
                //       return null;
                //     },
                //     //autofocus: true,
                //     textInputAction: TextInputAction.next,
                //     keyboardType: TextInputType.text,
                //     decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         focusedBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: Colors.black54, width: 2.0),
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: Colors.black38, width: 2.0),
                //         ),
                //         labelText: "First Name",
                //         labelStyle: TextStyle(
                //           color: Colors.black,
                //           fontFamily: 'Poppins',
                //         )),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                BlocBuilder<EditUserBloc, EditUserState>(
                  buildWhen: (previous, current) =>
                      previous.user.lastName != current.user.lastName,
                  builder: (context, state) {
                    return SizedBox(
                      child: CustomTextFormField(
                        labelText: "Last Name",
                        initialValue: state.user.lastName,
                        onChange: (lastName) {
                          context
                              .read<EditUserBloc>()
                              .add(LastNameChanged(lastName: lastName));
                        },
                        textInputType: TextInputType.name,
                        errorText: state.displayError,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: TextFormField(
                //     controller: _lastNameController,
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return "Enter the last name";
                //       }
                //       return null;
                //     },
                //     //autofocus: true,
                //     textInputAction: TextInputAction.next,
                //     keyboardType: TextInputType.text,
                //     decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         focusedBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: Colors.black54, width: 2.0),
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: Colors.black38, width: 2.0),
                //         ),
                //         labelText: "Last Name",
                //         labelStyle: TextStyle(
                //           color: Colors.black,
                //           fontFamily: 'Poppins',
                //         )),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                BlocBuilder<EditUserBloc, EditUserState>(
                  buildWhen: (previous, current) =>
                      previous.user.employeeNumber !=
                      current.user.employeeNumber,
                  builder: (context, state) {
                    return SizedBox(
                      child: CustomTextFormField(
                        initialValue: state.user.employeeNumber,
                        labelText: "Employee Number",
                        onChange: (employeeNumber) {
                          context.read<EditUserBloc>().add(
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
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: TextFormField(
                //     controller: _employeeNumberController,
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return "Enter the employee number";
                //       }
                //       return null;
                //     },
                //     //autofocus: true,
                //     textInputAction: TextInputAction.next,
                //     keyboardType: TextInputType.text,
                //     decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         focusedBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: Colors.black54, width: 2.0),
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: Colors.black38, width: 2.0),
                //         ),
                //         labelText: "Employee Number",
                //         labelStyle: TextStyle(
                //           color: Colors.black,
                //           fontFamily: 'Poppins',
                //         )),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),

                ListTile(
                  title: const Text('Role',
                      style: TextStyle(
                        color: ConstColors.blackColor,
                      )),
                  subtitle: BlocBuilder<EditUserBloc, EditUserState>(
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
                                      .read<EditUserBloc>()
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
                                      .read<EditUserBloc>()
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
                                      .read<EditUserBloc>()
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
                  child: BlocBuilder<EditUserBloc, EditUserState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              state.status == EditUserStatus.inProgress
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
                        onPressed: state.status == EditUserStatus.inProgress
                            ? null
                            : () {
                                context
                                    .read<EditUserBloc>()
                                    .add(EditUserWithUpdatedUserModel());
                              },
                        child: state.status == EditUserStatus.inProgress
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ConstColors.backgroundLightColor,
                                ),
                              )
                            : const Text(
                                "Edit User",
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
