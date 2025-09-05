import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';

class DeepLinkHandler {
  static const platform = MethodChannel('jaaduservices/channel');
  static bool _isInitialized = false;
  static final _appLinks = AppLinks();

  static Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // Handle deep links when app is already running
    _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) {
        print('Deep link error: $err');
      },
    );

    // Handle deep links when app is launched from terminated state
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } on PlatformException catch (e) {
      print('Deep link initial URI error: $e');
    }
  }

  static Future<void> _handleDeepLink(Uri uri) async {
    if (uri.host == 'digilocker') {
      // Extract authorization code from URI
      final code = uri.queryParameters['code'];
      if (code != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('digilocker_auth_code', code);
        // You can add a callback or event bus here to notify the UI
      }
    }
  }

  static Future<String?> getDigiLockerAuthCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('digilocker_auth_code');
  }
}
