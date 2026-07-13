class EventType {
  String id;
  String name;
  String iconKey;
  int colorValue;

  EventType({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconKey': iconKey,
      'colorValue': colorValue,
    };
  }

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Nieznane',
      iconKey: json['iconKey'] ?? 'star',
      colorValue: json['colorValue'] ?? 0xFF9E9E9E,
    );
  }
}