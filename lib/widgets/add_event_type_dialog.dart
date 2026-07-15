import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/event_type.dart';
import '../services/data_service.dart';
import '../utils/snackbar_utils.dart';

class AddEventTypeDialog extends StatefulWidget {
  const AddEventTypeDialog({super.key});

  @override
  State<AddEventTypeDialog> createState() => _AddEventTypeDialogState();
}

class _AddEventTypeDialogState extends State<AddEventTypeDialog> {
  final TextEditingController nameController = TextEditingController();
  
  final Map<String, IconData> availableIcons = {
    'star': PhosphorIcons.starFill,
    'baby': PhosphorIcons.babyFill,
    'heart': PhosphorIcons.heartFill,
    'briefcase': PhosphorIcons.briefcaseFill,
    'trendUp': PhosphorIcons.trendUpFill,
    'house': PhosphorIcons.houseFill,
    'skull': PhosphorIcons.skullFill,
    'car': PhosphorIcons.carProfileFill,
    'graduationCap': PhosphorIcons.graduationCapFill,
  };

  String selectedIconKey = 'star';
  int selectedColor = 0xFF9E9E9E; // Domyślnie szary

  final List<int> colors = [
    0xFFF44336, // Czerwony
    0xFFE91E63, // Różowy
    0xFF9C27B0, // Fioletowy
    0xFF3F51B5, // Indygo
    0xFF2196F3, // Niebieski
    0xFF4CAF50, // Zielony
    0xFFFFEB3B, // Żółty
    0xFFFF9800, // Pomarańczowy
    0xFF795548, // Brązowy
    0xFF9E9E9E, // Szary
  ];

  @override
  void dispose() {
    nameController.dispose();
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
                Icon(PhosphorIcons.folderPlus, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  "Nowy szablon",
                  style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nazwa wydarzenia"),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: selectedIconKey,
              decoration: const InputDecoration(labelText: "Ikona"),
              items: availableIcons.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(entry.value),
                      const SizedBox(width: 10),
                      Text(entry.key),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) setState(() => selectedIconKey = newValue);
              },
            ),
            const SizedBox(height: 15),
            Text("Kolor", style: GoogleFonts.quicksand(fontSize: 14)),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == color ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: selectedColor == color ? [const BoxShadow(color: Colors.black26, blurRadius: 4)] : [],
                    ),
                  ),
                );
              }).toList(),
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
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      SnackbarUtils.showError(context, "Podaj nazwę szablonu!");
                      return;
                    }
                    
                    final newEventType = EventType(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      iconKey: selectedIconKey,
                      colorValue: selectedColor,
                    );
                    
                    DataService.eventTypes.add(newEventType);
                    DataService.saveData();

                    Navigator.of(context).pop(newEventType);
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