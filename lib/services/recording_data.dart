import 'package:flutter/foundation.dart';
import 'dart:async';

class RecordingData extends ChangeNotifier {
  bool _isRecording = false;
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
    notifyListeners();
  }

  void stop() {
    _isRecording = false;
    _stopwatch.stop();
    _ticker.stop();
    notifyListeners();
  }

  void reset() {
    _stopwatch.reset();
    notifyListeners();
  }

  bool get isRecording => _isRecording;

  String get formattedTime {
    final elapsed = _stopwatch.elapsed;
    return '${elapsed.inHours.toString().padLeft(2, '0')}:'
        '${elapsed.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
        '${elapsed.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}

class Ticker {
  final void Function(Duration) onTick;
  late final Stopwatch _stopwatch;
  late final Duration _interval;
  Timer? _timer;

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
    _timer?.cancel();
  }
}
