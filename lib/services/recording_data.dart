// lib/services/recording_data.dart
import 'dart:async';
import 'package:flutter/material.dart';

class RecordingData extends ChangeNotifier {
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  String get formattedTime {
    final hours = _secondsElapsed ~/ 3600;
    final minutes = (_secondsElapsed % 3600) ~/ 60;
    final seconds = _secondsElapsed % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void start() {
    if (_isRecording) return;
    _isRecording = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsElapsed++;
      notifyListeners();
    });
    notifyListeners();
  }

  void stop() {
    _isRecording = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    stop();
    _secondsElapsed = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
