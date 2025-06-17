import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

class AndariegosMobileApp extends StatelessWidget {
  const AndariegosMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andariegos Mobile',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/splash',
    );
  }
} 