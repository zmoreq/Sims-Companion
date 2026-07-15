import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/event_type.dart';
import '../services/data_service.dart';
import 'remove_dialog.dart';

class ManageEventTypesDialog extends StatefulWidget {
  const ManageEventTypesDialog({super.key});

  @override
  State<ManageEventTypesDialog> createState() => _ManageEventTypesDialogState();
}

class _ManageEventTypesDialogState extends State<ManageEventTypesDialog> {
  Future<void> _deleteEventType(EventType type) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => RemoveDialog(
        content: "Usunąć szablon '${type.name}'? Wydarzenia u Simów korzystające z niego otrzymają domyślny wygląd.",
      ),
    );

    if (confirm == true) {
      setState(() {
        DataService.eventTypes.remove(type);
      });
      DataService.saveData();
    }
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Zarządzaj szablonami",
                  style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
                IconButton(
                  icon: Icon(PhosphorIcons.x),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            const Divider(),
            if (DataService.eventTypes.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Brak szablonów do zarządzania."),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: DataService.eventTypes.length,
                  itemBuilder: (context, index) {
                    final type = DataService.eventTypes[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(type.colorValue)),
                      ),
                      title: Text(type.name, style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
                      trailing: IconButton(
                        icon: Icon(PhosphorIcons.trash, color: Theme.of(context).colorScheme.error),
                        onPressed: () => _deleteEventType(type),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}