import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/sim_event.dart';
import '../models/event_type.dart';
import '../models/resident.dart';
import '../models/house.dart';
import '../services/data_service.dart';
import '../utils/snackbar_utils.dart';

class AddSimEventDialog extends StatefulWidget {
  final Resident resident;

  const AddSimEventDialog({super.key, required this.resident});

  @override
  State<AddSimEventDialog> createState() => _AddSimEventDialogState();
}

class _AddSimEventDialogState extends State<AddSimEventDialog> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController newHouseNameController = TextEditingController();
  
  EventType? selectedEventType;
  String moveOption = 'existing';
  House? selectedTargetHouse;

  @override
  void initState() {
    super.initState();
    if (DataService.eventTypes.isNotEmpty) {
      selectedEventType = DataService.eventTypes.first;
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    newHouseNameController.dispose();
    super.dispose();
  }

  bool get _isMoveEvent => 
      selectedEventType?.id == 'move' || selectedEventType?.name.toLowerCase() == 'przeprowadzka';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(PhosphorIcons.calendarPlus, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  "Dodaj wydarzenie",
                  style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),

            DropdownButtonFormField<EventType>(
              initialValue: selectedEventType,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: "Typ wydarzenia",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: DataService.eventTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      CircleAvatar(radius: 6, backgroundColor: Color(type.colorValue)),
                      const SizedBox(width: 10),
                      Text(type.name, style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedEventType = val),
            ),

            if (_isMoveEvent) ...[
              const SizedBox(height: 15),
              Text(
                "Cel przeprowadzki",
                style: GoogleFonts.quicksand(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'existing', label: Text('Wybierz dom'), icon: Icon(PhosphorIcons.house)),
                    ButtonSegment(value: 'new', label: Text('Nowy dom'), icon: Icon(PhosphorIcons.plusCircle)),
                  ],
                  selected: {moveOption},
                  onSelectionChanged: (val) => setState(() => moveOption = val.first),
                ),
              ),
              const SizedBox(height: 12),

              if (moveOption == 'existing')
                DropdownButtonFormField<House>(
                  initialValue: selectedTargetHouse,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: "Dom docelowy",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  items: widget.resident.city.houses
                      .where((h) => h != widget.resident.house)
                      .map((h) {
                    bool isSameTurn = h.turns == widget.resident.house?.turns;
                    bool isFull = h.population >= h.maxResidents;
                    bool canMove = isSameTurn && !isFull;

                    String subtitle = "";
                    if (!isSameTurn) {
                      subtitle = " (inna tura)";
                    }
                    else if (isFull) {
                      subtitle = " (brak miejsc)";
                    }

                    return DropdownMenuItem(
                      value: h,
                      enabled: canMove,
                      child: Text(
                        "${h.name}$subtitle",
                        style: TextStyle(
                          color: canMove ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedTargetHouse = val),
                )
              else
                TextField(
                  controller: newHouseNameController,
                  decoration: const InputDecoration(
                    labelText: "Nazwa nowego domu",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
            ],

            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Opis (opcjonalnie)",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Anuluj"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _saveEvent,
                  child: const Text("Zapisz"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _saveEvent() {
    if (selectedEventType == null) return;

    House? finalHouse;

    if (_isMoveEvent) {
      if (moveOption == 'existing') {
        if (selectedTargetHouse == null) {
          SnackbarUtils.showError(context, "Wybierz dom docelowy!");
          return;
        }
        finalHouse = selectedTargetHouse;
      } else {
        if (newHouseNameController.text.trim().isEmpty) {
          SnackbarUtils.showError(context, "Wpisz nazwę nowego domu!");
          return;
        }
        finalHouse = House(
          name: newHouseNameController.text.trim(),
          city: widget.resident.city,
          turns: widget.resident.house?.turns ?? widget.resident.city.turns,
          days: widget.resident.house?.days ?? 0,
        );
        widget.resident.city.houses.add(finalHouse);
      }

      widget.resident.house?.removeResident(widget.resident);
      finalHouse!.addResident(widget.resident);
      widget.resident.house = finalHouse;
    }

    String? desc = descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null;
    if (_isMoveEvent && desc == null) {
      desc = "Przeprowadzka do: ${finalHouse?.name}";
    }

    Navigator.pop(
      context,
      SimEvent(
        eventTypeId: selectedEventType!.id,
        simAge: widget.resident.age,
        houseDay: widget.resident.house?.days ?? 0,
        houseTurn: widget.resident.house?.turns ?? widget.resident.city.turns,
        description: desc,
      ),
    );
  }
}