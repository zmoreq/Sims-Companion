import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/house.dart';
import '../models/city.dart';
import '../widgets/house_card.dart';
import 'stats_page.dart';
import 'generator_page.dart';
import 'diary_page.dart';
import '../widgets/bottom_nav.dart';
import 'house_page.dart';
import '../services/data_service.dart';
import '../utils/snackbar_utils.dart';
import '../widgets/remove_dialog.dart';

class CityPage extends StatefulWidget {
  final City city;
  String get cityName => city.name;

  const CityPage({super.key, required this.city});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  final int _selectedIndex = 0;

  void _onTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).popUntil((route) => route.isFirst);
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => StatsPage(isGlobal: true, returnRoute: "/city")),
        );
      case 2:
        _showAddHouseDialog();
      case 3:
        Navigator.of(context).push(
           MaterialPageRoute(builder: (context) => const GeneratorPage(returnRoute: "/city")),
        );
      case 4:
        Navigator.of(context).push(
           MaterialPageRoute(builder: (context) => const DiaryPage(returnRoute: "/city")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCityHeader(),
            const SizedBox(height: 15),
            _buildHousesList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onTapped,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      actions: [
        IconButton(
          icon: Icon(PhosphorIcons.gearBold),
          onPressed: () {
            // TODO: Ustawienia miasta
          },
        )
      ],
    );
  }

  Widget _buildCityHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Text(
            widget.cityName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  letterSpacing: 5.0,
                ),
          ),
          Text(
            "Tutaj możesz zarządzać swoim miastem",
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHousesList() {
    return Column(
      children: widget.city.houses.map((houseObject) {
        return HouseCard(
          house: houseObject,
          onTap: () => _navigateToHouse(houseObject),
          onAddDay: () => _addDayToHouse(houseObject),
          onDelete: () => _deleteHouse(houseObject),
          onEdit: () {
            print("Edit ${houseObject.name}");
            // TODO: Logika edycji nazwy domu (analogiczna jak w CitiesPage)
          },
        );
      }).toList(),
    );
  }

  Future<void> _navigateToHouse(House houseObject) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HousePage(house: houseObject),
        settings: const RouteSettings(name: "/house"),
      ),
    );
    setState(() {});
  }

  Future<void> _deleteHouse(House houseObject) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => RemoveDialog(
        content: "Czy na pewno chcesz usunąć dom ${houseObject.name}?",
      ),
    );

    if (confirmDelete == true) {
      setState(() {
        widget.city.removeHouse(houseObject);
      });
      DataService.saveData();
    }
  }

  void _addDayToHouse(House houseObject) {
    setState(() {
      houseObject.incrementDays();
      for (var resident in houseObject.residents) {
        resident.incrementDays();
      }
    });
    DataService.saveData();
  }

  Future<void> _showAddHouseDialog() async {
    final TextEditingController nameController = TextEditingController();

    final String? houseName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dodaj nowy dom"),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: "Nazwa domu"),
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
                  SnackbarUtils.showError(context, "Nazwa domu nie może być pusta!");
                }
              },
              child: const Text('Dodaj'),
            ),
          ],
        );
      }
    );

    Future.delayed(const Duration(milliseconds: 500), () => nameController.dispose());

    if (houseName != null && houseName.isNotEmpty) {
      setState(() {
        widget.city.addHouse(House(name: houseName, city: widget.city));
      });
      DataService.saveData();
    }
  }
}