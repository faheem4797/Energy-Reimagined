import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/create_job_bloc/create_job_bloc.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class AdminCreateJobPage extends StatelessWidget {
  const AdminCreateJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
        centerTitle: true,
        title: const Text(
          'Create Job',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: BlocListener<CreateJobBloc, CreateJobState>(
        listener: (BuildContext context, state) {
          if (state.status == CreateJobStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to Create Job'),
                ),
              );
          }
          if (state.status == CreateJobStatus.success) {
            Navigator.of(context).pop();
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BlocBuilder<CreateJobBloc, CreateJobState>(
                    buildWhen: (previous, current) =>
                        previous.job.title != current.job.title,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Title",
                          onChange: (title) {
                            context
                                .read<CreateJobBloc>()
                                .add(TitleChanged(title: title));
                          },
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CreateJobBloc, CreateJobState>(
                    buildWhen: (previous, current) =>
                        previous.job.locationName != current.job.locationName,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Location",
                          onChange: (location) {
                            context
                                .read<CreateJobBloc>()
                                .add(LocationChanged(locationName: location));
                          },
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Municipality: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ConstColors.blackColor,
                        ),
                      ),
                      BlocBuilder<CreateJobBloc, CreateJobState>(
                        buildWhen: (previous, current) =>
                            previous.job.municipality !=
                            current.job.municipality,
                        builder: (context, state) {
                          return DropdownButton<String>(
                            value: state.job.municipality,
                            onChanged: (municipality) {
                              municipality != null
                                  ? context.read<CreateJobBloc>().add(
                                      MunicipalityChanged(
                                          municipality: municipality))
                                  : null;
                            },
                            items: municipalities.map((String municipality) {
                              return DropdownMenuItem<String>(
                                value: municipality,
                                child: Text(municipality),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CreateJobBloc, CreateJobState>(
                    buildWhen: (previous, current) =>
                        previous.job.description != current.job.description,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Description",
                          onChange: (description) {
                            context.read<CreateJobBloc>().add(
                                DescriptionChanged(description: description));
                          },
                          maxLines: 3,
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    ' Assigned Technician',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 4.0),
                  MultiSelectDropDown(
                    showClearIcon: false,
                    // selectedOptions: [
                    //   ValueItem(
                    //       label:
                    //           '${oldTechnicianUserModel.firstName} ${oldTechnicianUserModel.lastName} [${oldTechnicianUserModel.employeeNumber}]',
                    //       value: oldTechnicianUserModel)
                    // ],
                    onOptionRemoved: (index, option) {},
                    onOptionSelected: (options) {
                      if (options.isNotEmpty) {
                        context.read<CreateJobBloc>().add(TechnicianSelected(
                            technician: options.first.value!));
                      }
                    },
                    options: List.generate(
                        context.read<CreateJobBloc>().currentUserStream.length,
                        (index) => ValueItem(
                            label:
                                '${context.read<CreateJobBloc>().currentUserStream[index].firstName} ${context.read<CreateJobBloc>().currentUserStream[index].lastName} [${context.read<CreateJobBloc>().currentUserStream[index].employeeNumber}]',
                            value: context
                                .read<CreateJobBloc>()
                                .currentUserStream[index])),
                    selectionType: SelectionType.single,
                    searchEnabled: true,
                    chipConfig: const ChipConfig(
                        wrapType: WrapType.scroll,
                        backgroundColor: ConstColors.backgroundDarkColor),
                    dropdownHeight: 300,
                    optionTextStyle: const TextStyle(fontSize: 16),
                    selectedOptionBackgroundColor:
                        ConstColors.backgroundDarkColor,
                    selectedOptionTextColor: ConstColors.whiteColor,
                    selectedOptionIcon: const Icon(
                      Icons.check_circle,
                      color: ConstColors.whiteColor,
                    ),
                    hint: 'Select Technician',
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: BlocBuilder<CreateJobBloc, CreateJobState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                state.status == CreateJobStatus.inProgress
                                    ? MaterialStateProperty.all<Color>(
                                        ConstColors.greyColor)
                                    : MaterialStateProperty.all<Color>(
                                        ConstColors.foregroundColor),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: state.status == CreateJobStatus.inProgress
                              ? null
                              : () {
                                  checkConnectionFunc(context, () {
                                    context
                                        .read<CreateJobBloc>()
                                        .add(CreateJobWithDataModel());
                                  });
                                },
                          child: state.status == CreateJobStatus.inProgress
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: ConstColors.backgroundLightColor,
                                  ),
                                )
                              : const Text(
                                  "Create Job",
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
      ),
    );
  }
}
