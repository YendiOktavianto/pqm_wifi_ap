import 'package:intl/intl.dart';

class MeasurementData {
  final String date;
  final String day;
  final String time;
  final double ground;
  final double voltage;
  final double frequency;
  final int mode;

  MeasurementData({
    required this.date,
    required this.day,
    required this.time,
    required this.ground,
    required this.voltage,
    required this.frequency,
    required this.mode,
  });

  factory MeasurementData.fromJson(Map<String, dynamic> json) {
    return MeasurementData(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      ground: (json['ground'] ?? 0.0).toDouble(),
      voltage: (json['voltage'] ?? 0.0).toDouble(),
      frequency: (json['frequency'] ?? 0.0).toDouble(),
      mode: json['mode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'day': day,
    'time': time,
    'ground': ground,
    'voltage': voltage,
    'frequency': frequency,
    'mode': mode,
  };

  Map<String, String> toExcelMap() {
    final voltageText = '${voltage.toStringAsFixed(0)} Volt';
    final groundText = '${ground.toStringAsFixed(1)} Volt';
    final frequencyText = '${frequency.toStringAsFixed(0)} Hz';

    final dateTimeString = '$date $time';
    final parsed = DateFormat('dd-MM-yyyy HH:mm:ss').parse(dateTimeString);
    final formattedTime = DateFormat(
      'dd MMMM yyyy HH:mm:ss',
      'id_ID',
    ).format(parsed);

    // Status logic
    String status;
    if (mode == 5 || ground == 0.0) {
      status = "Fail - Ground Not Connected";
    } else if (ground >= 1.0) {
      status = "Fail - Ground Connected";
    } else {
      status = "Pass - Ground Connected";
    }

    return {
      'Time': formattedTime,
      'Ground': groundText,
      'Voltage': voltageText,
      'Frequency': frequencyText,
      'Status': status,
    };
  }
}
