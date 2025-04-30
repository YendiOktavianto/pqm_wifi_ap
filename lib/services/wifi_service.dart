import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:app_settings/app_settings.dart';
import 'package:android_intent_plus/android_intent.dart';

class WifiService extends ChangeNotifier {
  bool _isWifiOn = false;

  bool get isWifiOn => _isWifiOn;

  Future<void> toggleWifi() async {
    print("[WIFI] Button pressed");

    try {
      bool? isEnabled = await WiFiForIoTPlugin.isEnabled();
      print("[WIFI] isEnabled: $isEnabled");

      if (isEnabled == true && _isWifiOn == true) {
        print("[WIFI] Disabling...");
        await WiFiForIoTPlugin.setEnabled(false);
        _isWifiOn = false;
        print("[WIFI] Disabled.");
      } else {
        print("[WIFI] Enabling...");
        await WiFiForIoTPlugin.setEnabled(true);
        _isWifiOn = true;
        print("[WIFI] Enabled.");

        final intent = AndroidIntent(action: 'android.settings.WIFI_SETTINGS');
        await intent.launch();
        print("[WIFI] Launched Wi-Fi Settings.");
      }

      notifyListeners();
    } catch (e) {
      print("[WIFI] Error: $e");
    }
  }
}
