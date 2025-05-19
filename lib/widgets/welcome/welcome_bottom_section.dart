// welcome_bottom_section.dart
import 'package:flutter/material.dart';

class WelcomeBottomSection extends StatelessWidget {
  final VoidCallback onConnect;

  const WelcomeBottomSection({super.key, required this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: const [
              Text(
                'WELCOME TO PQM 2.0',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'POWER QUALITY METER (PQM) 2.0 IS A MOBILE APPLICATION THAT INTEGRATES WITH A SMART MEASURING DEVICE TO MEASURE VOLTAGE AND GROUND THROUGH A WIRELESS CONNECTION.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'TO CONNECT THIS APP TO PQM DEVICE, PLEASE MAKE SURE WIFI CONNECTION IS ON.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: onConnect,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: const Text(
            "CHECK & CONNECT TO PQM WI-FI",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
