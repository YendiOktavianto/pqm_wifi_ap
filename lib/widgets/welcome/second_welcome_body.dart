import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import '../../services/wifi_service.dart';
import '../../views/main_menu_page.dart';
import 'welcome_top_section.dart';
import 'welcome_bottom_section.dart';
import '../exit_app_button.dart';

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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Connected to PQM!")),
                        );
                        await Future.delayed(const Duration(seconds: 1));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainMenuPage(),
                          ),
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
