import 'package:flutter/material.dart';
import 'package:stonk_it/resources/constants.dart';

import '../colors.dart';

final InputBorder inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(
    color: AppColors.fieldBorderColor,
    width: 1,
  ),
);

class TextFieldMd extends StatelessWidget {
  const TextFieldMd(
      {super.key,
      this.controller,
      this.prefixIcon,
      this.suffixIcon,
      this.hintText,
      this.labelText,
      this.obscureText,
      this.keyboardType,
      this.boxShadow,
      this.onChanged,
      this.maxWidth,
      this.labelFontSize,
      this.textAlign,
      this.validator});
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? labelText;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final bool? boxShadow;
  final void Function(String)? onChanged;
  final double? maxWidth;
  final double? labelFontSize;
  final TextAlign? textAlign;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText ?? '',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: labelFontSize ?? 14),
        ),
        SizedBox(
          height: labelText != null ? 12 : 0,
        ),
        Container(
          // height: 44,
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            textAlign: textAlign ?? TextAlign.start,
            cursorColor: AppColors.fieldBorderColor,
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText ?? false,
            keyboardType: keyboardType ?? TextInputType.text,
            validator: validator,
            decoration: InputDecoration(
              focusedErrorBorder: inputBorder,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
              ),
              enabledBorder: inputBorder,
              focusedBorder: inputBorder,
              border: inputBorder,
              constraints: BoxConstraints(
                minHeight: 44,
                maxWidth: maxWidth ?? MediaQuery.of(context).size.width,
              ),
              hintText: hintText,
              hintStyle: kFourteenRegBorderColorPoppins,
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: prefixIcon,
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 5),
                      child: suffixIcon,
                    )
                  : null,
            ),
            style: kFourteenRegBlackPoppins,
          ),
        ),
      ],
    );
  }
}
