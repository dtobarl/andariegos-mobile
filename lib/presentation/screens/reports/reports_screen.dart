import 'package:flutter/material.dart';
import 'package:andariegos_mobile/data/models/report.dart';
import 'package:andariegos_mobile/presentation/screens/reports/report_detail_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Report> _mockReports = [
    Report(
      id: '1',
      eventId: '1',
      eventName: 'Tour por La Candelaria',
      description: 'El guía no se presentó a la hora acordada y no respondió a los mensajes',
      reportDate: DateTime.now().subtract(const Duration(days: 2)),
      reportedBy: 'Juan Pérez',
      status: ReportStatus.pending,
    ),
    Report(
      id: '2',
      eventId: '2',
      eventName: 'Visita al Museo del Oro',
      description: 'El evento no cumplió con las expectativas anunciadas en la descripción',
      reportDate: DateTime.now().subtract(const Duration(days: 1)),
      reportedBy: 'María García',
      status: ReportStatus.pending,
    ),
    Report(
      id: '3',
      eventId: '3',
      eventName: 'Recorrido por Monserrate',
      description: 'El precio no coincidía con el anunciado en la plataforma',
      reportDate: DateTime.now(),
      reportedBy: 'Carlos López',
      status: ReportStatus.approved,
      adminComment: 'Se ha contactado al organizador y se ha reembolsado la diferencia',
      decisionDate: DateTime.now(),
      decidedBy: 'Admin',
    ),
    Report(
      id: '4',
      eventId: '4',
      eventName: 'Tour Gastronómico Chapinero',
      description: 'El restaurante estaba cerrado y no se informó con anticipación',
      reportDate: DateTime.now().subtract(const Duration(days: 3)),
      reportedBy: 'Ana Martínez',
      status: ReportStatus.rejected,
      adminComment: 'El restaurante estaba abierto según registros y fotos del evento',
      decisionDate: DateTime.now().subtract(const Duration(days: 1)),
      decidedBy: 'Admin',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Report> get _pendingReports {
    return _mockReports.where((report) => report.status == ReportStatus.pending).toList();
  }

  List<Report> get _processedReports {
    return _mockReports.where((report) => 
      report.status == ReportStatus.approved || report.status == ReportStatus.rejected
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReportsList(_pendingReports),
          _buildReportsList(_processedReports),
        ],
      ),
    );
  }

  Widget _buildReportsList(List<Report> reports) {
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
            title: Text(report.eventName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.description),
                const SizedBox(height: 4),
                Text(
                  'Reportado por: ${report.reportedBy}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Fecha: ${_formatDate(report.reportDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (report.adminComment != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Comentario: ${report.adminComment}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ],
            ),
            trailing: _buildStatusIcon(report.status),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailScreen(report: report),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return const Icon(Icons.pending_actions, color: Colors.orange);
      case ReportStatus.approved:
        return const Icon(Icons.check_circle, color: Colors.green);
      case ReportStatus.rejected:
        return const Icon(Icons.cancel, color: Colors.red);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
} 