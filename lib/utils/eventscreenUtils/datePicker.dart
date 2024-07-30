import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';

class CustomDatePicker {
  void datePicker(context, Function(dynamic)? onSubmit, Function? onClose) {
    BottomPicker.time(
      pickerTitle: Text(
        'Set your next meeting time',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.orange,
        ),
      ),
      onSubmit: onSubmit,
      onClose: onClose,
      bottomPickerTheme: BottomPickerTheme.orange,
      use24hFormat: true,
      initialTime: Time(
        minutes: 23,
      ),
      maxTime: Time(
        hours: 17,
      ),
    ).show(context);
  }
}
