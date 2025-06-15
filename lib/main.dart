import 'package:flutter/material.dart';
import 'package:andariegos_mobile/core/constants/app_constants.dart';
import 'package:andariegos_mobile/presentation/screens/auth/login_screen.dart';
import 'package:andariegos_mobile/presentation/screens/splash_screen.dart';
import 'package:andariegos_mobile/presentation/screens/reports/reports_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andariegos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.reports: (context) => const ReportsScreen(),
      },
    );
  }
}
