import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/resident.dart';
import '../widgets/resident_notes_dialog.dart';
import '../services/data_service.dart';

class ResidentTile extends StatelessWidget {
  final Resident resident;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ResidentTile({
    super.key,
    required this.resident,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(PhosphorIcons.pencil),
                title: const Text('Edytuj mieszkańca'),
                onTap: () {
                  Navigator.of(context).pop();
                  onEdit?.call();
                },
              ),
              ListTile(
                leading: Icon(PhosphorIcons.trash, color: Theme.of(context).colorScheme.error),
                title: Text('Usuń', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                onTap: () {
                  Navigator.of(context).pop();
                  onDelete?.call();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showNotesDialog(BuildContext context) async {
    final bool? didSave = await showDialog(
      context: context,
      builder: (context) => ResidentNotesDialog(resident: resident),
    );

    if (didSave == true) {
      DataService.saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        onTap: onTap,
        onLongPress: () => _showOptions(context),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12), 
          ),
          child: Center(
            child: Icon(
              PhosphorIcons.userBold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            )
          ),
        ),
        title: Text(
          "${resident.name} ${resident.lastName}",
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          "${resident.isAdult ? "Dorosły" : "Dziecko"}  •  ${resident.age} lat  •  ${resident.traits.aspiration}",
          style: GoogleFonts.quicksand(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: IconButton(
          icon: Icon(PhosphorIcons.notebookBold, color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            _showNotesDialog(context);
          },
        ),
      ),
    );
  }
}