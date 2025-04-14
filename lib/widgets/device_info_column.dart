import 'package:flutter/material.dart';

class DeviceInfoColumn extends StatelessWidget {
  const DeviceInfoColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Icon(Icons.wifi, color: Colors.white, size: 32),
        const SizedBox(height: 4),
        const Text(
          'Connected Device:',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        const Text(
          'PQM-500Wi',
          style: TextStyle(color: Colors.yellow, fontSize: 12),
        ),
        const Text(
          '123456',
          style: TextStyle(color: Colors.yellow, fontSize: 12),
        ),
      ],
    );
  }
}
