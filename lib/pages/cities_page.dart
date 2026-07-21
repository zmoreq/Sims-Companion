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
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../widgets/backup_dialog.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 20.0),
                    child: IconButton(
                      icon: Icon(PhosphorIcons.floppyDisk, size: 28, color: Theme.of(context).colorScheme.primary),
                      tooltip: "Kopia zapasowa",
                      onPressed: () async {
                        bool? didImport = await showDialog<bool>(
                          context: context,
                          builder: (context) => const BackupDialog(),
                        );

                        if (!mounted) return;
                        
                        if (didImport == true) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                _buildHeader(context),
                _buildCitiesList(),
                const SizedBox(height: 80),
              ],
            ),
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
        const SizedBox(height: 10),
        Text(
          "Zarządzaj swoją Simsową populacją",
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        Divider(
          height: 40,
          thickness: 2,
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
          indent: 40,
          endIndent: 40,
        ),
      ],
    );
  }

  Widget _buildCitiesList() {
    if (DataService.cities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Icon(PhosphorIcons.mapTrifold, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 15),
            Text(
              "Witaj w Sims Companion!",
              style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 5),
            Text(
              "Kliknij '+' na dole, aby założyć\nswoje pierwsze miasto.",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(fontSize: 14, color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
      );
    }

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