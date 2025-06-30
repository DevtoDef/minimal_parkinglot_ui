import 'package:flutter/material.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';

Widget buildScanningUI({required String title}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.nfc, size: 100, color: Pallete.gradient2),
      const SizedBox(height: 20),
      Text(title, style: TextStyle(fontSize: 20, color: Pallete.whiteColor)),
    ],
  );
}
