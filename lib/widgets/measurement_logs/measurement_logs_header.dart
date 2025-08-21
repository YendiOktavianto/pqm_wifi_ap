import 'package:flutter/material.dart';

class MeasurementLogsHeader extends StatelessWidget {
  final VoidCallback onBack;

  const MeasurementLogsHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          // Icon back
          InkWell(
            onTap: onBack,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 24,
              weight: 800,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Measurement Logs',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 28,
              fontStyle: FontStyle.italic,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
