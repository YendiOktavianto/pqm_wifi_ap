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
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Spacer(flex: 1),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PQM',
                  style: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                Image.asset(
                  'assets/images/Logo_PQM.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                SizedBox(height: 10),

                Text(
                  'Power Quality Meter',
                  style: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.width * 0.04, // Responsive
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),

          Spacer(flex: 1),

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
