import 'package:flutter/material.dart';

class EventSummary extends StatelessWidget {
  String counter;
  String eventName;
  EventSummary({super.key, required this.counter, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          counter,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(eventName)
      ],
    );
  }
}
