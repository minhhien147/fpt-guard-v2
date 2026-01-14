import 'package:dio/dio.dart';

/// Service để gọi API mực nước sông Mekong từ Python backend
class WaterLevelService {
  static final Dio _dio = Dio();
  
  // Base URL của Python Flask API trên Railway
  static const String baseUrl = 'https://web-production-7cfe9.up.railway.app/api';
  
  /// Lấy danh sách tất cả các trạm quan trắc
  static Future<Map<String, dynamic>?> getAllStations() async {
    try {
      final response = await _dio.get('$baseUrl/stations');
      
      if (response.statusCode == 200 && response.data['success']) {
        return response.data;
      }
      
      return null;
    } catch (e) {
      print('Error fetching stations: $e');
      return null;
    }
  }
  
  /// Lấy dữ liệu mới nhất của tất cả các trạm
  static Future<Map<String, dynamic>?> getLatestData() async {
    try {
      final response = await _dio.get('$baseUrl/latest');
      
      if (response.statusCode == 200 && response.data['success']) {
        return response.data['data'];
      }
      
      return null;
    } catch (e) {
      print('Error fetching latest data: $e');
      return null;
    }
  }
  
  /// Lấy dữ liệu chi tiết của một trạm cụ thể
  /// 
  /// [stationId] - ID của trạm: can_tho, my_thuan, vinh_long, tan_chau, chau_doc
  static Future<Map<String, dynamic>?> getStationData(String stationId) async {
    try {
      final response = await _dio.get('$baseUrl/stations/$stationId');
      
      if (response.statusCode == 200 && response.data['success']) {
        return response.data['data'];
      }
      
      return null;
    } catch (e) {
      print('Error fetching station data for $stationId: $e');
      return null;
    }
  }
  
  /// Lấy danh sách các cảnh báo hiện tại
  static Future<Map<String, dynamic>?> getAlerts() async {
    try {
      final response = await _dio.get('$baseUrl/alerts');
      
      if (response.statusCode == 200 && response.data['success']) {
        return response.data['data'];
      }
      
      return null;
    } catch (e) {
      print('Error fetching alerts: $e');
      return null;
    }
  }
  
  /// Trigger cập nhật dữ liệu thủ công
  static Future<bool> triggerUpdate() async {
    try {
      final response = await _dio.post('$baseUrl/update');
      
      if (response.statusCode == 200 && response.data['success']) {
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error triggering update: $e');
      return false;
    }
  }
  
  /// Lấy trạng thái của backend service
  static Future<Map<String, dynamic>?> getStatus() async {
    try {
      final response = await _dio.get('$baseUrl/status');
      
      if (response.statusCode == 200 && response.data['success']) {
        return response.data['data'];
      }
      
      return null;
    } catch (e) {
      print('Error fetching status: $e');
      return null;
    }
  }
  
  /// Health check
  static Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('$baseUrl/health');
      
      return response.statusCode == 200 && response.data['status'] == 'healthy';
    } catch (e) {
      print('Error in health check: $e');
      return false;
    }
  }
  
  /// Lấy dữ liệu lịch sử của một trạm
  /// 
  /// [stationId] - ID của trạm
  /// [limit] - Số lượng bản ghi tối đa (mặc định: 100)
  static Future<Map<String, dynamic>?> getHistoricalData(
    String stationId, {
    int limit = 100,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/historical/$stationId',
        queryParameters: {'limit': limit},
      );
      
      if (response.statusCode == 200 && response.data['success']) {
        return response.data['data'];
      }
      
      return null;
    } catch (e) {
      print('Error fetching historical data for $stationId: $e');
      return null;
    }
  }
}

