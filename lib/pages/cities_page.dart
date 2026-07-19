import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/city_card.dart';
import 'city_page.dart';
import '../models/city.dart';
import '../widgets/bottom_nav.dart';
import 'stats_page.dart';
import 'generator_page.dart';
import 'diary_page.dart';
import '../services/data_service.dart';
import '../utils/snackbar_utils.dart';
import '../widgets/remove_dialog.dart';

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  @override
  void initState() {
    super.initState();
    DataService.loadData().then((_) {
      setState(() {});
    });
  }

  void _onTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StatsPage(isGlobal: true, returnRoute: "/"),
          ),
        );
      case 2:
        _showAddCityDialog();
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GeneratorPage(returnRoute: "/")),
        );
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DiaryPage(returnRoute: "/")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              _buildHeader(context),
              _buildCitiesList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: _onTapped,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sims",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 48,
                letterSpacing: 5.0,
              )
        ),
        Text(
          "Companion",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 48,
                letterSpacing: 5.0,
              )
        ),
        Text(
          "Zarządzaj swoją Simsową populacją",
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        Divider(
          height: 60,
          thickness: 2,
          color: Theme.of(context).colorScheme.outline,
          indent: 25,
          endIndent: 25,
        ),
      ],
    );
  }

  Widget _buildCitiesList() {
    return Column(
      children: DataService.cities.map((cityObject) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CityCard(
            city: cityObject,
            onTap: () => _navigateToCity(cityObject),
            onDelete: () => _deleteCity(cityObject),
            onEdit: () => _showEditCityDialog(cityObject),
          ),
        );
      }).toList(),
    );
  }

  void _navigateToCity(City city) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CityPage(city: city),
        settings: const RouteSettings(name: "/city"), 
      ),
    );
  }

  Future<void> _deleteCity(City cityToDelete) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => RemoveDialog(
        content: "Czy na pewno chcesz usunąć miasto ${cityToDelete.name}? To bezpowrotnie usunie wszystkie domy i mieszkańców w tym mieście.",
      ),
    );

    if (confirmDelete == true) {
      setState(() {
        DataService.cities.remove(cityToDelete);
      });
      DataService.saveData(); 
    }
  }

  Future<void> _showEditCityDialog(City city) async {
    final TextEditingController nameController = TextEditingController(text: city.name);

    final String? updatedName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edytuj nazwę miasta'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Nazwa miasta'),
          ),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: () => Navigator.of(context).pop(nameController.text),
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );

    if (updatedName != null && updatedName.isNotEmpty) {
      setState(() {
        city.name = updatedName;
      });
      DataService.saveData(); 
    }
  }

  Future<void> _showAddCityDialog() async {
    final TextEditingController nameController = TextEditingController();

    final String? cityName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nazwij swoje miasto'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nazwa miasta'),
          ),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(context).pop(null),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: () {
                final input = nameController.text.trim();
                if (input.isNotEmpty) {
                  Navigator.of(context).pop(input);
                } else {
                  SnackbarUtils.showError(context, "Nazwa miasta nie może być pusta!");
                }
              },
              child: const Text('Dodaj'),
            ),
          ],
        );
      },
    );
    
    Future.delayed(const Duration(milliseconds: 500), () => nameController.dispose());

    if (cityName != null && cityName.isNotEmpty) {
      setState(() {
        DataService.cities.add(City(name: cityName));
      });
      DataService.saveData(); 
    }
  }
}