import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:andariegos_mobile/core/constants/app_constants.dart';
import 'package:andariegos_mobile/presentation/screens/auth/login_screen.dart';
import 'package:andariegos_mobile/presentation/screens/splash_screen.dart';
import 'package:andariegos_mobile/presentation/screens/reports/reports_screen.dart';

final ThemeData andariegosTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF193B6A), // hsl(215, 100%, 25%)
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF1A202C), // hsl(222.2, 84%, 4.9%)
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF193B6A)),
    titleTextStyle: TextStyle(
      color: Color(0xFF193B6A),
      fontFamily: 'Inter',
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF193B6A),
    onPrimary: Color(0xFFF6F8FA), // hsl(210, 40%, 98%)
    secondary: Color(0xFFF1F5F9), // hsl(210, 40%, 96.1%)
    onSecondary: Color(0xFF1A202C),
    error: Color(0xFFEF4444), // hsl(0, 84.2%, 60.2%)
    onError: Color(0xFFF6F8FA),
    background: Colors.white,
    onBackground: Color(0xFF1A202C),
    surface: Colors.white,
    onSurface: Color(0xFF1A202C),
  ),
  fontFamily: 'Inter',
  textTheme: GoogleFonts.interTextTheme(),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFE5E7EB)), // hsl(214.3, 31.8%, 91.4%)
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF193B6A),
      foregroundColor: const Color(0xFFF6F8FA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  cardTheme: const CardThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andariegos',
      theme: andariegosTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.reports: (context) => const ReportsScreen(),
      },
    );
  }
}
