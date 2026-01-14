import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/safe_location_model.dart';
import '../services/location_service.dart';
import '../services/database_service.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String _currentAddress = '';
  bool _isLoading = false;
  List<SafeLocationModel> _safeLocations = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTracking = false;

  Position? get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;
  List<SafeLocationModel> get safeLocations => _safeLocations;
  bool get isTracking => _isTracking;

  double? get latitude => _currentPosition?.latitude;
  double? get longitude => _currentPosition?.longitude;

  // Lấy vị trí hiện tại
  Future<bool> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await LocationService.getCurrentPosition();
      
      if (position != null) {
        _currentPosition = position;
        
        // Lấy địa chỉ từ tọa độ
        _currentAddress = await LocationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error getting location: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Tải danh sách địa điểm an toàn
  Future<void> loadSafeLocations() async {
    try {
      _safeLocations = await DatabaseService.instance.getSafeLocations();
      
      // Tính khoảng cách nếu có vị trí hiện tại
      if (_currentPosition != null) {
        _safeLocations = _safeLocations.map((location) {
          final distanceKm = LocationService.calculateDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            location.latitude,
            location.longitude,
          );

          return SafeLocationModel(
            id: location.id,
            name: location.name,
            address: location.address,
            latitude: location.latitude,
            longitude: location.longitude,
            distance: (distanceKm * 1000).round(), // meters
            locationType: location.locationType,
            createdAt: location.createdAt,
          );
        }).toList();
        
        // Sắp xếp theo khoảng cách
        _safeLocations.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading safe locations: $e');
    }
  }

  // Cập nhật địa chỉ
  void updateAddress(String address) {
    _currentAddress = address;
    notifyListeners();
  }

  // Bắt đầu theo dõi vị trí liên tục
  void startLocationTracking() {
    if (_isTracking) return;

    _isTracking = true;
    _positionStreamSubscription = LocationService.getPositionStream().listen(
      (Position position) async {
        _currentPosition = position;
        
        // Lấy địa chỉ mới
        _currentAddress = await LocationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        // Cập nhật khoảng cách đến safe locations
        await loadSafeLocations();
        
        notifyListeners();
      },
      onError: (error) {
        print('Error tracking location: $error');
        _isTracking = false;
      },
    );
  }

  // Dừng theo dõi vị trí
  void stopLocationTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _isTracking = false;
    notifyListeners();
  }

  // Reset location
  void clearLocation() {
    stopLocationTracking();
    _currentPosition = null;
    _currentAddress = '';
    notifyListeners();
  }

  @override
  void dispose() {
    stopLocationTracking();
    super.dispose();
  }
}

