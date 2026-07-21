import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../services/data_service.dart';
import '../utils/snackbar_utils.dart';

class BackupDialog extends StatefulWidget {
  const BackupDialog({super.key});

  @override
  State<BackupDialog> createState() => _BackupDialogState();
}

class _BackupDialogState extends State<BackupDialog> {
  final TextEditingController _importController = TextEditingController();

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  void _exportData() async {
    String backupData = DataService.exportBackup();
    
    await Clipboard.setData(ClipboardData(text: backupData));
    
    if (!mounted) return;
    SnackbarUtils.showError(context, "Zapis skopiowany! Wklej go teraz do swoich Notatek.");
    Navigator.of(context).pop();
  }

  void _importData() async {
    String textToImport = _importController.text.trim();
    if (textToImport.isEmpty) return;

    bool success = await DataService.importBackup(textToImport);
    
    if (!mounted) return;
    if (success) {
      SnackbarUtils.showError(context, "Kopia zapasowa przywrócona pomyślnie!");
      Navigator.of(context).pop(true); 
    } else {
      SnackbarUtils.showError(context, "Błędny kod zapisu. Upewnij się, że skopiowałeś całość.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(PhosphorIcons.floppyDisk, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  Text(
                    "Kopia Zapasowa",
                    style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Text(
                "Stwórz kopię",
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 5),
              Text(
                "Skopiuj swoje miasto w formie bezpiecznego kodu tekstowego. Wklej ten kod do Notatek lub wyślij sobie na maila.",
                style: GoogleFonts.quicksand(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _exportData,
                  icon: const Icon(PhosphorIcons.copy),
                  label: const Text("Skopiuj kod zapisu"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              
              const Divider(height: 30),

              Text(
                "Przywróć miasto",
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _importController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Wklej tutaj swój kod zapisu...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _importData,
                  icon: const Icon(PhosphorIcons.download),
                  label: const Text("Przywróć z kodu"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Zamknij"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}