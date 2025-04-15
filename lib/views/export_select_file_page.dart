import 'package:flutter/material.dart';
import 'export_search_file_page.dart';
import '../widgets/exit_app_button.dart';

class ExportSelectFilePage extends StatefulWidget {
  const ExportSelectFilePage({super.key});

  @override
  State<ExportSelectFilePage> createState() => _ExportSelectFilePageState();
}

class _ExportSelectFilePageState extends State<ExportSelectFilePage> {
  int? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "15:40",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      const Text(
                        "Wed, February 21",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Export File"),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.wifi, color: Colors.white, size: 40),
                      const Text(
                        "Connected Device:",
                        style: TextStyle(color: Colors.white),
                      ),
                      const Text(
                        "PQM-500wi SN#",
                        style: TextStyle(color: Colors.amber),
                      ),
                      const Text(
                        "123456",
                        style: TextStyle(color: Colors.amber),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Disconnect"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Select File",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _fileItem(1, "Test-1", "20/02/2025", "15kb"),
                    _fileItem(2, "Test-2", "21/02/2025", "10kb"),
                    _fileItem(3, "Test-3", "22/02/2025", "5kb"),
                    _fileItem(4, "Test-4", "23/02/2025", "21kb"),
                    _fileItem(5, "Test-5", "24/02/2025", "10kb"),
                    _fileItem(6, "Test-6", "25/02/2025", "30kb"),
                    const SizedBox(height: 20),
                    const Text(
                      "Select Destination",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.white,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Select destination here",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Browse"),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExportSearchFilePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("BACK"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("CANCEL"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("EXPORT"),
                  ),
                ],
              ),
            ),
            Center(child: const ExitAppButton()),
          ],
        ),
      ),
    );
  }

  Widget _fileItem(int value, String title, String date, String size) {
    return RadioListTile(
      value: value,
      groupValue: selectedFile,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        "$date | $size",
        style: const TextStyle(color: Colors.white70),
      ),
      activeColor: Colors.teal,
      onChanged: (val) {
        setState(() {
          selectedFile = val;
        });
      },
    );
  }
}
