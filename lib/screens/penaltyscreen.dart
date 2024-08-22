import 'package:flutter/material.dart';

class PenaltyScreen extends StatefulWidget {
  const PenaltyScreen({super.key});

  @override
  State<PenaltyScreen> createState() => _PenaltyScreenState();
}

class _PenaltyScreenState extends State<PenaltyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penalty screen'),
      ),
    );
  }
}
