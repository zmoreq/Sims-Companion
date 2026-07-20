import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/city.dart';
import '../models/house.dart';
import '../models/resident.dart';
import '../models/sim_event.dart';
import '../models/event_type.dart';
import '../services/data_service.dart';
import '../widgets/bottom_nav.dart';
import 'cities_page.dart';
import 'stats_page.dart';
import 'generator_page.dart';
import 'resident_details_page.dart';

class DiaryEntry {
  final Resident resident;
  final SimEvent event;

  DiaryEntry({required this.resident, required this.event});
}

class DiaryPage extends StatefulWidget {
  final String returnRoute;

  const DiaryPage({super.key, required this.returnRoute});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  City? selectedCity;
  House? selectedHouse;
  bool showCemeteryOnly = false;

  @override
  void initState() {
    super.initState();
    if (DataService.cities.isNotEmpty) {
      selectedCity = DataService.cities.first;
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
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => StatsPage(isGlobal: true, returnRoute: widget.returnRoute)),
        );
      case 2:
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GeneratorPage(returnRoute: widget.returnRoute)),
        );
      case 4:
        break;
    }
  }

  List<DiaryEntry> _getFilteredEvents() {
    if (selectedCity == null) return [];

    List<DiaryEntry> allEvents = [];

    if (showCemeteryOnly) {
      for (var deadResident in selectedCity!.deceased) {
        for (var event in deadResident.events) {
          allEvents.add(DiaryEntry(resident: deadResident, event: event));
        }
      }
    } else if (selectedHouse != null) {
      for (var resident in selectedHouse!.residents) {
        for (var event in resident.events) {
          allEvents.add(DiaryEntry(resident: resident, event: event));
        }
      }
    } else {
      for (var house in selectedCity!.houses) {
        for (var resident in house.residents) {
          for (var event in resident.events) {
            allEvents.add(DiaryEntry(resident: resident, event: event));
          }
        }
      }
      for (var deadResident in selectedCity!.deceased) {
        for (var event in deadResident.events) {
          allEvents.add(DiaryEntry(resident: deadResident, event: event));
        }
      }
    }

    allEvents.sort((a, b) {
      int turnComparison = b.event.houseTurn.compareTo(a.event.houseTurn);
      if (turnComparison != 0) {
        return turnComparison; 
      }
      return b.event.houseDay.compareTo(a.event.houseDay); 
    });
    
    return allEvents;
  }

  EventType _getEventTypeInfo(String typeId) {
    return DataService.eventTypes.firstWhere(
      (type) => type.id == typeId,
      orElse: () => EventType(id: 'unknown', name: 'Nieznane', iconKey: 'star', colorValue: 0xFF9E9E9E),
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = _getFilteredEvents();

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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text("Kronika Wydarzeń", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildCitySelector(),
            _buildHouseSelector(),
            const Divider(),
            Expanded(
              child: events.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return _buildEventCard(events[index]);
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: 4,
          onTap: _onTapped,
        ),
      ),
    );
  }

  Widget _buildCitySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                  showCemeteryOnly = false;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHouseSelector() {
    if (selectedCity == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text("Wszystko"),
            selected: selectedHouse == null && !showCemeteryOnly, // 🟢
            selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            labelStyle: TextStyle(
              color: selectedHouse == null && !showCemeteryOnly ? Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            onSelected: (_) => setState(() {
              selectedHouse = null;
              showCemeteryOnly = false; // 🟢
            }),
          ),
          const SizedBox(width: 10),
          
          ...selectedCity!.houses.map((house) {
            final isSelected = selectedHouse == house && !showCemeteryOnly;
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
                onSelected: (_) => setState(() {
                  selectedHouse = house;
                  showCemeteryOnly = false;
                }),
              ),
            );
          }),

          ChoiceChip(
            label: Row(
              children: [
                Icon(
                  PhosphorIcons.church, 
                  size: 16, 
                  color: showCemeteryOnly ? Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.onSurface
                ),
                const SizedBox(width: 6),
                const Text("Cmentarz"),
              ],
            ),
            selected: showCemeteryOnly,
            selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            labelStyle: TextStyle(
              color: showCemeteryOnly ? Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            onSelected: (_) => setState(() {
              selectedHouse = null;
              showCemeteryOnly = true; // 🟢
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(PhosphorIcons.bookOpenText, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 15),
          Text(
            "Brak zapisów w kronice.",
            style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(DiaryEntry entry) {
    final eventType = _getEventTypeInfo(entry.event.eventTypeId);
    final isDead = entry.resident.house == null;
    final houseName = entry.resident.house?.name ?? "Cmentarz";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ResidentDetailsPage(resident: entry.resident)),
            ).then((_) => setState(() {}));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(eventType.colorValue).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(eventType.colorValue), width: 2),
                  ),
                  child: Center(
                    child: Icon(
                      _getIconFromKey(eventType.iconKey),
                      color: Color(eventType.colorValue),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventType.name,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${entry.resident.name} ${entry.resident.lastName}",
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDead ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            isDead ? PhosphorIcons.church : PhosphorIcons.house, 
                            size: 12,
                            color: Theme.of(context).colorScheme.outline
                          ),
                          const SizedBox(width: 6),
                          Text(
                            houseName,
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "TURA",
                        style: GoogleFonts.quicksand(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Text(
                        "${entry.event.houseTurn}-${entry.event.houseDay}",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconFromKey(String key) {
    switch (key) {
      case 'baby': return PhosphorIcons.baby;
      case 'heart': return PhosphorIcons.heart;
      case 'briefcase': return PhosphorIcons.briefcase;
      case 'trendUp': return PhosphorIcons.trendUp;
      case 'house': return PhosphorIcons.house;
      case 'skull': return PhosphorIcons.skull;
      case 'church': return PhosphorIcons.church;
      default: return PhosphorIcons.star;
    }
  }
}