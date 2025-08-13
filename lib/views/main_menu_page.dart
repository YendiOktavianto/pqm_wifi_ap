import 'package:flutter/material.dart';
import 'package:pqm_app/views/rename_file_page.dart';
import '../controller/measurement_controller.dart';
import '../widgets/dialog/open_file_dialog.dart';
import '../widgets/measurement/date_time_display.dart';
import '../widgets/exit_app_button.dart';
import '../widgets/menu/menu_button.dart';
import '../widgets/menu/action_button.dart';
import '../services/open_file_service.dart';
import '../core/animations/slide_route.dart';
import 'package:provider/provider.dart';
import 'measurement_log_page.dart';
import 'measurement_page.dart';
import 'second_welcome_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 40),
            const Align(alignment: Alignment.topLeft, child: DateTimeDisplay()),
            const SizedBox(height: 40),

            // Menu Buttons
            MenuButton(
              title: "Voltage & Ground Measurement",
              iconPath: "assets/images/Voltage_Ground_Measurement_Logo.png",
              onTap: () {
                context.read<MeasurementController>().setMode(2);
                Navigator.push(
                  context,
                  createSlideRoute(
                    const MeasurementPage(),
                    beginOffset: const Offset(1.0, 0.0),
                  ),
                );
              }, // Slide dari kanan
            ),
            MenuButton(
              title: "Open File",
              iconPath: "assets/images/Open_File_Logo.png",
              onTap: () {
                showOpenFileDialog(
                  context: context,
                  onOpenFileManager: () async {
                    try {
                      await OpenFileService.openFileManager();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to open file manager: $e"),
                        ),
                      );
                    }
                  },
                  onViewTable: () {
                    Navigator.push(
                      context,
                      createSlideRoute(
                        const MeasurementLogPage(),
                        beginOffset: const Offset(1.0, 0.0),
                      ),
                    );
                  },
                );
              },
            ),
            MenuButton(
              title: "Rename File",
              iconPath: "assets/images/Rename_File_Logo.png",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RenameFilePage()),
                );
              },
            ),

            const SizedBox(height: 20),
            const Spacer(),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  title: "BACK",
                  color: Colors.teal,
                  page: const SecondWelcomePage(),
                  beginOffset: const Offset(-1.0, 0.0), // Slide dari kiri
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Center(child: ExitAppButton()),
          ],
        ),
      ),
    );
  }
}
