import 'package:flutter/material.dart';
import 'package:andariegos_mobile/data/models/report.dart';
import 'package:andariegos_mobile/data/services/report_service.dart';
import 'package:andariegos_mobile/data/services/auth_service.dart';
import 'package:andariegos_mobile/presentation/screens/reports/report_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ReportService _reportService = ReportService();
  AuthService? _authService;
  List<Report> _reports = [];
  bool _isLoading = true;
  String? _error;
  Timer? _sessionTimer;
  int _remainingMinutes = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initAuthService();
    _loadReports();
  }

  Future<void> _initAuthService() async {
    final prefs = await SharedPreferences.getInstance();
    _authService = AuthService(prefs);
    if (mounted) {
      _startSessionTimer();
    }
  }

  Future<void> _logout() async {
    await _authService?.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _startSessionTimer() {
    if (_authService == null) return;
    _updateRemainingTime();
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    if (mounted && _authService != null) {
      setState(() {
        _remainingMinutes = _authService!.getRemainingMinutes();
      });
      
      // Si la sesión expiró, hacer logout automático
      if (_remainingMinutes <= 0) {
        _logout();
      }
    }
  }

  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  Future<void> _loadReports() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final reports = await _reportService.getAllReports();
      
      if (mounted) {
        setState(() {
          _reports = reports;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _stopSessionTimer();
    super.dispose();
  }

  List<Report> get _pendingReports {
    return _reports.where((report) => report.state == 'pending').toList();
  }

  List<Report> get _processedReports {
    return _reports.where((report) => 
      report.state == 'accepted' || report.state == 'denied'
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.pending_actions),
              text: 'Pendientes',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Procesados',
            ),
          ],
        ),
        actions: [
          // Mostrar tiempo restante de sesión
          if (_authService != null && _remainingMinutes > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: _remainingMinutes <= 5 ? Colors.red : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_remainingMinutes}m',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReports,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error al cargar los reportes',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadReports,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReportsList(_pendingReports),
                    _buildReportsList(_processedReports),
                  ],
                ),
    );
  }

  Widget _buildReportsList(List<Report> reports) {
    if (reports.isEmpty) {
      return const Center(
        child: Text('No hay reportes disponibles'),
      );
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: ListTile(
            title: Text('ID: ${report.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Evento: ${report.eventName ?? 'ID: ${report.idEvent}'}'),
                Text('Reportado por: ${report.idReporter}'),
                Text('Descripción: ${report.description}'),
                Text('Estado: ${report.state}'),
              ],
            ),
            trailing: _buildStateIcon(report.state),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailScreen(report: report),
                ),
              );
              if (result == true) {
                _loadReports();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildStateIcon(String state) {
    switch (state) {
      case 'pending':
        return const Icon(Icons.pending_actions, color: Colors.orange);
      case 'accepted':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'denied':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }
} 