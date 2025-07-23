import 'package:flutter/material.dart';
import 'measurement_page.dart';
import 'second_welcome_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/exit_app_button.dart';
import '../services/open_file_service.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 40),
            Align(alignment: Alignment.topLeft, child: const DateTimeDisplay()),
            SizedBox(height: 40),
            // Menu Buttons
            _buildMenuButton(
              "Voltage & Ground Measurement",
              "assets/images/Voltage_Ground_Measurement_Logo.png",
              context,
              MeasurementPage(),
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  createSlideRoute(
                    const MeasurementPage(),
                    beginOffset: const Offset(1.0, 0.0), // slide kanan
                  ),
                );
              },
            ),
            _buildMenuButton(
              "Open File",
              "assets/images/Open_File_Logo.png",
              context,
              null,
              onTap: () async {
                try {
                  await OpenFileService.openFileManager();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuka file manager: $e')),
                  );
                }
              },
            ),
            _buildMenuButton(
              "Rename File (Under Development)",
              "assets/images/Rename_File_Logo.png",
              context,
              null,
            ),

            _buildMenuButton(
              "Export File (Under Development)",
              "assets/images/Export_File_Logo.png",
              context,
              null,
            ),

            _buildMenuButton(
              "Setting (Under Development)",
              "assets/images/Setting_Logo.png",
              context,
              null,
            ),
            SizedBox(height: 20),
            Spacer(),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  "BACK",
                  Colors.teal,
                  context,
                  SecondWelcomePage(),
                  beginOffset: const Offset(-1.0, 0.0),
                ),
              ],
            ),
            SizedBox(height: 20),

            Center(child: const ExitAppButton()),
          ],
        ),
      ),
    );
  }

  PageRouteBuilder createSlideRoute(
    Widget page, {
    required Offset beginOffset,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(
          begin: beginOffset,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  Widget _buildMenuButton(
    String title,
    String iconPath,
    BuildContext context,
    Widget? page, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[900],
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if (onTap != null) {
            onTap();
          } else if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
            Image.asset(iconPath, width: 28, height: 28, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    Color color,
    BuildContext context,
    Widget? page, {
    required Offset beginOffset,
  }) {
    return ElevatedButton(
      onPressed: () {
        if (page != null) {
          Navigator.pushReplacement(
            context,
            createSlideRoute(page, beginOffset: beginOffset),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
    );
  }
}
