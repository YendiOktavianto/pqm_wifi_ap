import 'package:flutter/material.dart';
import '../controller/measurement_log_controller.dart';

import '../widgets/measurement_logs/measurement_logs_header.dart';
import '../widgets/measurement_logs/measurement_logs_dropdown.dart';
import '../widgets/measurement_logs/measurement_logs_empty_card.dart';
import '../widgets/measurement_logs/measurement_logs_table.dart';

class MeasurementLogPage extends StatefulWidget {
  const MeasurementLogPage({super.key});

  @override
  State<MeasurementLogPage> createState() => _MeasurementLogPageState();
}

class _MeasurementLogPageState extends State<MeasurementLogPage> {
  final controller = MeasurementLogController();
  bool _isDropdownOpen = false;

  void _toggleDropdown() => setState(() => _isDropdownOpen = !_isDropdownOpen);

  @override
  void initState() {
    super.initState();
    controller.loadFileList().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 800).clamp(0.7, 1.4);

    final hasSelection =
        (controller.selectedFile != null &&
            controller.selectedFile!.isNotEmpty);

    const headers = <String>[
      'DATE/TIME',
      'GROUND',
      'VOLTAGE',
      'FREQUENCY',
      'STATUS',
    ];
    final rows = controller.tableData; // List<List<String>>

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MeasurementLogsHeader(
                  onBack: () => Navigator.of(context).maybePop(),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                  child: Text(
                    'Select File',
                    style: TextStyle(
                      color: const Color(0xFFBDBDBD),
                      fontSize: (14 * scale),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                SizedBox(height: 8 * scale),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                  child: GestureDetector(
                    onTap: _toggleDropdown,
                    child: MeasurementLogsDropdownClosed(
                      scale: scale,

                      isLoading: false,
                      errorText: null,
                      selectedLabel:
                          (controller.selectedFile?.isNotEmpty ?? false)
                              ? controller.selectedFile
                              : 'Choose a log file',
                    ),
                  ),
                ),

                SizedBox(height: 18 * scale),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                    child:
                        hasSelection
                            ? MeasurementLogsTable(
                              scale: scale,
                              headers: headers,
                              rows: rows,
                            )
                            : MeasurementLogsEmptyCard(
                              scale: scale,
                              onChoose: _toggleDropdown,
                            ),
                  ),
                ),
              ],
            ),

            if (_isDropdownOpen)
              Positioned.fill(
                child: MeasurementLogsDropdownOverlay(
                  scale: scale,
                  title: 'Choose Log',
                  files: controller.availableFiles,
                  onClose: _toggleDropdown,
                  onSelect: (name) async {
                    await controller.loadSelectedFile(name);
                    if (mounted) {
                      setState(() {
                        _isDropdownOpen = false;
                      });
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
