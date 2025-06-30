import 'package:flutter/material.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';

Widget buildActivityItem() {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Pallete.backgroundColor,
      border: Border.all(color: Pallete.gradient1.withOpacity(0.8), width: 2),
    ),
    child: Row(
      children: [
        Icon(Icons.motorcycle_outlined, color: Pallete.gradient2, size: 32),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '29A-12345 - Check In',
                style: TextStyle(
                  color: Pallete.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '2 phút trước',
                style: TextStyle(color: Pallete.greyColor, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
