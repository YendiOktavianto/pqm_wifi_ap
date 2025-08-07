// lib/views/measurement_log_page.dart

import 'package:flutter/material.dart';
import '../controller/measurement_log_controller.dart';

class MeasurementLogPage extends StatefulWidget {
  const MeasurementLogPage({super.key});

  @override
  State<MeasurementLogPage> createState() => _MeasurementLogPageState();
}

class _MeasurementLogPageState extends State<MeasurementLogPage> {
  final controller = MeasurementLogController();

  @override
  void initState() {
    super.initState();
    controller.loadFileList().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Measurement Logs",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select File:", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: controller.selectedFile,
              isExpanded: true,
              hint: const Text(
                "Choose a log file",
                style: TextStyle(color: Colors.white54),
              ),
              dropdownColor: Colors.grey[900],
              items:
                  controller.availableFiles.map((file) {
                    return DropdownMenuItem(
                      value: file,
                      child: Text(
                        file,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
              onChanged: (value) async {
                if (value != null) {
                  await controller.loadSelectedFile(value);
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  controller.tableData.isEmpty
                      ? const Center(
                        child: Text(
                          "No data loaded",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                      : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.grey[800],
                          ),
                          dataRowColor: WidgetStateProperty.all(
                            Colors.grey[900],
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                "DATE TIME",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "GROUND",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "VOLTAGE",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "FREQUENCY",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "STATUS",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          rows:
                              controller.tableData.map((row) {
                                final status = row.length > 4 ? row[4] : '';
                                return DataRow(
                                  cells:
                                      row.asMap().entries.map((entry) {
                                        final i = entry.key;
                                        final cell = entry.value;
                                        final color =
                                            (i == 4 && status == "FAIL")
                                                ? Colors.red
                                                : (i == 4 && status == "PASS")
                                                ? Colors.green
                                                : Colors.white;
                                        return DataCell(
                                          Text(
                                            cell,
                                            style: TextStyle(color: color),
                                          ),
                                        );
                                      }).toList(),
                                );
                              }).toList(),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
