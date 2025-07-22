import 'package:flutter/material.dart';
import '../views/exit_page.dart';

class ExitAppButton extends StatelessWidget {
  const ExitAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExitPage()),
        );
      },
      icon: const Icon(Icons.exit_to_app, color: Colors.white),
      label: const Text(
        'Exit App',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
