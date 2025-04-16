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
        // Ground Measurement
        Card(
          color: Colors.grey[850],
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label + Status
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
                // Value
                Text(
                  groundValue,
                  style: TextStyle(
                    color: groundStatusColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Voltage & Frequency Row
        Row(
          children: [
            Expanded(
              child: _smallMeasurementCard(
                label: 'Voltage (V)',
                value: voltageValue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _smallMeasurementCard(
                label: 'Frequency (Hz)',
                value: frequencyValue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _smallMeasurementCard({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
