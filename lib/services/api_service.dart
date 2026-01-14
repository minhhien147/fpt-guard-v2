import 'package:dio/dio.dart';
import '../models/news_model.dart';

class ApiService {
  static final Dio _dio = Dio();
  
  // Base URL cho backend Flask trên Railway
  static const String baseUrl = 'https://web-production-dd806.up.railway.app/api';

  // Lấy tin tức
  static Future<List<NewsModel>> getNews() async {
    try {
      final response = await _dio.get('$baseUrl/news');
      
      if (response.statusCode == 200 && response.data['success']) {
        final List<dynamic> newsData = response.data['news'];
        return newsData.map((json) => NewsModel.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error fetching news: $e');
      return _getSampleNews();
    }
  }

  // Dữ liệu tin tức mẫu
  static List<NewsModel> _getSampleNews() {
    return [
      NewsModel(
        id: 1,
        title: 'Cần Thơ: Tăng cường tuần tra đảm bảo an ninh trật tự khu vực trường học',
        description: 'Lực lượng Công an TP Cần Thơ đã triển khai kế hoạch tăng cường tuần tra, bảo vệ an ninh trật tự tại các khu vực trường học.',
        link: 'https://baocantho.com.vn/',
        published: DateTime.now().toIso8601String(),
        source: 'Báo Cần Thơ',
        category: 'An ninh',
      ),
      NewsModel(
        id: 2,
        title: 'Triển khai camera an ninh thông minh tại các điểm công cộng',
        description: 'UBND TP Cần Thơ đã phê duyệt dự án lắp đặt hệ thống camera giám sát an ninh thông minh.',
        link: 'https://baocantho.com.vn/',
        published: DateTime.now().toIso8601String(),
        source: 'Báo Cần Thơ',
        category: 'Xã hội',
      ),
      NewsModel(
        id: 3,
        title: 'Phát động chiến dịch "Sinh viên tự bảo vệ mình"',
        description: 'Đoàn thanh niên TP Cần Thơ phối hợp với Công an thành phố tổ chức chuỗi hoạt động nâng cao kỹ năng tự bảo vệ cho sinh viên.',
        link: 'https://baocantho.com.vn/',
        published: DateTime.now().toIso8601String(),
        source: 'Báo Cần Thơ',
        category: 'Giáo dục',
      ),
    ];
  }
}

