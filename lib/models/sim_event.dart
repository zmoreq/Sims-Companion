class SimEvent {
  String eventTypeId;
  int simAge;
  int simDays;
  String? description;

  SimEvent({
    required this.eventTypeId,
    required this.simAge,
    required this.simDays,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventTypeId': eventTypeId,
      'simAge': simAge,
      'simDays': simDays,
      'description': description,
    };
  }

  factory SimEvent.fromJson(Map<String, dynamic> json) {
    return SimEvent(
      eventTypeId: json['eventTypeId'] ?? '',
      simAge: json['simAge'] ?? 0,
      simDays: json['simDays'] ?? 0,
      description: json['description'],
    );
  }
}