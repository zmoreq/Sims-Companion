import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/house.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class HouseCard extends StatelessWidget {
  final House house;
  final VoidCallback? onTap;
  final VoidCallback? onAddDay;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  HouseCard({
    required this.house,
    required this.onTap,
    required this.onAddDay,
    required this.onDelete,
    required this.onEdit,

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
              title: const Text('Edytuj nazwę'),
              onTap: () {
                Navigator.of(context).pop();
                onEdit?.call();
              },
            ),
            
            ListTile(
              leading: Icon(PhosphorIcons.trash, color: Theme.of(context).colorScheme.error),
              title: Text('Usuń dom', style: TextStyle(color: Theme.of(context).colorScheme.error)),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 85,
          color: Theme.of(context).colorScheme.onSecondary,
          child: Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    onLongPress: () => _showOptions(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
                          child: Icon( PhosphorIcons.houseBold, size: 43, color: Theme.of(context).colorScheme.primary),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.translate(
                                offset: Offset(-3, 0),
                                child: Text(house.name, style: GoogleFonts.fredoka(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 5.0,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer),
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                              Divider(
                                height: 7,
                                thickness: 2,
                                endIndent: 10,
                                color: Theme.of(context).colorScheme.surfaceTint,
                              ),
                              SizedBox(height: 3),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                Icon( PhosphorIcons.diamondBold, size: 19, color: Theme.of(context).colorScheme.primary),
                                SizedBox(width: 10),
                                Text("${house.population}", style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 2, color: Theme.of(context).colorScheme.onSecondaryContainer)),
                                
                                SizedBox(width: 35),
                          
                                Icon(PhosphorIcons.clockBold, size: 19, color: Theme.of(context).colorScheme.primary),
                                SizedBox(width: 10),
                                Text("${house.days}", style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 2, color: Theme.of(context).colorScheme.onSecondaryContainer)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Theme.of(context).colorScheme.secondaryContainer, 
                          child: InkWell(
                            onTap: onAddDay,
                            child: SizedBox(
                              width: 70,
                              height: double.infinity,
                              child: Center(
                                child: Icon(
                                  PhosphorIcons.clockBold,
                                  size: 32, 
                                  color: Theme.of(context).colorScheme.onSecondaryContainer
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}