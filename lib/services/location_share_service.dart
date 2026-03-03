import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location_service.dart';
import 'api_service.dart';

/// Khi chế độ bảo vệ bật (Pro), ping vị trí lên server mỗi 60 giây.
/// Server lưu và tạo link công khai để người thân xem real-time.
class LocationShareService {
  static final LocationShareService _i = LocationShareService._();
  factory LocationShareService() => _i;
  LocationShareService._();

  Timer? _timer;
  String? _shareUrl;
  bool get isActive => _timer != null;
  String? get shareUrl => _shareUrl;

  static const _keyShareUrl = 'location_share_url';

  Future<void> start() async {
    if (_timer != null) return;
    // Restore saved url
    final prefs = await SharedPreferences.getInstance();
    _shareUrl = prefs.getString(_keyShareUrl);

    // Ping immediately then every 60s
    await _ping();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => _ping());
    debugPrint('LocationShareService started');
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    debugPrint('LocationShareService stopped');
  }

  Future<void> _ping() async {
    try {
      final pos = await LocationService.getCurrentPosition();
      if (pos == null) return;
      final result = await ApiService.pingLocation(
        latitude: pos.latitude,
        longitude: pos.longitude,
        accuracy: pos.accuracy,
      );
      if (result != null && result['share_url'] != null) {
        _shareUrl = result['share_url'] as String;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyShareUrl, _shareUrl!);
        debugPrint('Location pinged → $_shareUrl');
      }
    } catch (e) {
      debugPrint('LocationShareService._ping error: $e');
    }
  }

  Future<String?> getShareUrl() async {
    if (_shareUrl != null) return _shareUrl;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyShareUrl);
  }
}
