import 'package:flutter/material.dart';
import 'package:pqm_app/views/export_search_file_page.dart';
import 'device_list_page.dart';
import 'second_welcome_page.dart';
import 'open_search_file_page.dart';
import 'rename_file_page.dart';
import 'export_search_file_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/exit_app_button.dart';

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
            // Waktu
            Align(alignment: Alignment.topLeft, child: const DateTimeDisplay()),
            SizedBox(height: 20),

            // Tombol Bluetooth
            ElevatedButton.icon(
              onPressed: () {},
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bluetooth,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              label: Text(
                "Turn Bluetooth ON",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              ),
            ),
            SizedBox(height: 20),

            // Menu Buttons
            _buildMenuButton(
              "Voltage & Ground Measurement",
              "assets/images/Voltage_Ground_Measurement_Logo.png",
              context,
              DeviceListPage(),
            ),
            _buildMenuButton(
              "Open File",
              "assets/images/Open_File_Logo.png",
              context,
              OpenSearchFilePage(),
            ),
            _buildMenuButton(
              "Rename File",
              "assets/images/Rename_File_Logo.png",
              context,
              RenameFilePage(),
            ),
            _buildMenuButton(
              "Export File",
              "assets/images/Export_File_Logo.png",
              context,
              ExportSearchFilePage(),
            ),
            _buildMenuButton(
              "Setting",
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
                ),
                _buildActionButton("CANCEL", Colors.teal, context, null),
                _buildActionButton("SAVE", Colors.teal, context, null),
              ],
            ),
            SizedBox(height: 20),

            Center(child: const ExitAppButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    String title,
    String iconPath,
    BuildContext context,
    Widget? page,
  ) {
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
          if (page != null) {
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
    Widget? page,
  ) {
    return ElevatedButton(
      onPressed: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
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
