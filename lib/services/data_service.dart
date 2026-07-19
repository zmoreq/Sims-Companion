import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/city.dart';
import '../models/event_type.dart';

class DataService {
  static List<City> cities = [];

  static List<EventType> eventTypes = [
    EventType(id: 'birth', name: 'Narodziny', iconKey: 'baby', colorValue: 0xFF4CAF50),
    EventType(id: 'pregnancy', name: 'Ciąża', iconKey: 'baby', colorValue: 0xFF8BC34A),
    EventType(id: 'wedding', name: 'Ślub', iconKey: 'heart', colorValue: 0xFFE91E63),
    EventType(id: 'job', name: 'Nowa praca', iconKey: 'briefcase', colorValue: 0xFF2196F3),
    EventType(id: 'promotion', name: 'Awans', iconKey: 'trendUp', colorValue: 0xFFFFC107),
    EventType(id: 'move', name: 'Przeprowadzka', iconKey: 'house', colorValue: 0xFF9C27B0),
    EventType(id: 'death', name: 'Śmierć', iconKey: 'skull', colorValue: 0xFF424242),
  ];

  static Future<void> loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      String? citiesJson = prefs.getString('cities');
      if (citiesJson != null) {
        List<dynamic> citiesList = jsonDecode(citiesJson);
        cities = citiesList.map((cityJson) => City.fromJson(cityJson as Map<String, dynamic>)).toList();
      }

      String? eventsJson = prefs.getString('eventTypes');
      if (eventsJson != null) {
        List<dynamic> eventsList = jsonDecode(eventsJson);
        eventTypes = eventsList.map((e) => EventType.fromJson(e as Map<String, dynamic>)).toList();
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

      String eventsJson = jsonEncode(eventTypes.map((e) => e.toJson()).toList());
      await prefs.setString('eventTypes', eventsJson);
    } catch (e) {
      print("Error while saving data: $e");
    }
  }
}