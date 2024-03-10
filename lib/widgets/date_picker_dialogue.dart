import 'package:flutter/material.dart';

typedef DateCallback = void Function(DateTime selectedDate);

Future<void> showDatePickerDialog(
    BuildContext context, DateCallback onDateSelected) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );
  if (pickedDate != null) {
    onDateSelected(
        pickedDate); // Call the callback function with the selected date
  }
}
