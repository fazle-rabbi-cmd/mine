import 'package:flutter/material.dart';

Future<void> showDatePickerDialog(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );
  if (pickedDate != null) {
    // Handle selected date
  }
}
