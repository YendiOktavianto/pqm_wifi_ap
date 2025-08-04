import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/measurement_data.dart';

class MeasurementController with ChangeNotifier {
  MeasurementData? data;

  bool isFetching = false;
  bool isRecording = false;
  bool isScanning = false;

  List<MeasurementData> recordedData = [];

  double get ground => data?.ground ?? 0.0;

  double get voltage => data?.voltage ?? 0.0;

  double get frequency => data?.frequency ?? 0.0;

  int get mode => data?.mode ?? 0;

  bool get isGroundDisconnected => mode == 5;

  String get groundDisplay =>
      isGroundDisconnected ? "Ground Not Connected" : ground.toStringAsFixed(1);

  Color get groundValueColor {
    if (mode == 5) return Colors.red;
    if (mode == 2) return Colors.white;
    return ground >= 1.0 ? Colors.red : Colors.green;
  }

  String get voltageDisplay =>
      isGroundDisconnected ? "---" : voltage.toStringAsFixed(0);

  String get frequencyDisplay =>
      isGroundDisconnected ? "---" : frequency.toStringAsFixed(0);

  String get groundStatus {
    if (mode == 4) {
      return ground >= 1.0 ? "FAIL" : "PASS";
    }
    return "";
  }

  Color get groundStatusColor {
    if (mode == 4) {
      return ground >= 1.0 ? Colors.red : Colors.green;
    }
    return Colors.transparent;
  }

  Timer? _timer;

  void startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      fetchData();
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> fetchData() async {
    if (isFetching) return;
    isFetching = true;

    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/'));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final newData = MeasurementData.fromJson(decoded);

        data = newData;

        notifyListeners();

        if (isRecording) {
          final now = DateTime.now();
          recordedData.add(
            MeasurementData(
              date: DateFormat('dd-MM-yyyy').format(now),
              day: DateFormat('EEEE').format(now),
              time: DateFormat('HH:mm:ss').format(now),
              ground: newData.ground,
              voltage: newData.voltage,
              frequency: newData.frequency,
              mode: newData.mode,
            ),
          );
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    isFetching = false;
  }

  void setRecording(bool isOn) {
    isRecording = isOn;
  }

  void resetDataState() {
    data = null;
  }

  Future<void> setHardwareModeTo2() async {
    try {
      await http.get(Uri.parse('http://192.168.4.1/mode?value=2'));
    } catch (e) {
      debugPrint('Failed to set mode to 2: $e');
    }
  }
}
