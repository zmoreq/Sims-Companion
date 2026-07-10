import 'package:flutter/material.dart';

class RemoveDialog extends StatelessWidget {
  final String title;
  final String content;

  const RemoveDialog({
    super.key,
    this.title = "Potwierdzenie usunięcia",
    this.content = "Czy na pewno chcesz usunąć ten element? Tej akcji nie można cofnąć.",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Anuluj"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Usuń"),
        ),
      ],
    );
  }
}