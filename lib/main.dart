import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kycapp/ui/home_screen.dart';
import 'firebase_options.dart';

import 'core/services/deep_link_handler.dart';

// Custom NavigatorObserver to track screen views
class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _trackScreenView(newRoute);
  }

  void _trackScreenView(Route<dynamic> route) {
    if (route.settings.name != null) {
      // Here you would integrate with an analytics service
      debugPrint('Screen viewed: ${route.settings.name}');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize deep link handling
  await DeepLinkHandler.initialize();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Start with the welcome page, but we'll have routes to the services dashboard after login
      home: const KYCHomeScreen(),
      routes: {'/home': (context) => const KYCHomeScreen()},
      navigatorObservers: [MyNavigatorObserver()],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
