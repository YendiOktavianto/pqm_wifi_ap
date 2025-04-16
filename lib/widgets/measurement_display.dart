import 'package:flutter/material.dart';

class MeasurementDisplay extends StatelessWidget {
  final String groundValue;
  final String groundStatus;
  final Color groundStatusColor;
  final String voltageValue;
  final String frequencyValue;

  const MeasurementDisplay({
    super.key,
    required this.groundValue,
    required this.groundStatus,
    required this.groundStatusColor,
    required this.voltageValue,
    required this.frequencyValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.grey[850],
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ground Measurement (V)',
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: groundStatusColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        groundStatus,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  groundValue,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: groundStatusColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _smallMeasurementCard('Voltage (V)', voltageValue)),
            const SizedBox(width: 12),
            Expanded(
              child: _smallMeasurementCard('Frequency (Hz)', frequencyValue),
            ),
          ],
        ),
      ],
    );
  }

  Widget _smallMeasurementCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 40, color: Colors.green),
          ),
          Text(label, style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}
