import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

typedef ShakeCallback = void Function();

class ShakeService {
  final double shakeThresholdGravity;
  final int shakeSlopTimeMs;
  final ShakeCallback onShake;

  StreamSubscription? _accelerometerSubscription;
  int _lastShakeTimestamp = 0;

  ShakeService({
    required this.onShake,
    this.shakeThresholdGravity = 2.7,
    this.shakeSlopTimeMs = 500,
  });

  void startListening() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      final gX = event.x / 9.80665;
      final gY = event.y / 9.80665;
      final gZ = event.z / 9.80665;

      final gForce = sqrt(gX * gX + gY * gY + gZ * gZ);
      final now = DateTime.now().millisecondsSinceEpoch;

      if (gForce > shakeThresholdGravity) {
        if (_lastShakeTimestamp + shakeSlopTimeMs < now) {
          _lastShakeTimestamp = now;
          onShake();
        }
      }
    });
  }

  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }
}
