import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      obscureText: isObscureText,
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Please enter your $hintText';
        } else if (hintText == 'Email' &&
            !RegExp(
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            ).hasMatch(value)) {
          return 'Please enter a valid email address';
        } else if (hintText == 'Password' && value.length < 6) {
          return 'Password must be at least 6 characters long';
        } else {
          return null;
        }
      },
    );
  }
}
