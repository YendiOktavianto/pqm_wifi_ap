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

  // Ground status info
  String groundStatus = "";
  Color groundStatusColor = Colors.red;
  Color groundValueColor = Colors.white;

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
        updateStatus(newData);

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

  void updateStatus(MeasurementData newData) {
    if (newData.mode == 2) {
      groundStatus = "";
      groundStatusColor = Colors.transparent;
      groundValueColor = Colors.white;
    } else if (newData.mode == 5) {
      groundStatus = "Fail";
      groundStatusColor = Colors.red;
      groundValueColor = Colors.white;
    } else {
      if (newData.ground > 1.0) {
        groundStatus = "Fail";
        groundStatusColor = Colors.red;
        groundValueColor = Colors.red;
      } else {
        groundStatus = "Pass";
        groundStatusColor = Colors.green;
        groundValueColor = Colors.green;
      }
    }
  }

  void resetDataState() {
    data = null;
    groundStatus = "";
    groundStatusColor = Colors.transparent;
    groundValueColor = Colors.white;
  }

  Future<void> setHardwareModeTo2() async {
    try {
      await http.get(Uri.parse('http://192.168.4.1/mode?value=2'));
    } catch (e) {
      debugPrint('Failed to set mode to 2: $e');
    }
  }
}
