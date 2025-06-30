import 'package:flutter/material.dart';
import 'package:minimal_parkinglot/core/theme/theme.dart';
import 'package:minimal_parkinglot/features/auth/view/pages/auth_checker_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal Parking Lot',
      theme: AppTheme.darkThemeMode,
      home: const AuthChecker(),
    );
  }
}
