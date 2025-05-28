import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:http/http.dart' as http;
import '../../core/animations/page_transition.dart';
import '../../services/wifi_service.dart';
import '../../views/main_menu_page.dart';
import 'welcome_top_section.dart';
import 'welcome_bottom_section.dart';
import '../exit_app_button.dart';
import '../../views/measurement_page.dart';

class SecondWelcomeBody extends StatelessWidget {
  const SecondWelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const WelcomeTopSection(),
                  WelcomeBottomSection(
                    onConnect: () async {
                      final connected = await WifiService.isConnectedToESP();
                      if (connected) {
                        try {
                          final response = await http
                              .get(Uri.parse("http://192.168.4.1/status"))
                              .timeout(const Duration(seconds: 3));

                          if (response.statusCode == 200) {
                            final data = jsonDecode(response.body);
                            final mode = data["mode"];

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Connected to PQM (mode: $mode)"),
                              ),
                            );

                            await Future.delayed(const Duration(seconds: 1));

                            if (mode == 4) {
                              Navigator.pushReplacement(
                                context,
                                PageTransition.scaleFade(
                                  const MeasurementPage(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                PageTransition.scaleFade(const MainMenuPage()),
                              );
                            }
                          } else {
                            throw Exception("Invalid response from device");
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error reading status: $e")),
                          );
                        }
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
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const ExitAppButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
