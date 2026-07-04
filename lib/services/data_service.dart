import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/city.dart';

class DataService {
  static List<City> cities = [];

  static Future<void> loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? citiesJson = prefs.getString('cities');
      if (citiesJson != null) {
        List<dynamic> citiesList = jsonDecode(citiesJson);
        cities = citiesList.map((cityJson) => City.fromJson(cityJson as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print("Error while loading data: $e");
      cities = [];
    }
  }

  static Future<void> saveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String citiesJson = jsonEncode(cities.map((city) => city.toJson()).toList());
      await prefs.setString('cities', citiesJson);
    } catch (e) {
      print("Error while saving data: $e");
    }
  }
}