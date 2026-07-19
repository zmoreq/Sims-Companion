import 'house.dart';
import 'resident.dart';

class City {
  String name;
  List<House> houses;
  List<Resident> deceased;
  int turns;

  City({
    required this.name,
    List<House>? houses,
    List<Resident>? deceased,
    this.turns = 1,
  }) : houses = houses ?? [],
       deceased = deceased ?? [];

  int get population {
    return houses.fold(0, (sum, house) => sum + house.population);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'turns': turns,
      'houses': houses.map((house) => house.toJson()).toList(),
      'deceased': deceased.map((sim) => sim.toJson()).toList(),
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    City parsedCity = City(
      name: json['name'] ?? "Unknown City",
      turns: json['turns'] ?? 1,
    );

    if (json['houses'] != null) {
      parsedCity.houses = (json['houses'] as List)
          .map((houseJson) => House.fromJson(houseJson as Map<String, dynamic>, parsedCity))
          .toList();
    }

    if (json['deceased'] != null) {
      parsedCity.deceased = (json['deceased'] as List)
          .map((simJson) => Resident.fromJson(simJson as Map<String, dynamic>, parsedCity, null))
          .toList();
    }

    return parsedCity;
  }

  void addHouse(House house) => houses.add(house);
  void removeHouse(House house) {
    houses.remove(house); 
    checkAndUpdateTurn();
  }

  void checkAndUpdateTurn() {
    if (houses.isEmpty) return;

    int minTurn = houses.first.turns;

    for (var house in houses) {
      if (house.turns < minTurn) {
        minTurn = house.turns;
      }
    }

    turns = minTurn;
  }
}