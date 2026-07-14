import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../models/resident.dart';
import '../widgets/resident_form_dialog.dart';
import '../widgets/resident_notes_dialog.dart';
import '../services/data_service.dart';
import '../models/sim_event.dart';
import '../models/event_type.dart';
import '../widgets/add_sim_event_dialog.dart';

class ResidentDetailsPage extends StatefulWidget {
  final Resident resident;

  const ResidentDetailsPage({super.key, required this.resident});

  @override
  State<ResidentDetailsPage> createState() => _ResidentDetailsPageState();
}

class _ResidentDetailsPageState extends State<ResidentDetailsPage> {
  
  String _translateEyeColor(String? color) {
    const map = {'brown': 'Brązowe', 'blue': 'Niebieskie', 'green': 'Zielone', 'grey': 'Szare', 'red': 'Czerwone'};
    return map[color] ?? 'Nieznane';
  }

  String _translateHairColor(String? color) {
    const map = {'black': 'Czarne', 'brown': 'Brązowe', 'blond': 'Blond', 'ginger': 'Rude', 'grey': 'Szare', 'white': 'Białe'};
    return map[color] ?? 'Nieznane';
  }

  Future<void> _editResident() async {
    final bool? didSave = await showDialog<bool>(
      context: context,
      builder: (context) => ResidentFormDialog(resident: widget.resident),
    );
    
    if (didSave == true) {
      setState(() {});
      DataService.saveData();
    }
  }

  Future<void> _openNotes() async {
    final bool? didSave = await showDialog<bool>(
      context: context,
      builder: (context) => ResidentNotesDialog(resident: widget.resident),
    );
    
    if (didSave == true) {
      DataService.saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          "Karta Postaci",
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.notebookBold),
            onPressed: _openNotes,
            tooltip: "Notatki",
          ),
          IconButton(
            icon: Icon(PhosphorIcons.pencilBold),
            onPressed: _editResident,
            tooltip: "Edytuj Sima",
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildProfileHeader(context),
              const SizedBox(height: 30),
              _buildSectionTitle(context, "Informacje szczegółowe"),
              const SizedBox(height: 15),
              _buildTraitsGrid(context),
              const SizedBox(height: 30),
              _buildSectionTitle(context, "Oś czasu i wydarzenia"),
              const SizedBox(height: 15),
              _buildTimeline(context),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _addEvent,
                  icon: Icon(PhosphorIcons.plusBold),
                  label: const Text("Dodaj wydarzenie"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
            ),
            child: Icon(
              PhosphorIcons.user,
              size: 60,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "${widget.resident.name} ${widget.resident.lastName}",
            style: GoogleFonts.quicksand(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            "${widget.resident.isAdult ? "Dorosły" : "Dziecko"} • Wiek: ${widget.resident.age} lat",
            style: GoogleFonts.quicksand(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildTraitsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildTraitCard(context, PhosphorIcons.starBold, "Aspiracja", widget.resident.traits.aspiration),
        _buildTraitCard(context, PhosphorIcons.eyeBold, "Oczy", _translateEyeColor(widget.resident.traits.eyeColor)),
        _buildTraitCard(context, PhosphorIcons.scissorsBold, "Włosy", _translateHairColor(widget.resident.traits.hairColor)),
        _buildTraitCard(context, PhosphorIcons.houseBold, "Dom", widget.resident.house.name),
      ],
    );
  }

  Widget _buildTraitCard(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.quicksand(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: GoogleFonts.quicksand(fontSize: 14, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    if (widget.resident.events.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(PhosphorIcons.clockLight, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 15),
            Text(
              "Historia życia jest jeszcze pusta.",
              style: GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.resident.events.length,
      itemBuilder: (context, index) {
        final event = widget.resident.events[index];
        final eventType = DataService.eventTypes.firstWhere(
          (e) => e.id == event.eventTypeId,
          orElse: () => EventType(id: 'unknown', name: 'Nieznane wydarzenie', iconKey: 'star', colorValue: 0xFF9E9E9E),
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(eventType.colorValue).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIconFromKey(eventType.iconKey), color: Color(eventType.colorValue)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventType.name,
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (event.description != null && event.description!.isNotEmpty)
                      Text(
                        event.description!,
                        style: GoogleFonts.quicksand(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Wiek: ${event.simAge}", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text("Dzień: ${event.simDays}", style: GoogleFonts.quicksand(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _addEvent() async {
    final SimEvent? newEvent = await showDialog<SimEvent>(
      context: context,
      builder: (context) => AddSimEventDialog(
        currentAge: widget.resident.age,
        currentDays: widget.resident.days,
      ),
    );

    if (newEvent != null) {
      setState(() {
        widget.resident.events.add(newEvent);
      });
      DataService.saveData();
    }
  }

  IconData _getIconFromKey(String key) {
    switch (key) {
      case 'baby': return PhosphorIcons.baby;
      case 'heart': return PhosphorIcons.heart;
      case 'briefcase': return PhosphorIcons.briefcase;
      case 'trendUp': return PhosphorIcons.trendUp;
      case 'house': return PhosphorIcons.house;
      default: return PhosphorIcons.star;
    }
  }
}