import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/sim_event.dart';
import '../models/event_type.dart';
import '../services/data_service.dart';
import '../utils/snackbar_utils.dart';

class AddSimEventDialog extends StatefulWidget {
  final int currentAge;
  final int currentDays;

  const AddSimEventDialog({
    super.key,
    required this.currentAge,
    required this.currentDays,
  });

  @override
  State<AddSimEventDialog> createState() => _AddSimEventDialogState();
}

class _AddSimEventDialogState extends State<AddSimEventDialog> {
  final TextEditingController descriptionController = TextEditingController();
  EventType? selectedEventType;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
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
                  style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (DataService.eventTypes.isEmpty)
              const Text("Brak dostępnych szablonów wydarzeń!")
            else
              DropdownButtonFormField<EventType>(
                initialValue: selectedEventType,
                isExpanded: true,
                decoration: const InputDecoration(labelText: "Typ wydarzenia"),
                items: DataService.eventTypes.map((EventType type) {
                  return DropdownMenuItem<EventType>(
                    value: type,
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(type.colorValue)),
                        ),
                        const SizedBox(width: 10),
                        Text(type.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (EventType? newValue) {
                  setState(() {
                    selectedEventType = newValue;
                  });
                },
              ),
            const SizedBox(height: 15),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Opis (opcjonalnie)",
                hintText: "np. Został dyrektorem w korporacji",
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text("Anuluj"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    if (selectedEventType == null) {
                      SnackbarUtils.showError(context, "Wybierz typ wydarzenia!");
                      return;
                    }
                    Navigator.of(context).pop(
                      SimEvent(
                        eventTypeId: selectedEventType!.id,
                        simAge: widget.currentAge,
                        simDays: widget.currentDays,
                        description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
                      ),
                    );
                  },
                  child: const Text("Zapisz"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}