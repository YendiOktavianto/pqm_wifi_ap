import 'package:flutter/material.dart';
import 'views/welcome_page.dart';
import 'package:provider/provider.dart';
import 'services/wifi_service.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WifiService())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: WelcomePage());
  }
}
