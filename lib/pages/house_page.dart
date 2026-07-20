import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/house.dart';
import 'stats_page.dart';
import 'generator_page.dart';
import 'diary_page.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/resident_tile.dart';
import '../models/resident.dart';
import '../services/data_service.dart';
import '../widgets/resident_form_dialog.dart';
import '../utils/snackbar_utils.dart';
import '../widgets/remove_dialog.dart';
import 'resident_details_page.dart';
import '../models/sim_event.dart';

class HousePage extends StatefulWidget {
  final House house;
  String get houseName => house.name;

  const HousePage({super.key, required this.house});

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
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
        if (widget.house.population < widget.house.maxResidents) {
          _showAddResidentDialog();
        } else {
          SnackbarUtils.showError(context, "Maksymalna liczba mieszkańców osiągnięta!");
        }
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
            _buildHouseHeader(),
            const SizedBox(height: 5),
            _buildResidentsTitle(),
            const SizedBox(height: 5),
            _buildResidentsList(),
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      actions: [
        IconButton(
          icon: Icon(PhosphorIcons.gearBold),
          onPressed: () {}, // TODO: Ustawienia
        )
      ],
    );
  }

  Widget _buildHouseHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Text(
            widget.houseName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 42,
                  letterSpacing: 5.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          const SizedBox(height: 20),
          _buildDayControls(),
        ],
      ),
    );
  }

  Widget _buildDayControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(PhosphorIcons.minusBold, size: 26, color: Theme.of(context).colorScheme.onPrimary),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: const EdgeInsets.all(12),
          onPressed: _decrementDays,
        ),
        
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  "TURA",
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  "${widget.house.turns}",
                  style: GoogleFonts.quicksand(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Container(
              width: 2,
              height: 40,
              color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                Text(
                  "DZIEŃ",
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  "${widget.house.days}",
                  style: GoogleFonts.quicksand(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),

        IconButton(
          icon: Icon(PhosphorIcons.plusBold, size: 26, color: Theme.of(context).colorScheme.onPrimary),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: const EdgeInsets.all(12),
          onPressed: _incrementDays,
        ),
      ],
    );
  }

  Widget _buildResidentsTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Container(width: 4, height: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            "MIESZKAŃCY (${widget.house.population} / ${widget.house.maxResidents})",
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Theme.of(context).colorScheme.primary,
            )
          ),
        ],
      ),
    );
  }

  Widget _buildResidentsList() {
    if (widget.house.residents.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Icon(PhosphorIcons.houseLine, size: 64, color: Theme.of(context).colorScheme.surfaceContainerHighest),
            const SizedBox(height: 15),
            Text(
              "Ten dom jest pusty.",
              style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 5),
            Text(
              "Kliknij '+' na dolnym pasku,\naby dodać pierwszego mieszkańca.",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(fontSize: 14, color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
      );
    }

    return Column(
      children: widget.house.residents.map((residentObject) {
        return ResidentTile(
          resident: residentObject,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ResidentDetailsPage(resident: residentObject),
              ),
            );
          },
          onEdit: () => _editResident(residentObject),
          onDelete: () => _deleteResident(residentObject),
        );
      }).toList(),
    );
  }

  void _incrementDays() {
    setState(() {
      widget.house.incrementDays();
      for (var resident in widget.house.residents) {
        resident.incrementDays();
      }
    });
    DataService.saveData();
  }

  void _decrementDays() {
    setState(() {
      if (widget.house.days > 0) {
        for (var resident in widget.house.residents) {
          resident.decrementDays();
        }
      }
      widget.house.decrementDays();
    });
    DataService.saveData();
  }

  Future<void> _deleteResident(Resident residentObject) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => RemoveDialog(
        content: "Czy na pewno chcesz usunąć mieszkańca ${residentObject.name} ${residentObject.lastName}?",
      ),
    );

    if (confirmDelete == true) {
      setState(() {
        widget.house.removeResident(residentObject);
      });
      DataService.saveData();
    }
  }

  Future<void> _editResident(Resident residentObject) async {
    final bool? didSave = await showDialog<bool>(
      context: context,
      builder: (context) => ResidentFormDialog(resident: residentObject),
    );
    if (didSave == true) {
      setState(() {});
      DataService.saveData();
    }
  }

  Future<void> _showAddResidentDialog() async {
    final Map<String, dynamic>? residentData = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) => const ResidentFormDialog(),
    );

    if (residentData != null) {
      setState(() {
        Resident newResident = Resident(
          name: residentData["name"],
          lastName: residentData["lastName"],
          age: residentData["age"],
          city: widget.house.city,
          house: widget.house,
        );
        
        newResident.traits.aspiration = residentData["aspiration"];
        newResident.traits.eyeColor = residentData["eyeColor"];
        newResident.traits.hairColor = residentData["hairColor"];

        if (newResident.age == 0) {
          newResident.events.add(
            SimEvent(
              eventTypeId: 'birth', 
              simAge: 0,
              houseDay: 0,
              description: "Witaj na świecie!",
              houseTurn: widget.house.turns
            )
          );
        }

        widget.house.addResident(newResident);
      });
      DataService.saveData(); 
    }
  }
}