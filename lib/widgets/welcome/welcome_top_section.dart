import 'package:flutter/material.dart';

class WelcomeTopSection extends StatelessWidget {
  const WelcomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          'PQM',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.1,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/Logo_PQM.png',
          width: MediaQuery.of(context).size.width * 0.4,
        ),
        const SizedBox(height: 10),
        const Text(
          'Power Quality Meter',
          style: TextStyle(fontSize: 16, color: Colors.blueAccent),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
