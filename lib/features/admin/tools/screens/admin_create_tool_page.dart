import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/admin/tools/blocs/create_tool_bloc/create_tool_bloc.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminCreateToolPage extends StatelessWidget {
  const AdminCreateToolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
        centerTitle: true,
        title: const Text(
          'Create Tool',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: BlocListener<CreateToolBloc, CreateToolState>(
        listener: (BuildContext context, state) {
          if (state.status == CreateToolStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to Create Tool'),
                ),
              );
          }
          if (state.status == CreateToolStatus.success) {
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
                  imageSelectContainer(context),
                  BlocBuilder<CreateToolBloc, CreateToolState>(
                    buildWhen: (previous, current) =>
                        previous.tool.name != current.tool.name,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Name",
                          onChange: (name) {
                            context
                                .read<CreateToolBloc>()
                                .add(NameChanged(name: name));
                          },
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CreateToolBloc, CreateToolState>(
                    buildWhen: (previous, current) =>
                        previous.tool.description != current.tool.description,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Description",
                          onChange: (description) {
                            context.read<CreateToolBloc>().add(
                                DescriptionChanged(description: description));
                          },
                          maxLines: 3,
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CreateToolBloc, CreateToolState>(
                    buildWhen: (previous, current) =>
                        previous.tool.category != current.tool.category,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Category",
                          onChange: (category) {
                            context
                                .read<CreateToolBloc>()
                                .add(CategoryChanged(category: category));
                          },
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CreateToolBloc, CreateToolState>(
                    buildWhen: (previous, current) =>
                        previous.tool.quantity != current.tool.quantity,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Quantity",
                          onChange: (quantity) {
                            context
                                .read<CreateToolBloc>()
                                .add(QuantityChanged(quantity: quantity));
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          textInputType: TextInputType.number,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: BlocBuilder<CreateToolBloc, CreateToolState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                state.status == CreateToolStatus.inProgress
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
                          onPressed: state.status == CreateToolStatus.inProgress
                              ? null
                              : () {
                                  checkConnectionFunc(context, () {
                                    context
                                        .read<CreateToolBloc>()
                                        .add(CreateToolWithDataModel());
                                  });
                                },
                          child: state.status == CreateToolStatus.inProgress
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: ConstColors.backgroundLightColor,
                                  ),
                                )
                              : const Text(
                                  "Create Tool",
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

  Widget imageSelectContainer(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            context.read<CreateToolBloc>().add(const ImageChanged());
          },
          child: BlocBuilder<CreateToolBloc, CreateToolState>(
            builder: (context, state) {
              return Container(
                  decoration: BoxDecoration(
                      color: ConstColors.greyColor,
                      borderRadius: BorderRadius.all(Radius.circular(7.r))),
                  height: 200.h,
                  width: double.maxFinite,
                  child: state.imageToolFileBytes == null ||
                          state.imageToolFileNameFromFilePicker == null
                      ? const Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo),
                              Text(
                                'Upload Tool Image',
                                //style: kSmallBlackTextStyle,
                              )
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(7.r)),
                          child: Image.memory(
                            state.imageToolFileBytes!,
                            fit: BoxFit.fill,
                          ),
                        ));
            },
          ),
        ),
        BlocBuilder<CreateToolBloc, CreateToolState>(
            buildWhen: (previous, current) =>
                (previous.imageToolFileBytes != current.imageToolFileBytes) &&
                (previous.imageToolFileNameFromFilePicker !=
                    current.imageToolFileNameFromFilePicker) &&
                (previous.imageToolFilePathFromFilePicker !=
                    current.imageToolFilePathFromFilePicker),
            builder: (context, state) {
              return Text(
                state.displayError ?? '',
                style: const TextStyle(color: ConstColors.redColor),
              );
            })
      ],
    );
  }
}
