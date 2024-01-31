import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.maxLines,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType,
    this.readOnly,
    this.validator,
    this.onTap,
    this.onChange,
    this.obscureText,
    this.errorText,
    this.initialValue,
    this.inputFormatters,
    this.enabled,
  });

  final TextEditingController? controller;
  final int? maxLines;
  final String? hintText;
  final String? labelText;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function(String)? onChange;
  final bool? readOnly;
  final bool? obscureText;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final String? errorText;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      //padding: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 0.w),

      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
              //primary: kDarkPinkColor,
              ),
        ),
        child: TextFormField(
          enabled: enabled,
          initialValue: initialValue,
          maxLines: maxLines ?? 1,
          controller: controller,
          keyboardType: textInputType ?? TextInputType.name,
          readOnly: readOnly ?? false,
          validator: validator,
          onTap: onTap,
          obscureText: obscureText ?? false,
          //cursorColor: kDarkPinkColor,
          inputFormatters: inputFormatters,

          onChanged: onChange,
          decoration: InputDecoration(
            errorMaxLines: 2,
            //floatingLabelBehavior: FloatingLabelBehavior.never,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            //fillColor: kTextFieldColor,
            //filled: true,
            hintText: hintText,
            labelText: labelText,

            //errorStyle: kErrorTextStyle,

            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54, width: 2.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38, width: 2.0),
            ),
            // errorBorder: OutlineInputBorder(
            //   //borderSide: const BorderSide(color: kTextFieldColor),
            //   borderRadius: BorderRadius.circular(0.r),
            // ),
            // focusedErrorBorder: OutlineInputBorder(
            //   //borderSide: const BorderSide(color: kTextFieldColor),
            //   borderRadius: BorderRadius.circular(0.r),
            // ),
          ),
        ),
      ),
    );
  }
}
