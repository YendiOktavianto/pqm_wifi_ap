import 'package:http/http.dart' as http;

class WifiService {
  static Future<bool> isConnectedToESP() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.4.1/'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<void> triggerScan() async {
    await http.get(Uri.parse('http://192.168.4.1/scan'));
  }
}
