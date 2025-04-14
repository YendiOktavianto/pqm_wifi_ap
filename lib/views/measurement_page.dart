import 'package:flutter/material.dart';
import 'connected_device_page.dart';
import 'recording_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/device_info_column.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [DateTimeDisplay(), DeviceInfoColumn()],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text('Refresh'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text('Disconnect'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            measurementCard(
              'Ground Measurement (V)',
              '010.5',
              'Fail',
              Colors.red,
            ),
            Row(
              children: [
                Expanded(
                  child: measurementCard(
                    'Voltage (V)',
                    '220',
                    '',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: measurementCard(
                    'Frequency (Hz)',
                    '50',
                    '',
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Do You Want Recording Data?',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'NO',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Radio<bool>(
                      value: false,
                      groupValue: isRecording,
                      onChanged:
                          (bool? value) => setState(() => isRecording = value!),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'YES',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Radio<bool>(
                      value: true,
                      groupValue: isRecording,
                      onChanged:
                          (bool? value) => setState(() => isRecording = value!),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter duration here',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text("Minute(s)", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                actionButton(
                  context,
                  'BACK',
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConnectedDevicePage(),
                    ),
                  ),
                ),
                actionButton(context, 'CANCEL', () {}),
                actionButton(
                  context,
                  'START',
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecordingPage(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              label: const Text(
                'Exit App',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget measurementCard(
    String title,
    String value,
    String status,
    Color statusColor,
  ) {
    return Card(
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
                Text(title, style: const TextStyle(color: Colors.white)),
                if (status.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: statusColor,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget radioOption(String label, bool selected) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Radio(value: selected, groupValue: true, onChanged: (_) {}),
      Text(label, style: const TextStyle(color: Colors.white)),
    ],
  );

  Widget actionButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.white),
    ),
  );
}
