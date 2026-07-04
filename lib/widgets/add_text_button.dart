import 'package:flutter/material.dart';

class TextAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const TextAddButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        fixedSize: const Size(345, 65),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20),
          const Icon(Icons.add),
          const SizedBox(width: 50),
          Text(label),
        ],
      )
    );
  }
}