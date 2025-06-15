class Report {
  final String id;
  final String eventId;
  final String eventName;
  final String description;
  final DateTime reportDate;
  final String reportedBy;
  final ReportStatus status;
  final String? adminComment;
  final DateTime? decisionDate;
  final String? decidedBy;

  Report({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.description,
    required this.reportDate,
    required this.reportedBy,
    required this.status,
    this.adminComment,
    this.decisionDate,
    this.decidedBy,
  });
}

enum ReportStatus {
  pending,
  approved,
  rejected
} 