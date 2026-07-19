import 'city.dart';
import 'resident.dart';

class House {
  String name;
  final City city;
  int turns;
  int days;
  List<Resident> residents;

  int daysForTurn = 4;
  
  final int maxResidents = 8;

  int get population => residents.length;

  House({
    required this.name,
    required this.city,
    int? turns,
    this.days = 0,
    List<Resident>? residents,
  }) : turns = turns ?? city.turns,
       residents = residents ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city.name, 
      'turn': turns,
      'days': days,
      'residents': residents.map((resident) => resident.toJson()).toList(),
    };
  }

  factory House.fromJson(Map<String, dynamic> json, City city) {
    House house = House(
      name: json['name'] ?? "Unknown House",
      city: city,
      turns: json['turn'] ?? 0,
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

  void incrementTurn() {
    turns++;
    city.checkAndUpdateTurn();
  }

  void incrementDays() {
    days++;
    if (days % (daysForTurn + 1) == 0) {
      incrementTurn();
      days = 1;
    }

  }
  
  void decrementDays() {
    if (days > 1) {
      days--;
    }
    else if (turns > 0) {
      turns--;
      days = daysForTurn;
    }
  }
}