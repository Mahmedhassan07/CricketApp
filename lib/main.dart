import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/services/app_services.dart';
import 'data/services/mock_match_service.dart';
import 'features/auth/login_screen.dart';

void main() {
  // Swap this for your API-backed service later; no screen changes needed.
  AppServices.matches = MockMatchService();

  runApp(const CricketLiveApp());
}

class CricketLiveApp extends StatelessWidget {
  const CricketLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket Live',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginScreen(),
    );
  }
}
