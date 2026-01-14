import 'package:flutter/material.dart';
import '../models/water_level_model.dart';
import '../services/water_level_service.dart';

/// Provider quản lý state cho dữ liệu mực nước
class WaterLevelProvider with ChangeNotifier {
  Map<String, WaterLevelStation> _stations = {};
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;
  bool _isBackendHealthy = false;

  Map<String, WaterLevelStation> get stations => _stations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;
  bool get isBackendHealthy => _isBackendHealthy;
  
  /// Lấy danh sách trạm có cảnh báo
  List<WaterLevelStation> get alertStations {
    return _stations.values
        .where((station) => 
            station.alert.level == 'WARNING' || 
            station.alert.level == 'CRITICAL')
        .toList();
  }
  
  /// Kiểm tra có cảnh báo nghiêm trọng không
  bool get hasCriticalAlerts {
    return _stations.values.any((station) => station.alert.isCritical);
  }

  /// Khởi tạo và load dữ liệu
  Future<void> initialize() async {
    await checkBackendHealth();
    if (_isBackendHealthy) {
      await loadAllStations();
    }
  }

  /// Kiểm tra backend có hoạt động không
  Future<bool> checkBackendHealth() async {
    try {
      _isBackendHealthy = await WaterLevelService.healthCheck();
      notifyListeners();
      return _isBackendHealthy;
    } catch (e) {
      _isBackendHealthy = false;
      _error = 'Không thể kết nối tới backend: $e';
      notifyListeners();
      return false;
    }
  }

  /// Load dữ liệu tất cả các trạm
  Future<void> loadAllStations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await WaterLevelService.getLatestData();
      
      if (data != null && data['stations'] != null) {
        _stations.clear();
        
        final stationsData = data['stations'] as Map<String, dynamic>;
        stationsData.forEach((key, value) {
          _stations[key] = WaterLevelStation.fromJson(value);
        });
        
        _lastUpdated = DateTime.now();
        _error = null;
      } else {
        _error = 'Không có dữ liệu từ server';
      }
    } catch (e) {
      _error = 'Lỗi khi tải dữ liệu: $e';
      print('Error loading stations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load dữ liệu một trạm cụ thể
  Future<WaterLevelStation?> loadStation(String stationId) async {
    try {
      final data = await WaterLevelService.getStationData(stationId);
      
      if (data != null) {
        final station = WaterLevelStation.fromJson(data);
        _stations[stationId] = station;
        notifyListeners();
        return station;
      }
      return null;
    } catch (e) {
      print('Error loading station $stationId: $e');
      return null;
    }
  }

  /// Lấy thông tin một trạm từ cache
  WaterLevelStation? getStation(String stationId) {
    return _stations[stationId];
  }

  /// Trigger cập nhật dữ liệu thủ công
  Future<bool> triggerUpdate() async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await WaterLevelService.triggerUpdate();
      
      if (success) {
        // Đợi 2 giây để server cập nhật xong
        await Future.delayed(const Duration(seconds: 2));
        await loadAllStations();
        return true;
      }
      
      _error = 'Không thể trigger cập nhật';
      return false;
    } catch (e) {
      _error = 'Lỗi khi trigger update: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh dữ liệu (pull to refresh)
  Future<void> refresh() async {
    await loadAllStations();
  }

  /// Xóa lỗi
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

