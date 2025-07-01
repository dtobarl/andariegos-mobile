import 'package:dio/dio.dart';
import 'package:andariegos_mobile/data/models/report.dart';
import 'dart:io';

class ReportService {
  final Dio _dio;
  // Para desarrollo local
  //static const String _baseUrl = 'http://10.0.2.2:5000/api/reports'; // Para emulador Android
  //static const String _baseUrl = 'http://localhost:5000/api/reports'; // Para iOS y Windows (En Android Studio, la opción Windows (Desktop))
  static String get _baseUrl {
    const pcIp = String.fromEnvironment('PC_IP', defaultValue: '192.168.0.17');
    print('=== REPORT SERVICE DEBUG ===');
    print('PC_IP from environment: $pcIp');
    print('Full URL: http://$pcIp:7080/api/report');
    print('============================');
    return 'http://$pcIp:7080/api/report';
  }


  ReportService() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.sendTimeout = const Duration(seconds: 10);
    // Permitir certificados self-signed solo en desarrollo
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<List<Report>> getAllReports() async {
    try {
      final response = await _dio.get('');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('Response data type: ${response.data.runtimeType}');
      
      if (response.data is List) {
        return (response.data as List)
            .map((json) {
              print('Processing report: $json');
              return Report.fromJson(json);
            })
            .toList();
      } else {
        print('Unexpected response format: ${response.data}');
        return [];
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status: ${e.response?.statusCode}');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Error de conexión: No se pudo conectar al servidor. Verifica que:\n'
            '1. El servidor esté corriendo (python run.py)\n'
            '2. MongoDB esté instalado y corriendo\n'
            '3. La URL sea correcta ($_baseUrl)');
      }
      throw Exception('Error al obtener reportes: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  Future<Report> getReport(String id) async {
    try {
      final response = await _dio.get('/$id');
      return Report.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error al obtener el reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<String> createReport(Report report) async {
    try {
      final response = await _dio.post('', data: report.toJson());
      return response.data['id'];
    } on DioException catch (e) {
      throw Exception('Error al crear el reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<void> updateReport(String id, Report report) async {
    try {
      await _dio.put('/$id', data: report.toJson());
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

  Future<List<Report>> getReportsByState(String state) async {
    try {
      final response = await _dio.get('/state/$state');
      print('Respuesta de getReportsByState: \\n${response.data}');
      final data = response.data;
      if (data is List) {
        return data.map((json) => Report.fromJson(json)).toList();
      } else {
        print('Respuesta inesperada: $data');
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Error al obtener reportes por estado: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<void> updateReportState(Report report, String newState) async {
    try {
      final data = {
        'id_event': report.idEvent,
        'id_reporter': report.idReporter,
        'description': report.description,
        'state': newState,
      };
      print('PUT URL: /${report.id}');
      print('Enviando PUT: $data');
      await _dio.put('/${report.id}', data: data);
    } on DioException catch (e) {
      print('Error en updateReportState: ${e.message}');
      print('Response data: ${e.response?.data}');
      throw Exception('Error al actualizar el estado del reporte: ${e.message}');
    } catch (e) {
      print('Error inesperado en updateReportState: $e');
      throw Exception('Error inesperado: $e');
    }
  }
} 