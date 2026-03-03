import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class ApiService {
  static final Dio _dio = Dio();

  static String get baseUrl =>
      '${dotenv.env['API_BASE_URL'] ?? 'https://web-production-dd806.up.railway.app'}/api';

  static Future<String?> _authHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null ? 'Bearer $token' : null;
  }

  // ── SOS History ─────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> getSosHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final auth = await _authHeader();
      if (auth == null) return {'reports': [], 'total': 0};
      final resp = await _dio.get(
        '$baseUrl/sos/history',
        queryParameters: {'limit': limit, 'offset': offset},
        options: Options(headers: {'Authorization': auth}),
      );
      if (resp.statusCode == 200 && resp.data['success'] == true) {
        return Map<String, dynamic>.from(resp.data);
      }
    } catch (e) {
      debugPrint('getSosHistory error: $e');
    }
    return {'reports': [], 'total': 0};
  }

  // ── Real-time Location Ping ──────────────────────────────────────────────

  static Future<Map<String, dynamic>?> pingLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    try {
      final auth = await _authHeader();
      if (auth == null) return null;
      final resp = await _dio.post(
        '$baseUrl/location/ping',
        data: {
          'latitude': latitude,
          'longitude': longitude,
          if (accuracy != null) 'accuracy': accuracy,
        },
        options: Options(headers: {'Authorization': auth}),
      );
      if (resp.statusCode == 200 && resp.data['success'] == true) {
        return Map<String, dynamic>.from(resp.data);
      }
    } catch (e) {
      debugPrint('pingLocation error: $e');
    }
    return null;
  }

  // Lấy tin tức (hỗ trợ phân trang + lọc danh mục)
  static Future<Map<String, dynamic>> getNews({
    int limit = 20,
    int offset = 0,
    String? category,
  }) async {
    try {
      final params = <String, dynamic>{'limit': limit, 'offset': offset};
      if (category != null && category != 'Tất cả') {
        params['category'] = category;
      }
      final response = await _dio.get('$baseUrl/news', queryParameters: params);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> newsData = response.data['news'] ?? [];
        final List<String> categories =
            List<String>.from(response.data['categories'] ?? []);
        return {
          'news': newsData.map((j) => NewsModel.fromJson(j)).toList(),
          'total': response.data['total'] ?? 0,
          'categories': categories,
        };
      }
      return {'news': <NewsModel>[], 'total': 0, 'categories': <String>[]};
    } catch (e) {
      print('Error fetching news: $e');
      return {'news': <NewsModel>[], 'total': 0, 'categories': <String>[]};
    }
  }
}

