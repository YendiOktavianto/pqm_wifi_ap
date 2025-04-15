import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_menu_page.dart';
import 'export_select_file_page.dart';
import '../widgets/date_time_display.dart';
import '../widgets/device_info_column.dart';
import '../widgets/exit_app_button.dart';

class ExportSearchFilePage extends StatelessWidget {
  const ExportSearchFilePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [DateTimeDisplay(), DeviceInfoColumn()],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text('Export File'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text('Disconnect'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Search By Name',
                    style: TextStyle(color: Colors.white),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search file',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Search By Date',
                    style: TextStyle(color: Colors.white),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'dd/mm/yyyy',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('Browse File'),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainMenuPage(),
                            ),
                          );
                        },
                        child: const Text('BACK'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                        ),
                        onPressed: () {},
                        child: const Text('CANCEL'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const ExportSelectFilePage(),
                            ),
                          );
                        },
                        child: const Text('SEARCH'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(child: const ExitAppButton()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
