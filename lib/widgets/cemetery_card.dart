import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/city.dart';

class CemeteryCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;

  const CemeteryCard({
    super.key,
    required this.city,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 85,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
                    child: Icon(
                      PhosphorIcons.churchBold,
                      size: 43, 
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(-3, 0),
                          child: Text(
                            "Cmentarz",
                            style: GoogleFonts.fredoka(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 5.0,
                              // Szary tekst dla spójności
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Divider(
                          height: 7,
                          thickness: 2,
                          endIndent: 30,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              PhosphorIcons.usersBold, 
                              size: 19, 
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${city.deceased.length} dusz",
                              style: GoogleFonts.fredoka(
                                fontSize: 16, 
                                fontWeight: FontWeight.w500, 
                                letterSpacing: 2, 
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}