import 'city.dart';
import 'house.dart';
import 'sim_traits.dart';

class Resident {
  String name;
  String lastName;
  int age;
  int days;
  
  final City city;
  final House house;
  SimTraits traits;

  Resident({
    required this.name,
    required this.lastName,
    required this.age,
    this.days = 0,
    required this.city,
    required this.house,
    SimTraits? traits,
  }) : traits = traits ?? SimTraits();

  bool get isAdult => age >= 18;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'age': age,
      'days': days,
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
      city: city,
      house: house,
      traits: json['traits'] != null ? SimTraits.fromJson(json['traits']) : SimTraits(),
    );
  }

  void incrementDays() {
    days++;
    if (days >= 4) {
      age++;
      days = 0;
    }
  }

  void decrementDays() {
    if (days > 0) {
      days--;
    } else if (age > 0) {
      age--;
      days = 3; 
    }
  }
}