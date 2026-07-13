import 'package:flutter/material.dart';
import 'package:namer_app/services/stats_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/city.dart';
import '../widgets/bottom_nav.dart';
import 'generator_page.dart';
import 'cities_page.dart';
import 'diary_page.dart';
import '../services/data_service.dart';
import '../widgets/stat_box.dart';
import 'package:fl_chart/fl_chart.dart';

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

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'brown': return Colors.brown;
      case 'blue': return Colors.blue;
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
              const SizedBox(height: 10),
              _buildGeneralStatsRow(),
              _buildPlaceholderCard(),
              _buildChartsRow(),
              const SizedBox(height: 20), // Margines dolny
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _buildFilterChip("Wszystko", isSelected: selectedCity == null, onSelect: () => setState(() => selectedCity = null)),
          const SizedBox(width: 10),
          ...DataService.cities.map((city) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _buildFilterChip(
                city.name, 
                isSelected: selectedCity == city, 
                onSelect: () => setState(() => selectedCity = city)
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isSelected, required VoidCallback onSelect}) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: TextStyle(
        color: isSelected 
            ? Theme.of(context).colorScheme.onTertiaryContainer 
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      onSelected: (_) => onSelect(),
    );
  }

  Widget _buildGeneralStatsRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: StatBox(
            label: "Populacja", 
            value: StatsService.getTotalPopulation(selectedCity: selectedCity).toString(), 
            icon: PhosphorIcons.users(PhosphorIconsStyle.bold)
          )),
          const SizedBox(width: 10),
          Expanded(child: StatBox(
            label: "Domy", 
            value: StatsService.getTotalHouses(selectedCity: selectedCity).toString(), 
            icon: PhosphorIcons.house(PhosphorIconsStyle.bold)
          )),
          const SizedBox(width: 10),
          Expanded(child: StatBox(
            label: "Średni wiek", 
            value: StatsService.getAverageAge(selectedCity: selectedCity).toString(), 
            icon: PhosphorIcons.calendar(PhosphorIconsStyle.bold)
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
              getValue: (color) => StatsService.getEyeColorValueForChart(color, selectedCity: selectedCity),
              getPercentage: (color) => StatsService.getEyeColorPercentageForChart(color, selectedCity: selectedCity),
              getMissingValue: () => StatsService.getResidentsWithNoEyeColor(selectedCity: selectedCity),
              getMissingPercentage: () => StatsService.getResidentsWithNoEyeColorPercentage(selectedCity: selectedCity),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDonutChartCard(
              title: "Kolor włosów",
              possibleColors: StatsService.possibleHairColors,
              getValue: (color) => StatsService.getHairColorValueForChart(color, selectedCity: selectedCity),
              getPercentage: (color) => StatsService.getHairColorPercentageForChart(color, selectedCity: selectedCity),
              getMissingValue: () => StatsService.getResidentsWithNoHairColor(selectedCity: selectedCity),
              getMissingPercentage: () => StatsService.getResidentsWithNoHairColorPercentage(selectedCity: selectedCity),
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