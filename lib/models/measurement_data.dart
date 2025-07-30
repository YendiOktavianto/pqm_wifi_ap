class MeasurementData {
  final double ground;
  final double voltage;
  final double frequency;
  final int mode;

  MeasurementData({
    required this.ground,
    required this.voltage,
    required this.frequency,
    required this.mode,
  });

  factory MeasurementData.fromJson(Map<String, dynamic> json) {
    return MeasurementData(
      ground: (json['ground'] ?? 0.0).toDouble(),
      voltage: (json['voltage'] ?? 0.0).toDouble(),
      frequency: (json['frequency'] ?? 0.0).toDouble(),
      mode: json['mode'] ?? 0,
    );
  }
}
