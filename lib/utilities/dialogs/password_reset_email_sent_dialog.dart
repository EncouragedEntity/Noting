import 'package:flutter/material.dart';

import '../generics/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Password reset",
    content: "Check you email for password reset letter",
  );
}
