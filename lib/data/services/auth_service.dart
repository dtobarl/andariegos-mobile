import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final SharedPreferences _prefs;
  final Dio _dio;
  static const String _userEmailKey = 'user_email';
  static const String _userPasswordKey = 'user_password';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isAdminKey = 'is_admin';
  
  // URL del gateway - se ajusta según la plataforma
  static String get _baseUrl {
    if (Platform.isAndroid) {
      // Para emulador Android
      if (Platform.environment.containsKey('ANDROID_EMULATOR')) {
        return 'http://10.0.2.2:7080/api/auth';
      }
      // Para dispositivo físico Android
      return 'http://192.168.0.15:7080/api/auth'; // Cambia esto por la IP de tu computadora
    } else if (Platform.isIOS) {
      // Para iOS simulator
      if (Platform.environment.containsKey('IOS_SIMULATOR')) {
        return 'http://localhost:7080/api/auth';
      }
      // Para dispositivo físico iOS
      return 'http://192.168.0.15:7080/api/auth'; // Cambia esto por la IP de tu computadora
    } else {
      // Para otros dispositivos
      return 'http://192.168.0.15:7080/api/auth'; // Cambia esto por la IP de tu computadora
    }
  }

  AuthService(this._prefs) : _dio = Dio() {
    print('Inicializando AuthService con URL base: $_baseUrl'); // Debug log
    
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Aumentar timeouts
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);
    
    // Agregar interceptor para logging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
      logPrint: (object) {
        print('DIO LOG: $object');
      },
    ));
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Intentando login con: $email');
      print('URL de la petición: ${_dio.options.baseUrl}/login');
      
      final requestData = {
        'identifier': email.trim(),
        'password': password.trim(),
      };
      
      print('Datos de la solicitud: $requestData');
      
      final response = await _dio.post(
        '/login',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
          contentType: 'application/json',
        ),
      );

      print('Respuesta del servidor: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Guardar credenciales
        await _prefs.setString(_userEmailKey, email);
        await _prefs.setString(_userPasswordKey, password);
        await _prefs.setBool(_isLoggedInKey, true);
        
        // Decodificar el token JWT para obtener los roles
        final token = data['access_token'];
        final Map<String, dynamic> tokenData = JwtDecoder.decode(token);
        
        // Verificar si el usuario es admin basado en los roles en el token
        final roles = List<String>.from(tokenData['roles'] ?? []);
        final isAdmin = roles.contains('ADMIN');
        await _prefs.setBool(_isAdminKey, isAdmin);
        
        print('Roles del usuario: $roles');
        print('¿Es admin?: $isAdmin');
        
        return {
          'success': true,
          'access_token': data['access_token'],
          'user': data['user'],
          'userId': data['user']['_id'],
        };
      } else {
        final errorMessage = response.data['error'] ?? 'Error desconocido';
        throw Exception('Error en la autenticación: $errorMessage');
      }
    } catch (e) {
      print('Error en login: $e');
      if (e is DioException) {
        print('Error DioException: ${e.message}');
        print('Error response: ${e.response?.data}');
        print('Error status: ${e.response?.statusCode}');
        print('Error headers: ${e.response?.headers}');
        print('Error type: ${e.type}');
        print('Error error: ${e.error}');
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.setBool(_isAdminKey, false);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  bool isAdmin() {
    return _prefs.getBool(_isAdminKey) ?? false;
  }

  String? getStoredEmail() {
    return _prefs.getString(_userEmailKey);
  }
} 