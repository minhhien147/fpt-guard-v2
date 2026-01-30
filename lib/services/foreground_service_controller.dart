import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Bridge Flutter <-> Android Foreground Service (SOSForegroundService)
class ForegroundServiceController {
  static const MethodChannel _channel =
      MethodChannel('com.fpt.guard.v2/sos_service');

  static Future<void> start() async {
    try {
      await _channel.invokeMethod('startService');
    } catch (e) {
      debugPrint('Error starting foreground service: $e');
    }
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stopService');
    } catch (e) {
      debugPrint('Error stopping foreground service: $e');
    }
  }
}

