import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class RecordingData extends ChangeNotifier {
  bool _isRecording = false;
  final List<Map<String, String>> _records = [];

  final Stopwatch _stopwatch = Stopwatch();
  late final Ticker _ticker;

  RecordingData() {
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration _) => notifyListeners();

  void start() {
    _isRecording = true;
    _stopwatch.start();
    _ticker.start();
    _records.clear();
  }

  void stop() {
    _isRecording = false;
    _stopwatch.stop();
    _ticker.stop();
  }

  void reset() {
    _stopwatch.reset();
    _records.clear();
    notifyListeners();
  }

  bool get isRecording => _isRecording;

  String get formattedTime {
    final elapsed = _stopwatch.elapsed;
    return '${elapsed.inMinutes.remainder(60).toString().padLeft(2, '0')}:${elapsed.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void addRecord({
    required double ground,
    required int voltage,
    required int frequency,
    required bool groundConnected,
  }) {
    if (!_isRecording) return;

    final now = DateTime.now();
    final formattedDate = DateFormat(
      "d MMMM yyyy HH:mm:ss",
      'id_ID',
    ).format(now);

    _records.add({
      'time': formattedDate,
      'ground': '${ground.toStringAsFixed(1)} Volt',
      'voltage': '$voltage Volt',
      'frequency': '$frequency Hz',
      'status': groundConnected ? 'Ground Connected' : 'Ground Not Connected',
    });
  }

  List<Map<String, String>> get records => List.unmodifiable(_records);
}

class Ticker {
  final void Function(Duration) onTick;
  late final Stopwatch _stopwatch;
  late final Duration _interval;
  late Timer _timer;

  Ticker(this.onTick) {
    _stopwatch = Stopwatch();
    _interval = const Duration(seconds: 1);
  }

  void start() {
    _stopwatch.start();
    _timer = Timer.periodic(_interval, (timer) => onTick(_stopwatch.elapsed));
  }

  void stop() {
    _stopwatch.stop();
    _timer.cancel();
  }
}
