import 'package:flutter/material.dart';

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required Map<String, T?> Function() optionsBuilder,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          for (final entry in optionsBuilder().entries)
            TextButton(
              onPressed: () => Navigator.of(context).pop(entry.value),
              child: Text(entry.key),
            ),
        ],
      );
    },
  );
}