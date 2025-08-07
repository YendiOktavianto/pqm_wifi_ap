import 'dart:io';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';

class MeasurementLogController {
  List<List<String>> tableData = [];
  List<String> availableFiles = [];
  String? selectedFile;

  Future<void> loadFileList() async {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) return;

    final dir = Directory('/storage/emulated/0/Documents');
    final files =
        dir
            .listSync()
            .where((f) => f is File && f.path.endsWith(".xlsx"))
            .map((f) => f.path.split("/").last)
            .toList();

    availableFiles = files;
  }

  Future<void> loadSelectedFile(String filename) async {
    final file = File('/storage/emulated/0/Documents/$filename');
    if (!file.existsSync()) return;

    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final Sheet sheet = excel.tables[excel.tables.keys.first]!;

    tableData =
        sheet.rows
            .skip(1)
            .map(
              (row) => row.map((cell) => cell?.value.toString() ?? '').toList(),
            )
            .toList();

    selectedFile = filename;
  }
}
