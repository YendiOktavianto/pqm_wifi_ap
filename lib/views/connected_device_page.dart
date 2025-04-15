import 'package:flutter/material.dart';
import 'device_list_page.dart';
import 'measurement_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/measurement_label.dart';
import '../widgets/exit_app_button.dart';

class ConnectedDevicePage extends StatelessWidget {
  const ConnectedDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentTime = '15:40';
    final String currentDate = 'Wed, February 21';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.topLeft,
                child: DateTimeDisplay(),
              ),
              const SizedBox(height: 20),
              const MeasurementLabel(),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'CONNECTED DEVICE:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'POWER QUALITY METER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'TYPE: PQM-500Wi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'SERIAL# 123456',
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeviceListPage(),
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MeasurementPage(),
                        ),
                      );
                    },
                    child: const Text('SCAN'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const ExitAppButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
