import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/admin/tools/blocs/edit_tool_bloc/edit_tool_bloc.dart';
import 'package:energy_reimagined/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminEditToolPage extends StatelessWidget {
  const AdminEditToolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
        centerTitle: true,
        title: const Text(
          'Edit Tool',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: BlocListener<EditToolBloc, EditToolState>(
        listener: (BuildContext context, state) {
          if (state.status == EditToolStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to Edit'),
                ),
              );
          }
          if (state.status == EditToolStatus.success) {
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
                  BlocBuilder<EditToolBloc, EditToolState>(
                    buildWhen: (previous, current) =>
                        previous.tool.name != current.tool.name,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          initialValue: state.tool.name,
                          labelText: "Name",
                          onChange: (name) {
                            context
                                .read<EditToolBloc>()
                                .add(NameChanged(name: name));
                          },
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<EditToolBloc, EditToolState>(
                    buildWhen: (previous, current) =>
                        previous.tool.category != current.tool.category,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          labelText: "Category",
                          initialValue: state.tool.category,
                          onChange: (category) {
                            context
                                .read<EditToolBloc>()
                                .add(CategoryChanged(category: category));
                          },
                          textInputType: TextInputType.name,
                          errorText: state.displayError,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<EditToolBloc, EditToolState>(
                    buildWhen: (previous, current) =>
                        previous.tool.quantity != current.tool.quantity,
                    builder: (context, state) {
                      return SizedBox(
                        child: CustomTextFormField(
                          initialValue: state.tool.quantity.toString(),
                          labelText: "Quantity",
                          onChange: (quantity) {
                            context
                                .read<EditToolBloc>()
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
                  const SizedBox(height: 10),
                  Center(
                    child: BlocBuilder<EditToolBloc, EditToolState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                state.status == EditToolStatus.inProgress
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
                          onPressed: state.status == EditToolStatus.inProgress
                              ? null
                              : () {
                                  checkConnectionFunc(context, () {
                                    context
                                        .read<EditToolBloc>()
                                        .add(EditToolWithUpdatedToolModel());
                                  });
                                },
                          child: state.status == EditToolStatus.inProgress
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: ConstColors.backgroundLightColor,
                                  ),
                                )
                              : const Text(
                                  "Edit Tool",
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
