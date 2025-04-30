import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'connected_device_page.dart';
import 'recording_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/device_info_column.dart';
import '../widgets/measurement_label.dart';
import '../widgets/exit_app_button.dart';
import '../widgets/measurement_display.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  bool isRecording = false;

  String groundValue = "0.0";
  String groundStatus = "Fail";
  Color groundStatusColor = Colors.red;
  String voltageValue = "0.0";
  String frequencyValue = "0.0";
  int mode = 2;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (timer) {
      fetchDataFromESP();
    });
  }

  Future<void> fetchDataFromESP() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        num ground = (data['ground'] ?? 0.0);
        num voltage = (data['voltage'] ?? 0);
        num frequency = (data['frequency'] ?? 0);
        int receivedMode = data['mode'] ?? 0;

        setState(() {
          groundValue = ground.toStringAsFixed(1);
          voltageValue = voltage.toString();
          frequencyValue = frequency.toString();
          mode = receivedMode;

          if (mode == 3) {
            groundValue = "GROUND NOT CONNECTED";
            groundStatus = "Fail";
            groundStatusColor = Colors.red;
            voltageValue = "---";
            frequencyValue = "---";
          } else {
            groundValue = ground.toStringAsFixed(1);
            voltageValue = voltage.toString();
            frequencyValue = frequency.toString();

            if (ground > 1.0) {
              groundStatus = "Fail";
              groundStatusColor = Colors.red;
            } else {
              groundStatus = "Pass";
              groundStatusColor = Colors.green;
            }
          }
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
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
                      groundValue: groundValue,
                      groundStatus: groundStatus,
                      groundStatusColor: groundStatusColor,
                      voltageValue: voltageValue,
                      frequencyValue: frequencyValue,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isRecording = !isRecording;
                          });
                        },
                        icon: Icon(
                          isRecording
                              ? Icons.stop_circle
                              : Icons.fiber_manual_record,
                          color: Colors.white,
                        ),
                        label: Text(
                          isRecording ? 'Stop Recording Data' : 'Record Data',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isRecording ? Colors.red : Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
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
