import 'package:flutter/widgets.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';

Widget BuildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Pallete.greyColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Pallete.whiteColor,
          ),
        ),
      ],
    ),
  );
}
