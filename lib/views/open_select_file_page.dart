import 'package:flutter/material.dart';
import 'open_search_file_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/device_info_column.dart';
import '../widgets/exit_app_button.dart';

class OpenSelectFilePage extends StatelessWidget {
  const OpenSelectFilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [DateTimeDisplay(), DeviceInfoColumn()],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Open File'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Disconnect'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    fileItem("Test-1", "20/02/2025", "15kb"),
                    fileItem("Test-2", "21/02/2025", "10kb"),
                    fileItem("Test-3", "22/02/2025", "5kb", selected: true),
                    fileItem("Test-4", "23/02/2025", "21kb"),
                    fileItem("Test-5", "24/02/2025", "10kb"),
                    fileItem("Test-6", "25/02/2025", "30kb"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OpenSearchFilePage(),
                        ),
                      );
                    },
                    child: const Text('BACK'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('OPEN'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: // Exit App
                    const ExitAppButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fileItem(
    String title,
    String date,
    String size, {
    bool selected = false,
  }) {
    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: Colors.teal,
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(date, style: const TextStyle(color: Colors.white70)),
      trailing: Text(size, style: const TextStyle(color: Colors.white)),
    );
  }
}
