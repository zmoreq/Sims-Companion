import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/resident.dart';
import '../utils/snackbar_utils.dart';

class ResidentFormDialog extends StatefulWidget {
  final Resident? resident;

  const ResidentFormDialog({super.key, this.resident});

  @override
  State<ResidentFormDialog> createState() => _ResidentFormDialogState();
}

class _ResidentFormDialogState extends State<ResidentFormDialog> {
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController ageController;

  late String aspiration;
  String? eyeColor;
  String? hairColor;

  final Map<String, String> eyeColorLabels = {
    'brown': 'Brązowe', 'blue': 'Niebieskie', 'green': 'Zielone',
    'grey': 'Szare', 'red': 'Czerwone',
  };

  final Map<String, String> hairColorLabels = {
    'black': 'Czarne', 'brown': 'Brązowe', 'blond': 'Blond',
    'orange': 'Rude', 'grey': 'Szare', 'white': 'Białe',
  };

  bool get isEditing => widget.resident != null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: isEditing ? widget.resident!.name : "");
    lastNameController = TextEditingController(text: isEditing ? widget.resident!.lastName : "");
    ageController = TextEditingController(text: isEditing ? widget.resident!.age.toString() : "");

    aspiration = isEditing ? widget.resident!.traits.aspiration : "Nieznana";
    eyeColor = isEditing ? widget.resident!.traits.eyeColor : null;
    hairColor = isEditing ? widget.resident!.traits.hairColor : null;
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: Column(
          children: [
            _buildHeader(),
            Divider(color: Theme.of(context).colorScheme.outlineVariant),
            Expanded(child: _buildForm()),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isEditing ? PhosphorIcons.info(PhosphorIconsStyle.bold) : PhosphorIcons.userPlus(PhosphorIconsStyle.bold), 
              color: Theme.of(context).colorScheme.onSurface
            ),
            const SizedBox(width: 10),
            Text(
              isEditing ? "Karta Sima" : "Nowy Sim",
              style: GoogleFonts.quicksand(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold), color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildSectionTitle("Podstawowe"),
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.user(PhosphorIconsStyle.bold), size: 60, color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController, 
                      autofocus: !isEditing,
                      decoration: const InputDecoration(labelText: "Imię", labelStyle: TextStyle(fontWeight: FontWeight.bold))
                    ),
                    const SizedBox(height: 10),
                    TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Nazwisko", labelStyle: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(controller: ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Wiek", labelStyle: TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 25),
          _buildSectionTitle("Cechy i Wygląd"),
          DropdownButtonFormField<String>(
            initialValue: aspiration,
            decoration: const InputDecoration(labelText: "Aspiracja"),
            items: ["Nieznana", "Bogactwo", "Romans", "Wiedza", "Rodzina", "Popularność"].map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
            onChanged: (val) => setState(() { if (val != null) aspiration = val; }),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: eyeColor,
            decoration: const InputDecoration(labelText: "Kolor oczu"),
            items: eyeColorLabels.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))).toList(),
            onChanged: (val) => setState(() => eyeColor = val),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: hairColor,
            decoration: const InputDecoration(labelText: "Kolor włosów"),
            items: hairColorLabels.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))).toList(),
            onChanged: (val) => setState(() => hairColor = val),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: _handleSave,
        child: Text(
          isEditing ? "Zapisz zmiany" : "Dodaj Sima", 
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(width: 4, height: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(title.toUpperCase(), style: GoogleFonts.quicksand(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  void _handleSave() {
    final name = nameController.text.trim();
    final lastName = lastNameController.text.trim();
    final age = int.tryParse(ageController.text.trim());

    if (name.isEmpty || lastName.isEmpty || age == null) {
      SnackbarUtils.showError(context, "Imię, nazwisko i wiek są wymagane!");
      return;
    }

    if (isEditing) {
      widget.resident!.name = name;
      widget.resident!.lastName = lastName;
      widget.resident!.age = age;
      widget.resident!.traits.aspiration = aspiration;
      widget.resident!.traits.eyeColor = eyeColor;
      widget.resident!.traits.hairColor = hairColor;
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop({
        "name": name,
        "lastName": lastName,
        "age": age,
        "aspiration": aspiration,
        "eyeColor": eyeColor,
        "hairColor": hairColor,
      });
    }
  }
}