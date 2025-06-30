import 'package:flutter/material.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';

void showSnackBar(
  BuildContext context,
  String content, {
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: backgroundColor ?? Pallete.whiteColor,
    ),
  );
}
