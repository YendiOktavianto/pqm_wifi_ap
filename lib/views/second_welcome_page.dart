import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'main_menu_page.dart';
import '../widgets/exit_app_button.dart';
import '../services/wifi_service.dart';

class SecondWelcomePage extends StatelessWidget {
  const SecondWelcomePage({super.key});

  Future<bool> isConnectedToESP() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.4.1/'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Spacer(),

          Center(
            child: Column(
              children: [
                Text(
                  'PQM',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                Image.asset(
                  'assets/images/Logo_PQM.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                SizedBox(height: 10),

                Text(
                  'Power Quality Meter',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'WELCOME TO PQM 2.0',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'POWER QUALITY METER (PQM) 2.0 IS A MOBILE APPLICATION THAT INTEGRATES WITH A SMART MEASURING DEVICE TO MEASURE VOLTAGE AND GROUND THROUGH A WIRELESS CONNECTION.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'TO CONNECT THIS APP TO PQM DEVICE, PLEASE MAKE SURE WIFI CONNECTION IS ON.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Spacer(),

          Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final connected = await isConnectedToESP();
                  if (connected) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Connected to PQM!"),
                      ),
                    );
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainMenuPage()),
                    );
                  } else {
                    AppSettings.openAppSettings(type: AppSettingsType.wifi);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Failed Connect to PQM.\nPlease connect to PQM WiFi first!",
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  "CHECK & CONNECT TO PQM WI-FI",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
          SizedBox(height: 20),
          const ExitAppButton(),
        ],
      ),
    );
  }
}
