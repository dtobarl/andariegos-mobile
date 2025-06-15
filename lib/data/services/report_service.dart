import 'package:dio/dio.dart';

class ReportService {
  final Dio _dio;
  // Cambia esta IP por la IP real de tu computadora
  static const String _baseUrl = 'http://192.168.0.7:5000/api/reports'; // Reemplaza X con tu IP
  // static const String _baseUrl = 'http://localhost:5000/api/reports'; // Para iOS

  ReportService() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.sendTimeout = const Duration(seconds: 10);
  }

  Future<List<Map<String, dynamic>>> getAllReports() async {
    try {
      final response = await _dio.get('/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Error de conexión: No se pudo conectar al servidor. Verifica que:\n'
            '1. El servidor esté corriendo (python run.py)\n'
            '2. MongoDB esté instalado y corriendo\n'
            '3. La IP sea correcta (192.168.0.7)');
      }
      throw Exception('Error al obtener reportes: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<Map<String, dynamic>> getReport(String id) async {
    try {
      final response = await _dio.get('/$id');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Error al obtener el reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<String> createReport(Map<String, dynamic> reportData) async {
    try {
      final response = await _dio.post('/', data: reportData);
      return response.data['id'];
    } on DioException catch (e) {
      throw Exception('Error al crear el reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<void> updateReport(String id, Map<String, dynamic> reportData) async {
    try {
      await _dio.put('/$id', data: reportData);
    } on DioException catch (e) {
      throw Exception('Error al actualizar el reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<void> deleteReport(String id) async {
    try {
      await _dio.delete('/$id');
    } on DioException catch (e) {
      throw Exception('Error al eliminar el reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
} 