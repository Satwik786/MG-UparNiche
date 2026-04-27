import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

enum TiltDirection { up, down, neutral }

class SensorService {
  StreamSubscription? _subscription;

  void startListening(Function(TiltDirection) onTilt) {
    _subscription = accelerometerEvents.listen((event) {
      final y = event.y;

      if (y < -7) {
        onTilt(TiltDirection.up);
      } else if (y > 7) {
        onTilt(TiltDirection.down);
      } else {
        onTilt(TiltDirection.neutral);
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
