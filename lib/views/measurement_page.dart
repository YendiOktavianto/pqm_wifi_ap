import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_menu_page.dart';
import '../widgets/measurement/date_time_display.dart';
import '../widgets/measurement/device_info_column.dart';
import '../widgets/exit_app_button.dart';
import '../widgets/measurement/measurement_display.dart';
import '../services/recording_data.dart';
import '../controller/measurement_controller.dart';
import '../services/scan_services.dart';
import '../services/save_file_service.dart';

class MeasurementPage extends StatefulWidget {
  final int mode;

  const MeasurementPage({super.key, this.mode = 2});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  final RecordingData _recordingData = RecordingData();
  bool isScanning = false;
  bool isRecording = false;
  late MeasurementController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startPolling();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    controller = context.read<MeasurementController>();
  }

  @override
  void dispose() {
    controller.stopPolling();
    super.dispose();
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
                        controller.setRecording(false);
                        controller.recordedData.clear();
                        controller.setRecording(false);
                      });
                      Navigator.of(context).pop();

                      if (shouldSetMode2) {
                        await context
                            .read<MeasurementController>()
                            .setHardwareModeTo2();
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
                      await ExcelExportService.saveExcelToExternalStorage(
                        context: context,
                        records: controller.recordedData,
                        onReset: () {
                          _recordingData.reset();
                          controller.setRecording(false);
                          controller.recordedData.clear();
                        },
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
    final controller = context.watch<MeasurementController>();
    final mode = controller.mode;

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
                    MeasurementDisplay(controller: controller),
                    const SizedBox(height: 20),

                    if (mode == 2) ...[
                      Center(
                        child: ElevatedButton(
                          onPressed:
                              isScanning
                                  ? null
                                  : () async {
                                    await ScanService.startScanMode(
                                      context: context,
                                      onStart:
                                          () =>
                                              setState(() => isScanning = true),
                                      onEnd: () async {
                                        await controller.fetchData();
                                        setState(() => isScanning = false);
                                      },
                                    );
                                  },
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
                                    await controller.setHardwareModeTo2();
                                    setState(() {
                                      context
                                          .read<MeasurementController>()
                                          .resetDataState();
                                    });
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
                                            controller.setRecording(true);
                                          });
                                        } else {
                                          _confirmStopRecording(() {
                                            setState(() {
                                              isRecording = false;
                                              _recordingData.stop();
                                              controller.setRecording(false);
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
                          await controller.setHardwareModeTo2();
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
