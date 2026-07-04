import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/city.dart';

class CityCard extends StatelessWidget {
  final City city;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CityCard({
    super.key,
    required this.city,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  void _showCityOptions(BuildContext context) {
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
                leading: const Icon(Icons.edit),
                title: const Text('Edytuj nazwę'),
                onTap: () {
                  Navigator.of(context).pop();
                  onEdit?.call();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Usuń miasto', style: TextStyle(color: Colors.red)),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      height: 125,
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: () => _showCityOptions(context),
          splashColor: Colors.black.withAlpha(50),
          child: Column(
            children: [
              _buildCityImage(),
              _buildCityInfo(context),
            ],
          ),
        )
      ),
    );
  }

  Widget _buildCityImage() {
    return Expanded(
      child: Image.network(
        'https://picsum.photos/400/200',
        fit: BoxFit.cover,
        width: double.infinity,
      )
    );
  }

  Widget _buildCityInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city.name,
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 5,
                  color: Theme.of(context).colorScheme.surface,
                )
              ),
              Container(
                height: 1,
                width: 225,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            ],
          ),
          IconButton(
            onPressed: () => _showCityOptions(context),
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap
            ),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}