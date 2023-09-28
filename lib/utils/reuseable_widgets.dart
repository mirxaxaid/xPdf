import 'package:flutter/material.dart';

class ReUsableWidgets {
  static Widget buildTextFormFieldWithTextColor({
    TextEditingController? controller,
    String labelText = '',
    IconData? icon,
    Function()? onTap,
    Function(String)? onChanged,
    String? initialValue,
    String? Function(String?)? validator,
    TextStyle? textStyle,
    Color? labelColor,
    Color? iconColor,
    Color? suffixIconBorderColor,
    Color? suffixContainerColor,
    BorderRadiusGeometry? suffixIconBorderRadius,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      style: textStyle,
      maxLines: null,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        icon: icon != null
            ? Icon(
          icon,
          color: iconColor,
        )
            : null,
        suffixIcon: onTap != null
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: suffixIconBorderColor ?? Colors.black,
                ),
                borderRadius: suffixIconBorderRadius ??
                    BorderRadius.circular(10),
                color: suffixContainerColor ?? Colors.black12
              ),
            ),
          ),
        )
            : null,
      ),
      onTapOutside: (event) {
        primaryFocus!.unfocus();
      },
      onChanged: onChanged,
      validator: validator,
    );
  }


}
