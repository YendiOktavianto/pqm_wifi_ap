import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'connected_device_page.dart';
import 'main_menu_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/device_info_column.dart';
import '../widgets/exit_app_button.dart';
import '../widgets/measurement_display.dart';
import '../services/recording_data.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

Timer? _timer;

class _MeasurementPageState extends State<MeasurementPage> {
  bool isRecording = false;

  String groundValue = "0.0";
  String groundStatus = "Fail";
  Color groundStatusColor = Colors.red;
  String voltageValue = "0.0";
  String frequencyValue = "0.0";
  int mode = 2;

  final RecordingData _recordingData = RecordingData();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      fetchDataFromESP();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordingData.stop();
    super.dispose();
  }

  Future<void> fetchDataFromESP() async {
    if (!mounted) return;
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/'));
      if (response.statusCode == 200) {
        // print('RESPONSE: ${response.body}');
        final data = json.decode(response.body);
        num ground = (data['ground'] ?? 0.0);
        num voltage = (data['voltage'] ?? 0);
        num frequency = (data['frequency'] ?? 0);
        int receivedMode = data['mode'] ?? 0;

        if (!mounted) return;

        setState(() {
          groundValue = ground.toStringAsFixed(1);
          voltageValue = voltage.toString();
          frequencyValue = frequency.toString();
          mode = receivedMode;

          // print('Formatted values:');
          // print('  groundValue: $groundValue');
          // print('  voltageValue: $voltageValue');
          // print('  frequencyValue: $frequencyValue');
          // print('  mode: $mode');

          if (mode == 5) {
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

        if (_recordingData.isRecording) {
          bool isConnected = receivedMode != 5;

          double groundParsed = double.tryParse(groundValue) ?? 0.0;
          int voltageParsed = int.tryParse(voltageValue) ?? 0;
          int frequencyParsed = int.tryParse(frequencyValue) ?? 0;

          // print('RECORDING:');
          // print('  ground: $groundParsed');
          // print('  voltage: $voltageParsed');
          // print('  frequency: $frequencyParsed');
          // print(
          //   '  status: ${isConnected ? "Ground Connected" : "Ground Not Connected"}',
          // );

          _recordingData.addRecord(
            ground: isConnected ? groundParsed : 0.0,
            voltage: isConnected ? voltageParsed : 0,
            frequency: isConnected ? frequencyParsed : 0,
            groundConnected: isConnected,
          );
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> setHardwareModeTo2() async {
    try {
      await http.get(Uri.parse('http://192.168.4.1/mode?value=2'));
    } catch (e) {
      print('Failed set mode to 2: $e');
    }
  }

  Future<void> saveExcelToExternalStorage(BuildContext context) async {
    TextEditingController filenameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save File As'),
          content: TextField(
            controller: filenameController,
            decoration: const InputDecoration(hintText: "Enter filename..."),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _recordingData.reset();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                final filename = filenameController.text.trim();
                if (filename.isEmpty) {
                  return;
                }

                var status = await Permission.manageExternalStorage.status;
                if (!status.isGranted) {
                  status = await Permission.manageExternalStorage.request();
                  if (!status.isGranted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission denied")),
                    );
                    return;
                  }
                }

                try {
                  final dir = Directory('/storage/emulated/0/Documents');
                  if (!(await dir.exists())) {
                    await dir.create(recursive: true);
                  }

                  final fullPath = '${dir.path}/$filename.xlsx';

                  final excel = Excel.createExcel();
                  final sheet = excel['Sheet1'];
                  sheet.appendRow([
                    'Time',
                    'Ground',
                    'Voltage',
                    'Frequency',
                    'Status',
                  ]);
                  for (var row in _recordingData.records) {
                    sheet.appendRow([
                      row['time'],
                      row['ground'],
                      row['voltage'],
                      row['frequency'],
                      row['status'],
                    ]);
                  }

                  final bytes = excel.encode();
                  if (bytes != null) {
                    final file = File(fullPath);
                    await file.create(recursive: true);
                    await file.writeAsBytes(bytes);

                    _recordingData.reset();
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("File saved to:\n$fullPath")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Failed to save: $e")));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void saveAndThenNavigate(BuildContext context, Widget nextPage) {
    TextEditingController filenameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save File As'),
          content: TextField(
            controller: filenameController,
            decoration: const InputDecoration(hintText: "Enter filename..."),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                final filename = filenameController.text.trim();
                if (filename.isEmpty) return;

                var status = await Permission.manageExternalStorage.status;
                if (!status.isGranted) {
                  status = await Permission.manageExternalStorage.request();
                  if (!status.isGranted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permission denied")),
                    );
                    return;
                  }
                }

                try {
                  final dir = Directory('/storage/emulated/0/Documents');
                  if (!(await dir.exists())) {
                    await dir.create(recursive: true);
                  }

                  final fullPath = '${dir.path}/$filename.xlsx';
                  final excel = Excel.createExcel();
                  final sheet = excel['Sheet1'];
                  sheet.appendRow([
                    'Time',
                    'Ground',
                    'Voltage',
                    'Frequency',
                    'Status',
                  ]);
                  for (var row in _recordingData.records) {
                    sheet.appendRow([
                      row['time'],
                      row['ground'],
                      row['voltage'],
                      row['frequency'],
                      row['status'],
                    ]);
                  }

                  final bytes = excel.encode();
                  if (bytes != null) {
                    final file = File(fullPath);
                    await file.create(recursive: true);
                    await file.writeAsBytes(bytes);
                    _recordingData.reset();
                  }

                  try {
                    await http.get(
                      Uri.parse('http://192.168.4.1/mode?value=2'),
                    );
                    await Future.delayed(
                      const Duration(milliseconds: 300),
                    );
                  } catch (e) {
                    print('[ERROR] Gagal mengatur mode ke 2: $e');
                  }

                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => nextPage),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Failed to save: $e")));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmStopRecording(
    VoidCallback onConfirmed, {
    Widget? navigateToAfterStop,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Stop Recording',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to stop recording and save the data to an Excel file?',
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      foregroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Only Stop'),
                    onPressed: () {
                      setState(() {
                        isRecording = false;
                        _recordingData.stop();
                        _recordingData.reset();
                      });
                      Navigator.of(context).pop();

                      if (navigateToAfterStop != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => navigateToAfterStop,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Yes, Save and Stop'),
                    onPressed: () {
                      onConfirmed();
                      saveAndThenNavigate(
                        context,
                        navigateToAfterStop ?? const MeasurementPage(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
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
                          if (!isRecording) {
                            setState(() {
                              isRecording = true;
                              _recordingData.start();
                            });
                          } else {
                            _confirmStopRecording(() {
                              setState(() {
                                isRecording = false;
                                _recordingData.stop();
                                // _recordingData.reset();
                              });
                            });
                          }
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
                    if (isRecording)
                      AnimatedBuilder(
                        animation: _recordingData,
                        builder: (context, _) {
                          return Text(
                            _recordingData.formattedTime,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
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
                      actionButton(context, 'BACK', () async {
                        if (isRecording) {
                          _confirmStopRecording(() async {
                            setState(() {
                              isRecording = false;
                              _recordingData.stop();
                            });
                            await setHardwareModeTo2();
                            saveAndThenNavigate(
                              context,
                              const ConnectedDevicePage(),
                            );
                          }, navigateToAfterStop: const ConnectedDevicePage());
                        } else {
                          await setHardwareModeTo2();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ConnectedDevicePage(),
                            ),
                          );
                        }
                      }),

                      actionButton(context, 'MAIN MENU', () async {
                        if (isRecording) {
                          _confirmStopRecording(() {
                            setState(() {
                              isRecording = false;
                              _recordingData.stop();
                            });
                            saveAndThenNavigate(context, const MainMenuPage());
                          }, navigateToAfterStop: const MainMenuPage());
                        } else {
                          await setHardwareModeTo2();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainMenuPage(),
                            ),
                          );
                        }
                      }),
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
