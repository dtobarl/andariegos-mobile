class Report {
  final String id;
  final int idEvent;
  final String idReporter;
  final String state;
  final String description;
  final String? eventName;

  Report({
    required this.id,
    required this.idEvent,
    required this.idReporter,
    required this.state,
    required this.description,
    this.eventName,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'] as String,
      idEvent: json['id_event'] as int,
      idReporter: json['id_reporter'] as String,
      state: json['state'] as String,
      description: json['description'] as String,
      eventName: json['eventName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id_event': idEvent,
      'id_reporter': idReporter,
      'state': state,
      'description': description,
      'eventName': eventName,
    };
  }
}