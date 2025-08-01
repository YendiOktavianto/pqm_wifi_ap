import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/measurement_data.dart';
import '../views/measurement_page.dart';

class ExcelExportService {
  static Future<void> saveExcelToExternalStorage({
    required BuildContext context,
    required List<MeasurementData> records,
    required VoidCallback onReset,
  }) async {
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
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      isSaving
                          ? null
                          : () async {
                            final filename = filenameController.text.trim();
                            if (filename.isEmpty) {
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
                                if (Navigator.canPop(context))
                                  Navigator.pop(context);
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

                              for (final item in records) {
                                final map = item.toExcelMap();
                                sheet.appendRow([
                                  map['Time'],
                                  map['Ground'],
                                  map['Voltage'],
                                  map['Frequency'],
                                  map['Status'],
                                ]);
                              }

                              final bytes = excel.encode();
                              if (bytes != null) {
                                final file = File(fullPath);
                                await file.create(recursive: true);
                                await file.writeAsBytes(bytes);
                              }

                              if (Navigator.canPop(context)) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const MeasurementPage(mode: 4),
                                  ),
                                  (route) => false,
                                );
                              }

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("File saved to:\n$fullPath"),
                                  ),
                                );
                              }

                              onReset();
                            } catch (e) {
                              setState(() => isSaving = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed to save: $e")),
                              );
                            }
                          },
                  child:
                      isSaving
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
