import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ExitPage extends StatelessWidget {
  const ExitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'ARE YOU SURE TO EXIT?',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('NO'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                child: const Text('YES'),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
