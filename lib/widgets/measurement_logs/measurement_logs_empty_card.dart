import 'package:flutter/material.dart';

class MeasurementLogsEmptyCard extends StatelessWidget {
  final double scale;
  final VoidCallback? onChoose;

  const MeasurementLogsEmptyCard({
    super.key,
    required this.scale,
    this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(18 * scale),
        border: Border.all(color: const Color(0xFF2C2C2C)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 36 * scale,
        horizontal: 24 * scale,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88 * scale,
            height: 88 * scale,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(22 * scale),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: Icon(
              Icons.insert_drive_file_rounded,
              color: const Color(0xFF8A8A8A),
              size: 44 * scale,
            ),
          ),
          SizedBox(height: 16 * scale),
          Text(
            'No data yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20 * scale,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 6 * scale),
          Text(
            'Select a log file to display measurements.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFBDBDBD),
              fontSize: 14 * scale,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 22 * scale),
          SizedBox(
            width: 220 * scale,
            height: 48 * scale,
            child: ElevatedButton(
              onPressed: onChoose,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2962FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14 * scale),
                ),
              ),
              child: Text(
                'Choose File',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
