import 'house.dart';

class City {
  String name;
  List<House> houses;

  City({
    required this.name,
    List<House>? houses,
  }) : houses = houses ?? [];

  int get population {
    return houses.fold(0, (sum, house) => sum + house.population);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'houses': houses.map((house) => house.toJson()).toList(),
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    City parsedCity = City(
      name: json['name'] ?? "Unknown City",
    );

    if (json['houses'] != null) {
      parsedCity.houses = (json['houses'] as List)
          .map((houseJson) => House.fromJson(houseJson as Map<String, dynamic>, parsedCity))
          .toList();
    }

    return parsedCity;
  }

  void addHouse(House house) => houses.add(house);
  void removeHouse(House house) => houses.remove(house);
}