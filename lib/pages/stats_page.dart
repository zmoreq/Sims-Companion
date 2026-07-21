import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/city.dart';
import '../models/house.dart';
import '../services/data_service.dart';
import '../services/stats_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/stat_box.dart';
import 'generator_page.dart';
import 'cities_page.dart';
import 'diary_page.dart';

class StatsPage extends StatefulWidget {
  final City? city;
  final bool isGlobal;
  final String returnRoute;

  const StatsPage({super.key, this.city, this.isGlobal = false, required this.returnRoute});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  City? selectedCity;
  House? selectedHouse;

  @override
  void initState() {
    super.initState();
    if (widget.city != null) {
      selectedCity = widget.city;
    } else if (DataService.cities.isNotEmpty) {
      selectedCity = DataService.cities.first;
    }
  }

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'brown': return Colors.brown;
      case 'darkblue': return Colors.blue[900]!;
      case 'lightblue': return Colors.lightBlue;
      case 'green': return Colors.green;
      case 'grey': return Colors.grey;
      case 'red': return Colors.red;
      case 'black': return Colors.black;
      case 'blond': return const Color.fromARGB(255, 245, 217, 61);
      case 'white': return Colors.white;
      case 'ginger': return const Color.fromARGB(255, 240, 130, 5);
      default: return Colors.transparent;
    }
  }

  void _onTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const CitiesPage()),
          (route) => false,
        );
      case 1:
        break;
      case 2:
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GeneratorPage(returnRoute: widget.returnRoute)),
        );
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DiaryPage(returnRoute: widget.returnRoute)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        if (widget.returnRoute == "/") {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const CitiesPage()),
            (route) => false,
          );
        } else {
          Navigator.of(context).popUntil(ModalRoute.withName(widget.returnRoute));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Statystyki")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildCitySelector(),
              _buildHouseSelector(),
              const SizedBox(height: 10),
              _buildGeneralStatsRow(),
              _buildPlaceholderCard(),
              _buildChartsRow(),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: 1,
          onTap: _onTapped,
        ),
      ),
    );
  }

  Widget _buildCitySelector() {
    if (DataService.cities.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: DataService.cities.map((city) {
          final isSelected = selectedCity == city;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(city.name),
              selected: isSelected,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              onSelected: (_) {
                setState(() {
                  selectedCity = city;
                  selectedHouse = null;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHouseSelector() {
    if (selectedCity == null || selectedCity!.houses.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text("Wszystkie domy"),
            selected: selectedHouse == null,
            selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            labelStyle: TextStyle(
              color: selectedHouse == null ? Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            onSelected: (_) => setState(() => selectedHouse = null),
          ),
          const SizedBox(width: 10),
          ...selectedCity!.houses.map((house) {
            final isSelected = selectedHouse == house;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ChoiceChip(
                label: Text(house.name),
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                labelStyle: TextStyle(
                  color: isSelected ? Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (_) => setState(() => selectedHouse = house),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGeneralStatsRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: StatBox(
            label: "Populacja", 
            value: StatsService.getTotalPopulation(selectedCity: selectedCity, selectedHouse: selectedHouse).toString(), 
            icon: PhosphorIcons.usersBold
          )),
          const SizedBox(width: 10),
          Expanded(child: StatBox(
            label: "Domy", 
            value: StatsService.getTotalHouses(selectedCity: selectedCity).toString(),
            icon: PhosphorIcons.houseBold
          )),
          const SizedBox(width: 10),
          Expanded(child: StatBox(
            label: "Średni wiek", 
            value: StatsService.getAverageAge(selectedCity: selectedCity, selectedHouse: selectedHouse).toString(), 
            icon: PhosphorIcons.calendarBold
          )),
        ],
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Więcej statystyk wkrótce!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildChartsRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildDonutChartCard(
              title: "Kolor oczu",
              possibleColors: StatsService.possibleEyeColors,
              getValue: (color) => StatsService.getEyeColorValueForChart(color, selectedCity: selectedCity, selectedHouse: selectedHouse),
              getPercentage: (color) => StatsService.getEyeColorPercentageForChart(color, selectedCity: selectedCity, selectedHouse: selectedHouse),
              getMissingValue: () => StatsService.getResidentsWithNoEyeColor(selectedCity: selectedCity, selectedHouse: selectedHouse),
              getMissingPercentage: () => StatsService.getResidentsWithNoEyeColorPercentage(selectedCity: selectedCity, selectedHouse: selectedHouse),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDonutChartCard(
              title: "Kolor włosów",
              possibleColors: StatsService.possibleHairColors,
              getValue: (color) => StatsService.getHairColorValueForChart(color, selectedCity: selectedCity, selectedHouse: selectedHouse),
              getPercentage: (color) => StatsService.getHairColorPercentageForChart(color, selectedCity: selectedCity, selectedHouse: selectedHouse),
              getMissingValue: () => StatsService.getResidentsWithNoHairColor(selectedCity: selectedCity, selectedHouse: selectedHouse),
              getMissingPercentage: () => StatsService.getResidentsWithNoHairColorPercentage(selectedCity: selectedCity, selectedHouse: selectedHouse),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartCard({
    required String title,
    required List<String> possibleColors,
    required int Function(String) getValue,
    required String Function(String) getPercentage,
    required int Function() getMissingValue,
    required String Function() getMissingPercentage,
  }) {
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(title, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 50,
                    sectionsSpace: 5,
                    startDegreeOffset: 0,
                    sections: [
                      ...possibleColors
                          .where((colorName) => getValue(colorName) > 0)
                          .map((colorName) {
                        Color actualColor = _getColorFromString(colorName);
                        return PieChartSectionData(
                          color: actualColor,
                          value: getValue(colorName).toDouble(),
                          title: getPercentage(colorName),
                          radius: 35,
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ThemeData.estimateBrightnessForColor(actualColor) == Brightness.light ? Colors.black : Colors.white,
                          ),
                        );
                      }),
                      if (getMissingValue() > 0)
                        PieChartSectionData(
                          color: Colors.white24,
                          value: getMissingValue().toDouble(),
                          title: "Brak: ${getMissingPercentage()}",
                          radius: 35,
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ThemeData.estimateBrightnessForColor(Colors.white24) == Brightness.light ? Colors.black : Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}