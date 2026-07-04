import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/resident.dart';

class ResidentTile extends StatelessWidget {
  final Resident resident;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ResidentTile({
    super.key,
    required this.resident,
    this.onTap,
    this.onDelete,
  });

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
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12), 
          ),
          child: Center(
            child: Icon(
              PhosphorIcons.user(PhosphorIconsStyle.bold),
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
          icon: Icon(PhosphorIcons.trash(), color: Theme.of(context).colorScheme.error),
          onPressed: onDelete,
        ),
      ),
    );
  }
}