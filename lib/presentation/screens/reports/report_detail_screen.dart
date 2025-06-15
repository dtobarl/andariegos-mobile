import 'package:flutter/material.dart';
import 'package:andariegos_mobile/data/models/report.dart';

class ReportDetailScreen extends StatelessWidget {
  final Report report;

  const ReportDetailScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Reporte'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Evento',
              content: report.eventName,
              icon: Icons.event,
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Descripción del Reporte',
              content: report.description,
              icon: Icons.description,
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Reportado por',
              content: report.reportedBy,
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Fecha del Reporte',
              content: _formatDate(report.reportDate),
              icon: Icons.calendar_today,
            ),
            if (report.status != ReportStatus.pending) ...[
              const SizedBox(height: 16),
              _buildSection(
                title: 'Estado',
                content: _getStatusText(report.status),
                icon: _getStatusIcon(report.status),
                iconColor: _getStatusColor(report.status),
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Comentario del Administrador',
                content: report.adminComment ?? 'Sin comentarios',
                icon: Icons.comment,
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Decidido por',
                content: report.decidedBy ?? 'N/A',
                icon: Icons.admin_panel_settings,
              ),
              if (report.decisionDate != null) ...[
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Fecha de Decisión',
                  content: _formatDate(report.decisionDate!),
                  icon: Icons.update,
                ),
              ],
            ],
            if (report.status == ReportStatus.pending) ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementar aprobación
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Aprobar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementar rechazo
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Rechazar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    Color? iconColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getStatusText(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return 'Pendiente';
      case ReportStatus.approved:
        return 'Aprobado';
      case ReportStatus.rejected:
        return 'Rechazado';
    }
  }

  IconData _getStatusIcon(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return Icons.pending_actions;
      case ReportStatus.approved:
        return Icons.check_circle;
      case ReportStatus.rejected:
        return Icons.cancel;
    }
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return Colors.orange;
      case ReportStatus.approved:
        return Colors.green;
      case ReportStatus.rejected:
        return Colors.red;
    }
  }
} 