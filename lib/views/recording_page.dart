import 'package:flutter/material.dart';
import 'measurement_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/device_info_column.dart';
import '../widgets/measurement_display.dart';
import '../widgets/exit_app_button.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  String radioValue = 'NO';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [DateTimeDisplay(), DeviceInfoColumn()],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text("Refresh"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text("Disconnect"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            MeasurementDisplay(
              groundValue: '010.5',
              groundStatus: 'Fail',
              groundStatusColor: Colors.red,
              voltageValue: '220',
              frequencyValue: '50',
            ),
            const SizedBox(height: 20),
            const Text(
              "Recording data has complete!\nDo you want to save recording file?",
              style: TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 'NO',
                  groupValue: radioValue,
                  onChanged: (val) => setState(() => radioValue = val!),
                ),
                const Text("NO", style: TextStyle(color: Colors.white)),
                Radio(
                  value: 'YES',
                  groupValue: radioValue,
                  onChanged: (val) => setState(() => radioValue = val!),
                ),
                const Text("YES", style: TextStyle(color: Colors.white)),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter filename here",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MeasurementPage(),
                      ),
                    );
                  },
                  child: const Text("BACK"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text("SAVE"),
                ),
              ],
            ),
            // const Spacer(),
            const SizedBox(height: 20),
            const ExitAppButton(),
          ],
        ),
      ),
    );
  }
}
