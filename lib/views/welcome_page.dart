import 'package:flutter/material.dart';
import 'dart:async';
import 'second_welcome_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // Delay selama 10 detik, lalu pindah ke Main Menu
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SecondWelcomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background sesuai gambar
      body: Column(
        children: [
          Spacer(flex: 1), // Memberi ruang lebih di atas agar teks PQM turun

          // Bagian utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Teks PQM
                Text(
                  'PQM',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.1, // Responsive
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                // Logo PQM (dengan ukuran responsif)
                Image.asset(
                  'assets/images/Logo_PQM.png',
                  width: MediaQuery.of(context).size.width * 0.4, // 40% dari layar
                ),
                SizedBox(height: 10),

                // Subtitle "Power Quality Meter"
                Text(
                  'Power Quality Meter',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),

          Spacer(flex: 1), // Memberi sedikit ruang antara bagian tengah dan bawah

          // Bagian bawah (Powered by TwaTech)
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Text(
              'Powered by:\nTwaTech',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
