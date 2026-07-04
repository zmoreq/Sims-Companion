import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'cities_page.dart';
import 'stats_page.dart';
import 'generator_page.dart';
import 'diary_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CitiesPage(),
    const StatsPage(isGlobal: true, returnRoute: "/"), 
    const SizedBox(),
    const GeneratorPage(returnRoute: "/"),
    const DiaryPage(returnRoute: "/"),
  ];

  void _onNavTapped(int index) {
    if (index == 2) {
      print("Kliknięto przycisk Dodaj!");
      return; 
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}