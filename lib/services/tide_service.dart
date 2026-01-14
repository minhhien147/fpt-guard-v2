import '../models/tide_model.dart';

class TideService {
  // API endpoint cho dữ liệu triều cường (nếu có)
  // Hiện tại dùng mock data
  static const String baseUrl = 'https://api.example.com/tides'; // Thay bằng API thật nếu có

  // Lấy dữ liệu triều cường cho ngày hôm nay và các ngày tiếp theo
  static Future<List<TideModel>> getTideData({int days = 7}) async {
    try {
      // TODO: Thay bằng API call thật khi có
      // final response = await http.get(Uri.parse('$baseUrl?location=cantho&days=$days'));
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   return (data['tides'] as List).map((e) => TideModel.fromJson(e)).toList();
      // }
      
      // Mock data cho Cần Thơ
      return _getMockTideData(days);
    } catch (e) {
      print('Error fetching tide data: $e');
      return _getMockTideData(days);
    }
  }

  // Mock data dựa trên chu kỳ triều cường thực tế ở Cần Thơ
  static List<TideModel> _getMockTideData(int days) {
    final now = DateTime.now();
    final List<TideModel> tides = [];

    // Chu kỳ triều cường ở Cần Thơ: ~12 giờ 25 phút
    // Mực nước dao động từ 50-250cm
    for (int i = 0; i < days; i++) {
      final date = now.add(Duration(days: i));
      
      // Tính toán dựa trên chu kỳ triều
      final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
      final baseLevel = 120.0 + (dayOfYear % 14) * 5.0; // Dao động theo chu kỳ
      
      // Nước lên cao nhất vào buổi sáng và chiều
      final morningHigh = DateTime(date.year, date.month, date.day, 6 + (i % 2) * 6, 0);
      final afternoonHigh = DateTime(date.year, date.month, date.day, 12 + (i % 2) * 6, 0);
      
      // Nước xuống thấp nhất vào giữa ngày và đêm
      final noonLow = DateTime(date.year, date.month, date.day, 9 + (i % 2) * 6, 0);
      final nightLow = DateTime(date.year, date.month, date.day, 21 + (i % 2) * 6, 0);

      // Chọn cao nhất và thấp nhất trong ngày
      final highTide = morningHigh.isAfter(now) ? morningHigh : afternoonHigh;
      final lowTide = noonLow.isAfter(now) ? noonLow : nightLow;
      
      final highLevel = baseLevel + 80.0 + (i % 3) * 20.0;
      final lowLevel = baseLevel - 60.0 - (i % 3) * 15.0;

      String? warning;
      if (highLevel >= 200) {
        warning = '⚠️ Cảnh báo: Mực nước cao, cẩn thận khi di chuyển';
      } else if (highLevel >= 180) {
        warning = '⚠️ Mực nước khá cao, lưu ý khi đi đường';
      }

      tides.add(TideModel(
        id: i,
        date: date,
        highTideLevel: highLevel,
        highTideTime: highTide,
        lowTideLevel: lowLevel,
        lowTideTime: lowTide,
        warning: warning,
        location: 'Cần Thơ',
      ));
    }

    return tides;
  }

  // Lấy dữ liệu triều cường hôm nay
  static Future<TideModel?> getTodayTide() async {
    final tides = await getTideData(days: 1);
    return tides.isNotEmpty ? tides.first : null;
  }
}

