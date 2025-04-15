import 'package:flutter/material.dart';
import 'package:pqm_app/views/main_menu_page.dart';
import '../widgets/exit_app_button.dart';

class RenameFilePage extends StatelessWidget {
  const RenameFilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '15:40',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Wed, February 21',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Icon(Icons.wifi, color: Colors.white, size: 36),
                      SizedBox(height: 4),
                      Text(
                        'Connected Device:',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        'PQM-500Wi SN#',
                        style: TextStyle(color: Colors.yellow, fontSize: 12),
                      ),
                      Text(
                        '123456',
                        style: TextStyle(color: Colors.yellow, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {},
                    child: const Text("Rename File"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {},
                    child: const Text("Disconnect"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Old Filename', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search file',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('New Filename', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter new filename here',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainMenuPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'BACK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(child: const ExitAppButton()),
            ],
          ),
        ),
      ),
    );
  }
}
