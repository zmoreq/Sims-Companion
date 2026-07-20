class SimEvent {
  String eventTypeId;
  int simAge;
  int houseDay;
  int houseTurn;
  String? description;

  SimEvent({
    required this.eventTypeId,
    required this.simAge,
    required this.houseDay,
    required this.houseTurn,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventTypeId': eventTypeId,
      'simAge': simAge,
      'houseDay': houseDay,
      'houseTurn': houseTurn,
      'description': description,
    };
  }

  factory SimEvent.fromJson(Map<String, dynamic> json) {
    return SimEvent(
      eventTypeId: json['eventTypeId'] ?? '',
      simAge: json['simAge'] ?? 0,
      houseDay: json['houseDay'] ?? 0,
      houseTurn: json['houseTurn'] ?? 0,
      description: json['description'],
    );
  }
}