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
                          SnackBar(content: Text("Connected to PQM WIFI")),
                        );

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    MainMenuPage(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
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
