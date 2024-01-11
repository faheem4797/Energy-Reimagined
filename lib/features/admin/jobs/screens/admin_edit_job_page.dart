import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/edit_job_bloc/edit_job_bloc.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_repository/jobs_repository.dart';

class AdminEditJobPage extends StatelessWidget {
  const AdminEditJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
        centerTitle: true,
        title: const Text(
          'Edit Job',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: BlocListener<EditJobBloc, EditJobState>(
        listener: (BuildContext context, state) {
          if (state.status == EditJobStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to Edit'),
                ),
              );
          }
          if (state.status == EditJobStatus.success) {
            Navigator.of(context).pop();
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //TODO:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Cancelled: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ConstColors.blackColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      BlocBuilder<EditJobBloc, EditJobState>(
                        buildWhen: (previous, current) =>
                            previous.job.status != current.job.status,
                        builder: (context, state) {
                          return Switch(
                            value: state.job.status == JobStatus.cancelled,
                            onChanged: (isCancelled) async {
                              context
                                  .read<EditJobBloc>()
                                  .add(StatusChanged(isCancelled: isCancelled));
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  BlocBuilder<EditJobBloc, EditJobState>(
                    buildWhen: (previous, current) =>
                        previous.job.title != current.job.title,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Title",
                          initialValue: state.job.title,
                          onChange: (title) {
                            context
                                .read<EditJobBloc>()
                                .add(TitleChanged(title: title));
                          },
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<EditJobBloc, EditJobState>(
                    buildWhen: (previous, current) =>
                        previous.job.locationName != current.job.locationName,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Location",
                          initialValue: state.job.locationName,
                          onChange: (location) {
                            context
                                .read<EditJobBloc>()
                                .add(LocationChanged(locationName: location));
                          },
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<EditJobBloc, EditJobState>(
                    buildWhen: (previous, current) =>
                        previous.job.description != current.job.description,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Description",
                          initialValue: state.job.description,
                          onChange: (description) {
                            context.read<EditJobBloc>().add(
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

                  Center(
                    child: BlocBuilder<EditJobBloc, EditJobState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                state.status == EditJobStatus.inProgress
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
                          onPressed: state.status == EditJobStatus.inProgress
                              ? null
                              : () {
                                  checkConnectionFunc(context, () {
                                    context
                                        .read<EditJobBloc>()
                                        .add(EditJobWithUpdatedJobModel());
                                  });
                                },
                          child: state.status == EditJobStatus.inProgress
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: ConstColors.backgroundLightColor,
                                  ),
                                )
                              : const Text(
                                  "Edit Job",
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
