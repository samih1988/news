import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

typedef OnChanged = void Function(String)?;
typedef OnValidator = String? Function(String?)?;

class CustomTextFormField extends StatelessWidget {
  Color? borderColor;
  Color? cursercolor;
  String? hinttext;
  String? labeltext;
  TextStyle? hintstyle;
  TextStyle? labelstyle;
  Widget? prefixIcon;
  Widget? sufixIcon;
  TextStyle? style;
  TextEditingController? controller;
  OnChanged onChanged;
  OnValidator validator;
  TextInputType? keyboradtype;
  bool? obscuretext;
  int? maxline;
  String? obscuringCharacter;
  bool? fill;
  Color? filledColor;

  CustomTextFormField({
    super.key,
    this.borderColor,
    this.cursercolor,
    this.hinttext,
    this.hintstyle,
    this.labeltext,
    this.labelstyle,
    this.prefixIcon,
    this.sufixIcon,
    this.style,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboradtype,
    this.obscuretext,
    this.maxline,
    this.obscuringCharacter,
    this.fill,
    this.filledColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style,
      controller: controller,
      cursorColor: cursercolor ?? AppColors.white,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboradtype ?? TextInputType.text,
      obscureText: obscuretext ?? false,
      obscuringCharacter: obscuringCharacter ?? "*",
      maxLines: maxline ?? 1,
      decoration: InputDecoration(
        filled: fill,
        fillColor: filledColor,
        enabledBorder: _buildOutlineInputBorder(
          borderColor: borderColor ?? AppColors.transparentColor,
        ),
        focusedBorder: _buildOutlineInputBorder(
          borderColor: borderColor ?? AppColors.transparentColor,
        ),
        errorBorder: _buildOutlineInputBorder(borderColor: AppColors.red),
        focusedErrorBorder: _buildOutlineInputBorder(
          borderColor: AppColors.red,
        ),
        hintText: hinttext,
        hintStyle: hintstyle,
        labelText: labeltext,
        labelStyle: labelstyle,
        prefixIcon: prefixIcon,
        suffixIcon: sufixIcon,
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder({required Color borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(width: 2, color: borderColor),
    );
  }
}
