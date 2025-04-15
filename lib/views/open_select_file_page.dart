import 'package:flutter/material.dart';
import 'open_search_file_page.dart';
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '15:40',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Wed, February 21',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 45),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Open File'),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.wifi, color: Colors.white, size: 40),
                      const SizedBox(height: 8),
                      const Text(
                        'Connected Device:',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Text(
                        'PQM-500wl SN#',
                        style: TextStyle(color: Colors.amber),
                      ),
                      const Text(
                        '123456',
                        style: TextStyle(color: Colors.amber),
                      ),
                      const SizedBox(height: 10),
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
