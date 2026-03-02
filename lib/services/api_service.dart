import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_model.dart';

class ApiService {
  static final Dio _dio = Dio();
  
  // Base URL cho backend Flask trên Railway
  static String get baseUrl => '${dotenv.env['API_BASE_URL'] ?? 'https://web-production-dd806.up.railway.app'}/api';

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

