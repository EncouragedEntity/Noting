import 'package:flutter/material.dart';
import '../generics/generic_dialog.dart';

class CannotShareEmptyNoteDialog {
  Future<void> show(BuildContext context) {
    return showGenericDialog<void>(
      context: context,
      title: 'Sharing',
      content: 'You cannot share an empty note!',
    );
  }
}