import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/city.dart';
import '../models/resident.dart';
import 'resident_details_page.dart';
import '../services/data_service.dart';
import '../widgets/remove_dialog.dart';

class CemeteryPage extends StatefulWidget {
  final City city;

  const CemeteryPage({super.key, required this.city});

  @override
  State<CemeteryPage> createState() => _CemeteryPageState();
}

class _CemeteryPageState extends State<CemeteryPage> {
  Future<void> _deleteSoulPermanently(Resident deadSim) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => RemoveDialog(
        content: "Czy na pewno chcesz na zawsze wymazać ${deadSim.name} z historii miasta? Ta akcja jest nieodwracalna.",
      ),
    );

    if (confirmDelete == true) {
      setState(() {
        widget.city.deceased.remove(deadSim);
      });
      DataService.saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        title: Text(
          "Archiwum Zmarłych",
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: widget.city.deceased.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIcons.churchFill, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 20),
                  Text(
                    "Cmentarz jest pusty.",
                    style: GoogleFonts.quicksand(fontSize: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  Text(
                    "Nikt w tym mieście jeszcze nie umarł.",
                    style: GoogleFonts.quicksand(fontSize: 16, color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.city.deceased.length,
              itemBuilder: (context, index) {
                final deadSim = widget.city.deceased[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResidentDetailsPage(resident: deadSim),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    onLongPress: () => _deleteSoulPermanently(deadSim),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant.withAlpha(100),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          PhosphorIcons.churchFill,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    title: Text(
                      "${deadSim.name} ${deadSim.lastName}",
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      "Odszedł w wieku ${deadSim.age} lat",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(PhosphorIcons.caretRightBold, color: Theme.of(context).colorScheme.outline),
                  ),
                );
              },
            ),
    );
  }
}