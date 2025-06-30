import 'package:flutter/material.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';

Widget buildStatItem(String label, String value, IconData icon) {
  return Column(
    children: [
      Icon(icon, color: Pallete.gradient2, size: 32),
      SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
    ],
  );
}
