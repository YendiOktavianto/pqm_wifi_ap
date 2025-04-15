import 'package:flutter/material.dart';
import 'main_menu_page.dart';
import 'connected_device_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/exit_app_button.dart';

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  int selectedIndex = 0;

  final List<Map<String, String>> devices = [
    {'type': 'PQM-500Wi', 'serial': '123456'},
    {'type': 'PQM-500Wi', 'serial': '777777'},
    {'type': 'PQM-500Wi', 'serial': '888888'},
    {'type': 'PQM-500Wi', 'serial': '999999'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Align(alignment: Alignment.topLeft, child: DateTimeDisplay()),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Voltage & Ground Measurement',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'LISTED DEVICE:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: List.generate(
                    devices.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: deviceItem(
                        devices[index]['type']!,
                        devices[index]['serial']!,
                        selectedIndex == index,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainMenuPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                    ),
                    child: const Text(
                      'BACK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                    ),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConnectedDevicePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                    ),
                    child: const Text(
                      'SELECT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Exit App
              const ExitAppButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget deviceItem(String type, String serial, bool selected) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            border:
                selected ? Border.all(color: Colors.blue, width: 1.5) : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'POWER QUALITY METER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'TYPE: $type\nSERIAL: $serial',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
