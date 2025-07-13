// main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/shake_service.dart';
import 'services/voice_service.dart';
import 'services/fake_call_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ShakeService(
    onShake: () {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => FakeCallService()),
      );
    },
  ).startListening();

  VoiceService(onSOSDetected: () {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => FakeCallService()),
    );
  }).startListening();

  runApp(const FeelSafeApp());
}

class FeelSafeApp extends StatelessWidget {
  const FeelSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FeelSafe',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomeScreen(),
    );
  }
}
