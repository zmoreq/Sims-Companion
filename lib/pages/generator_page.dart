import 'package:flutter/material.dart';
import '../models/city.dart';
import '../widgets/bottom_nav.dart';
import 'diary_page.dart';
import 'stats_page.dart';
import 'cities_page.dart';

class GeneratorPage extends StatefulWidget {
  final City? city; 
  final bool isGlobal;
  final String returnRoute;

  const GeneratorPage({
    super.key, 
    this.city, 
    this.isGlobal = false, 
    required this.returnRoute
  });

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  
  void _onTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const CitiesPage()),
          (route) => false, 
        );
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StatsPage(isGlobal: true, returnRoute: widget.returnRoute),
          ),
        );
      case 2:
        break;
      case 3:
        break;
      case 4:
        Navigator.of(context).push(
           MaterialPageRoute(builder: (context) => DiaryPage(returnRoute: widget.returnRoute)),
        );
    }
  }

  void _handleBackNavigation() {
    if (widget.returnRoute == "/") {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const CitiesPage()),
        (route) => false, 
      );
    } else {
      Navigator.of(context).popUntil(ModalRoute.withName(widget.returnRoute)); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Generator")),
        body: _buildBody(),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: 3, 
          onTap: _onTapped,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Text(
        widget.city != null 
            ? "Generator miasta: ${widget.city!.name}" 
            : "Generator Globalny"
      ),
    );
  }
}