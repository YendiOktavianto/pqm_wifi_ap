import 'package:flutter/material.dart';
import '../widgets/welcome/second_welcome_body.dart';

class SecondWelcomePage extends StatelessWidget {
  const SecondWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SecondWelcomeBody(),
    );
  }
}
