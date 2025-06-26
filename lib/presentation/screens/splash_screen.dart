import 'package:flutter/material.dart';
import 'package:andariegos_mobile/core/constants/app_constants.dart';
import 'package:andariegos_mobile/data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AuthService _authService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
    _initAuthService();
  }

  Future<void> _initAuthService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authService = AuthService(prefs);
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
      _checkAuth();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al inicializar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _checkAuth() async {
    if (!_isInitialized) return;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (_authService.isLoggedIn()) {
      if (_authService.isSessionExpired()) {
        await _authService.logout();
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión expirada. Por favor, inicia sesión nuevamente.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      if (_authService.isAdmin()) {
        Navigator.pushReplacementNamed(context, AppRoutes.reports);
      } else {
        await _authService.logout();
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acceso denegado. Se requieren permisos de administrador.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Andariegos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 