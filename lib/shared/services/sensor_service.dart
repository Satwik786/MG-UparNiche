import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

enum TiltDirection { up, down, neutral }

class SensorService {
  StreamSubscription? _subscription;

  void startListening(Function(TiltDirection) onTilt) {
    _subscription = accelerometerEvents.listen((event) {
      final y = event.y; // 🔥 use Y axis for forward/back tilt

      if (y < -6) {
        onTilt(TiltDirection.up); // ✅ Correct (forward tilt)
      } else if (y > 6) {
        onTilt(TiltDirection.down); // ❌ Skip (back tilt)
      } else {
        onTilt(TiltDirection.neutral);
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
