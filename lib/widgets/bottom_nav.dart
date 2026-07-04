import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(GoogleFonts.quicksand(fontSize: 12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          selectedItemColor: Theme.of(context).colorScheme.onSecondaryContainer,
          unselectedItemColor: Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha: 0.6),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: currentIndex == 2 ? 0 : currentIndex, 
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.house()),
              activeIcon: Icon(PhosphorIcons.house(PhosphorIconsStyle.bold)),
              label: 'Główna',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.chartBar()),
              activeIcon: Icon(PhosphorIcons.chartBar(PhosphorIconsStyle.bold)),
              label: 'Statystyki',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  PhosphorIcons.plus(PhosphorIconsStyle.bold), 
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              label: 'Dodaj',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.magicWand()),
              activeIcon: Icon(PhosphorIcons.magicWand(PhosphorIconsStyle.bold)),
              label: 'Generator',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.book()),
              activeIcon: Icon(PhosphorIcons.book(PhosphorIconsStyle.bold)),
              label: 'Kronika',
            ),
          ],
        ),
      ),
    );
  }
}