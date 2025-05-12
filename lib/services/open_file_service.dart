import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/services.dart';

class OpenFileService {
  static Future<void> openFileManager() async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.GET_CONTENT',
        type: "*/*",
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );

      await intent.launch();
    } on PlatformException catch (e) {
      throw Exception("Gagal membuka file manager: $e");
    }
  }
}
