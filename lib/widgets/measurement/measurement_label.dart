import 'package:flutter/material.dart';

class MeasurementLabel extends StatelessWidget {
  const MeasurementLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Voltage & Ground Measurement',
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
