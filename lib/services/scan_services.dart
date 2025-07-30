import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScanService {
  static Future<void> startScanMode({
    required BuildContext context,
    required VoidCallback onStart,
    required VoidCallback onEnd,
  }) async {
    onStart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Scanning... Please wait"),
              ],
            ),
          ),
    );

    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/scan'));
      if (response.statusCode != 200) {
        debugPrint("Scan request failed with status: \${response.statusCode}");
      }
      await Future.delayed(const Duration(seconds: 4));
    } catch (e) {
      debugPrint("Failed to scan: \$e");
    } finally {
      if (context.mounted) Navigator.pop(context);
      onEnd();
    }
  }
}
