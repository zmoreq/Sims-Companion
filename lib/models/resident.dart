import 'city.dart';
import 'house.dart';
import 'sim_traits.dart';
import 'sim_event.dart';

class Resident {
  String name;
  String lastName;
  int age; // TODO: Age and days need update but after fundamental things are done  
  int days;
  String notes; 
  List<SimEvent> events;
  
  final City city;
  final House house;
  SimTraits traits;

  Resident({
    required this.name,
    required this.lastName,
    required this.age,
    this.days = 0,
    this.notes = "", 
    List<SimEvent>? events,
    required this.city,
    required this.house,
    SimTraits? traits,
  }) : traits = traits ?? SimTraits(),
       events = events ?? [];

  bool get isAdult => age >= 18;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'age': age,
      'days': days,
      'notes': notes, 
      'events': events.map((e) => e.toJson()).toList(),
      'city': city.name,
      'house': house.name,
      'traits': traits.toJson(),
    };
  }

  factory Resident.fromJson(Map<String, dynamic> json, City city, House house) {
    return Resident(
      name: json['name'] ?? "Brak imienia",
      lastName: json['lastName'] ?? "Brak nazwiska",
      age: json['age'] ?? 0,
      days: json['days'] ?? 0,
      notes: json['notes'] ?? "", 
      events: json['events'] != null 
        ? (json['events'] as List).map((e) => SimEvent.fromJson(e)).toList() 
        : [],
      city: city,
      house: house,
      traits: json['traits'] != null ? SimTraits.fromJson(json['traits']) : SimTraits(),
    );
  }

  void incrementDays() {
    days++;
    age++; // one day = one year
  }

  void decrementDays() {
    days--;
    age--;
  }
}