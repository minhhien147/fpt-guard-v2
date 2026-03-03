import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lưu & giám sát khu vực an toàn (geofence).
/// Khi user rời khỏi vùng → gọi [onBreach].
class GeofenceService {
  static final GeofenceService _instance = GeofenceService._();
  factory GeofenceService() => _instance;
  GeofenceService._();

  static const _keyEnabled  = 'geofence_enabled';
  static const _keyName     = 'geofence_name';
  static const _keyLat      = 'geofence_lat';
  static const _keyLng      = 'geofence_lng';
  static const _keyRadius   = 'geofence_radius_m';

  StreamSubscription<Position>? _sub;
  void Function(double lat, double lng, double distanceM)? onBreach;

  bool _insideZone = true;
  bool _isRunning  = false;
  bool get isRunning => _isRunning;

  // ── Persist ──────────────────────────────────────────────────────────────

  static Future<void> save({
    required bool enabled,
    required String name,
    required double lat,
    required double lng,
    required double radiusM,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyEnabled, enabled);
    await p.setString(_keyName, name);
    await p.setDouble(_keyLat, lat);
    await p.setDouble(_keyLng, lng);
    await p.setDouble(_keyRadius, radiusM);
  }

  static Future<Map<String, dynamic>?> load() async {
    final p = await SharedPreferences.getInstance();
    if (!p.containsKey(_keyLat)) return null;
    return {
      'enabled':  p.getBool(_keyEnabled) ?? false,
      'name':     p.getString(_keyName) ?? 'Khu vực an toàn',
      'lat':      p.getDouble(_keyLat)!,
      'lng':      p.getDouble(_keyLng)!,
      'radiusM':  p.getDouble(_keyRadius) ?? 200,
    };
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyEnabled);
    await p.remove(_keyName);
    await p.remove(_keyLat);
    await p.remove(_keyLng);
    await p.remove(_keyRadius);
  }

  // ── Monitoring ───────────────────────────────────────────────────────────

  Future<void> start() async {
    if (_isRunning) return;
    final cfg = await load();
    if (cfg == null || cfg['enabled'] != true) return;

    final hasPermission = await Geolocator.checkPermission();
    if (hasPermission == LocationPermission.denied ||
        hasPermission == LocationPermission.deniedForever) return;

    final centerLat = cfg['lat'] as double;
    final centerLng = cfg['lng'] as double;
    final radiusM   = cfg['radiusM'] as double;

    _isRunning  = true;
    _insideZone = true;

    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 20,
      ),
    ).listen((pos) {
      final dist = Geolocator.distanceBetween(
        centerLat, centerLng,
        pos.latitude, pos.longitude,
      );
      final outside = dist > radiusM;
      if (outside && _insideZone) {
        _insideZone = false;
        onBreach?.call(pos.latitude, pos.longitude, dist);
      } else if (!outside) {
        _insideZone = true;
      }
    });

    debugPrint('GeofenceService started – center ($centerLat,$centerLng) radius ${radiusM}m');
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
    _isRunning  = false;
    _insideZone = true;
    debugPrint('GeofenceService stopped');
  }
}
