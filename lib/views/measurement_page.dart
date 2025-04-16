import 'package:flutter/material.dart';
import 'connected_device_page.dart';
import 'recording_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/device_info_column.dart';
import '../widgets/measurement_display.dart';
import '../widgets/record_button.dart';
import '../widgets/exit_app_button.dart';

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
            MeasurementDisplay(
              groundValue: '010.5',
              groundStatus: 'Fail',
              groundStatusColor: Colors.red,
              voltageValue: '220',
              frequencyValue: '50',
            ),
            const SizedBox(height: 20),
            RecordButton(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
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
            const ExitAppButton(),
          ],
        ),
      ),
    );
  }

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
