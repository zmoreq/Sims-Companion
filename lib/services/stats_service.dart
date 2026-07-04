import '../models/city.dart';
import '../models/resident.dart';
import 'data_service.dart';

class StatsService {
  static const List<String> possibleEyeColors = [
    'brown', 'blue', 'green', 'grey', 'red'
  ];

  static const List<String> possibleHairColors = [
    'black', 'brown', 'blond', 'grey', 'white' 
  ];

  static List<Resident> _getAllResidents({City? selectedCity}) {
    if (selectedCity != null) {
      return selectedCity.houses.expand((house) => house.residents).toList();
    }
    return DataService.cities
        .expand((city) => city.houses)
        .expand((house) => house.residents)
        .toList();
  }

  static String _calculatePercentage(int part, int total) {
    if (total == 0) return '0%';
    return '${((part / total) * 100).toStringAsFixed(1)}%';
  }

  static int getTotalPopulation({City? selectedCity}) {
    if (selectedCity != null) return selectedCity.population;
    return DataService.cities.fold(0, (sum, city) => sum + city.population);
  }

  static int getTotalHouses({City? selectedCity}) {
    if (selectedCity != null) return selectedCity.houses.length;
    return DataService.cities.fold(0, (sum, city) => sum + city.houses.length);
  }
  
  static int getAverageAge({City? selectedCity}) {
    var residents = _getAllResidents(selectedCity: selectedCity);
    if (residents.isEmpty) return 0;
    
    int totalAge = residents.fold(0, (sum, resident) => sum + resident.age);
    return (totalAge / residents.length).round();
  }

  static int getEyeColorValueForChart(String? color, {City? selectedCity}) {
    var residents = _getAllResidents(selectedCity: selectedCity);
    return residents.where((r) => r.traits.eyeColor == color).length;
  }

  static int getHairColorValueForChart(String? color, {City? selectedCity}) {
    var residents = _getAllResidents(selectedCity: selectedCity);
    return residents.where((r) => r.traits.hairColor == color).length;
  }

  static String getEyeColorPercentageForChart(String? color, {City? selectedCity}) {
    var residents = _getAllResidents(selectedCity: selectedCity);
    int count = residents.where((r) => r.traits.eyeColor == color).length;
    return _calculatePercentage(count, residents.length);
  }

  static String getHairColorPercentageForChart(String? color, {City? selectedCity}) {
    var residents = _getAllResidents(selectedCity: selectedCity);
    int count = residents.where((r) => r.traits.hairColor == color).length;
    return _calculatePercentage(count, residents.length);
  }

  static int getResidentsWithNoEyeColor({City? selectedCity}) {
    return getEyeColorValueForChart(null, selectedCity: selectedCity);
  }

  static int getResidentsWithNoHairColor({City? selectedCity}) {
    return getHairColorValueForChart(null, selectedCity: selectedCity);
  }

  static String getResidentsWithNoEyeColorPercentage({City? selectedCity}) {
    return getEyeColorPercentageForChart(null, selectedCity: selectedCity);
  }

  static String getResidentsWithNoHairColorPercentage({City? selectedCity}) {
    return getHairColorPercentageForChart(null, selectedCity: selectedCity);
  }
}