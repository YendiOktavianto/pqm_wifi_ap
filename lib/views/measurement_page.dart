import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'main_menu_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/device_info_column.dart';
import '../widgets/exit_app_button.dart';
import '../widgets/measurement/measurement_display.dart';
import '../services/recording_data.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  Timer? _timer;
  bool isFetching = false;
  bool isRecording = false;
  bool isScanning = false;

  String? groundValue;
  String groundStatus = "Fail";
  Color groundStatusColor = Colors.red;
  Color groundValueColor = Colors.white;
  String? voltageValue;
  String? frequencyValue;
  int mode = 2;

  final RecordingData _recordingData = RecordingData();

  @override
  void initState() {
    super.initState();
    fetchDataFromESP();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      fetchDataFromESP();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _recordingData.stop();
    super.dispose();
  }

  Future<void> fetchDataFromESP() async {
    if (!mounted || isFetching) return;
    setState(() => isFetching = true);

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
            // voltageValue = "---";
            // frequencyValue = "---";
          } else if (mode == 2) {
            groundValue = "--.--";
            voltageValue = "---";
            frequencyValue = "---";
          } else {
            groundValue = ground.toStringAsFixed(1);
            voltageValue = voltage.toString();
            frequencyValue = frequency.toString();

            if (ground > 1.0) {
              groundStatus = "Fail";
              groundStatusColor = Colors.red;
              groundValueColor = Colors.red;
            } else {
              groundStatus = "Pass";
              groundStatusColor = Colors.green;
              groundValueColor = Colors.green;
            }
          }
        });

        if (_recordingData.isRecording) {
          bool isConnected = receivedMode != 5;

          double groundParsed = double.tryParse(groundValue ?? '') ?? 0.0;
          int voltageParsed = int.tryParse(voltageValue ?? '') ?? 0;
          int frequencyParsed = int.tryParse(frequencyValue ?? '') ?? 0;

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
    } finally {
      if (mounted) setState(() => isFetching = false);
    }
  }

  Future<void> startScanMode() async {
    setState(() => isScanning = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            content: Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Scanning... Please wait"),
              ],
            ),
          ),
    );

    try {
      await http.get(Uri.parse('http://192.168.4.1/scan'));
      await Future.delayed(const Duration(seconds: 4));
    } catch (e) {
      print("Failed to scan: $e");
    } finally {
      if (context.mounted) Navigator.pop(context);
      setState(() => isScanning = false);
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
    bool isSaving = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Save File As'),
              content: TextField(
                controller: filenameController,
                decoration: const InputDecoration(
                  hintText: "Enter filename...",
                ),
                enabled: !isSaving,
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed:
                      isSaving
                          ? null
                          : () {
                            Navigator.pop(context);
                          },
                ),
                ElevatedButton(
                  child:
                      isSaving
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Save'),
                  onPressed:
                      isSaving
                          ? null
                          : () async {
                            final filename = filenameController.text.trim();
                            if (filename.isEmpty) {
                              // Bisa pakai error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter a filename"),
                                ),
                              );
                              return;
                            }

                            setState(() => isSaving = true);

                            var status =
                                await Permission.manageExternalStorage.status;
                            if (!status.isGranted) {
                              status =
                                  await Permission.manageExternalStorage
                                      .request();
                              if (!status.isGranted) {
                                setState(() => isSaving = false);
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Permission denied"),
                                  ),
                                );
                                return;
                              }
                            }

                            try {
                              final dir = Directory(
                                '/storage/emulated/0/Documents',
                              );
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
                              }

                              if (Navigator.canPop(context)) {
                                Navigator.pop(context); // Tutup dialog!
                              }

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("File saved to:\n$fullPath"),
                                  ),
                                );
                              }

                              _recordingData
                                  .reset(); // RESET DATA di akhir, setelah file sukses!
                            } catch (e) {
                              setState(() => isSaving = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed to save: $e")),
                              );
                            }
                          },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmStopRecording(
    VoidCallback onConfirmed, {
    Widget? navigateToAfterStop,
    shouldSetMode2 = false,
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
                    onPressed: () async {
                      setState(() {
                        isRecording = false;
                        _recordingData.stop();
                        _recordingData.reset();
                      });
                      Navigator.of(context).pop();

                      if (shouldSetMode2) {
                        await setHardwareModeTo2();
                      }

                      if (navigateToAfterStop != null) {
                        if (!mounted) return;
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
                    child: const Text('Save Data'),
                    onPressed: () async {
                      setState(() {
                        isRecording = false;
                        _recordingData.stop();
                      });
                      Navigator.of(context).pop();
                      await saveExcelToExternalStorage(context);
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
                      groundStatus: mode == 2 ? '' : groundStatus,
                      groundStatusColor:
                          mode == 2 ? Colors.transparent : groundStatusColor,
                      groundValueColor: groundValueColor,
                      voltageValue: voltageValue,
                      frequencyValue: frequencyValue,
                    ),
                    const SizedBox(height: 20),

                    if (mode == 2) ...[
                      Center(
                        child: ElevatedButton(
                          onPressed: isScanning ? null : startScanMode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
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
                          child: const Text(
                            "SCAN",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ] else if (mode == 4 || mode == 5) ...[
                      Row(
                        children: [
                          if (!isRecording)
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await setHardwareModeTo2();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    "RESET",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),

                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 24,

                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton.icon(
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
                                            });
                                          }, shouldSetMode2: false);
                                        }
                                      },
                                      icon: Icon(
                                        isRecording
                                            ? Icons.stop_circle
                                            : Icons.fiber_manual_record,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        isRecording
                                            ? 'Stop Recording Data'
                                            : 'Record Data',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            isRecording
                                                ? Colors.red
                                                : Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                    if (isRecording) const SizedBox(height: 8),
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
                          ),
                        ],
                      ),
                    ],
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
                      actionButton(context, 'BACK TO MAIN MENU', () async {
                        if (isRecording) {
                          _confirmStopRecording(
                            () async {
                              setState(() {
                                isRecording = false;
                                _recordingData.stop();
                              });
                            },
                            navigateToAfterStop: const MainMenuPage(),
                            shouldSetMode2: true,
                          );
                        } else {
                          await setHardwareModeTo2();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => MainMenuPage()),
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
