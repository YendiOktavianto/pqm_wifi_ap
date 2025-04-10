import 'package:flutter/material.dart';
import 'main_menu_page.dart';

class SecondWelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Spacer(),

          // Logo dan teks utama
          Center(
            child: Column(
              children: [
                Text(
                  'PQM',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                Image.asset(
                  'assets/images/Logo_PQM.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                SizedBox(height: 10),

                Text(
                  'Power Quality Meter',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
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
                        'TO CONNECT THIS APP TO PQM DEVICE, PLEASE MAKE SURE BLUETOOTH CONNECTION IS ON.',
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
              ],
            ),
          ),

          Spacer(),

          // Tombol untuk mengaktifkan Bluetooth dan masuk ke menu utama
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Logika mengaktifkan Bluetooth
                },
                icon: Icon(Icons.bluetooth, color: Colors.white,),
                label: Text(
                  "Turn Bluetooth ON",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke Main Menu Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainMenuPage()),
                  );
                },
                child: Text("MAIN MENU", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.exit_to_app, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Exit App",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
