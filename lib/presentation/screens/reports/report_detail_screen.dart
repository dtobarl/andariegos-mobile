import 'package:flutter/material.dart';
import 'package:andariegos_mobile/data/models/report.dart';
import 'package:andariegos_mobile/data/services/report_service.dart';

class ReportDetailScreen extends StatefulWidget {
  final Report report;

  const ReportDetailScreen({
    super.key,
    required this.report,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final ReportService _reportService = ReportService();
  bool _isLoading = false;
  String? _error;

  Future<void> _updateReportState(String newState) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      await _reportService.updateReportState(widget.report, newState);

      if (mounted) {
        Navigator.pop(context, true); // Retornar true para indicar que se actualizó
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Reporte'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'ID',
                    content: widget.report.id,
                    icon: Icons.confirmation_number,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Evento',
                    content: widget.report.idEvent.toString(),
                    icon: Icons.event,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Reportado por',
                    content: widget.report.idReporter,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Descripción',
                    content: widget.report.description,
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Estado',
                    content: widget.report.state,
                    icon: _getStateIcon(widget.report.state),
                    iconColor: _getStateColor(widget.report.state),
                  ),
                  if (widget.report.state == 'pending') ...[
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _updateReportState('accepted'),
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Aceptar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _updateReportState('denied'),
                            icon: const Icon(Icons.cancel),
                            label: const Text('Denegar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
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

  IconData _getStateIcon(String state) {
    switch (state) {
      case 'pending':
        return Icons.pending_actions;
      case 'accepted':
        return Icons.check_circle;
      case 'denied':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Color _getStateColor(String state) {
    switch (state) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'denied':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 