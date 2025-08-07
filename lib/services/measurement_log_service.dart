import 'dart:io';
import 'package:excel/excel.dart';

class MeasurementLogService {
  static const String logFolderPath = '/storage/emulated/0/Documents';

  static List<String> listExcelFiles() {
    final dir = Directory(logFolderPath);
    if (!dir.existsSync()) return [];

    return dir
        .listSync()
        .where((f) => f is File && f.path.endsWith(".xlsx"))
        .map((f) => f.path.split("/").last)
        .toList();
  }

  static List<List<String>> readExcelFile(String filename) {
    final file = File('$logFolderPath/$filename');
    if (!file.existsSync()) return [];

    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final Sheet sheet = excel.tables[excel.tables.keys.first]!;

    return sheet.rows
        .skip(1)
        .map((row) => row.map((cell) => cell?.value.toString() ?? '').toList())
        .toList();
  }
}
