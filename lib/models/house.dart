import 'city.dart';
import 'resident.dart';

class House {
  String name;
  final City city;
  int turn;
  int days;
  List<Resident> residents;
  
  final int maxResidents = 8;

  int get population => residents.length;

  House({
    required this.name,
    required this.city,
    this.turn = 0,
    this.days = 0,
    List<Resident>? residents,
  }) : residents = residents ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city.name, 
      'turn': turn,
      'days': days,
      'residents': residents.map((resident) => resident.toJson()).toList(),
    };
  }

  factory House.fromJson(Map<String, dynamic> json, City city) {
    House house = House(
      name: json['name'] ?? "Unknown House",
      city: city,
      turn: json['turn'] ?? 0,
      days: json['days'] ?? 0,
    );

    if (json['residents'] != null) {
      house.residents = (json['residents'] as List)
          .map((residentJson) => Resident.fromJson(residentJson as Map<String, dynamic>, city, house))
          .toList();
    }
    
    return house;
  }

  void addResident(Resident resident) {
    if (residents.length < maxResidents) residents.add(resident);
  }
  
  void removeResident(Resident resident) => residents.remove(resident);

  List<Resident> getResidentsByAge(int targetAge) {
    return residents.where((resident) => resident.age == targetAge).toList();
  }

  void incrementTurn() => turn++;

  void incrementDays() {
    days++;
    if (days % 4 == 0) {
      incrementTurn();
    }

  }
  
  void decrementDays() {
    if (days > 0) days--;
  }
}