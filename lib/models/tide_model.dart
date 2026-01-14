class TideModel {
  final int id;
  final DateTime date;
  final double highTideLevel; // Mực nước cao nhất (cm)
  final DateTime highTideTime; // Thời gian nước lên cao nhất
  final double lowTideLevel; // Mực nước thấp nhất (cm)
  final DateTime lowTideTime; // Thời gian nước xuống thấp nhất
  final String? warning; // Cảnh báo nếu có
  final String location; // Địa điểm

  TideModel({
    required this.id,
    required this.date,
    required this.highTideLevel,
    required this.highTideTime,
    required this.lowTideLevel,
    required this.lowTideTime,
    this.warning,
    this.location = 'Cần Thơ',
  });

  factory TideModel.fromJson(Map<String, dynamic> json) {
    return TideModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      highTideLevel: json['high_tide_level']?.toDouble() ?? 0.0,
      highTideTime: DateTime.parse(json['high_tide_time']),
      lowTideLevel: json['low_tide_level']?.toDouble() ?? 0.0,
      lowTideTime: DateTime.parse(json['low_tide_time']),
      warning: json['warning'],
      location: json['location'] ?? 'Cần Thơ',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'high_tide_level': highTideLevel,
      'high_tide_time': highTideTime.toIso8601String(),
      'low_tide_level': lowTideLevel,
      'low_tide_time': lowTideTime.toIso8601String(),
      'warning': warning,
      'location': location,
    };
  }

  // Kiểm tra có cảnh báo không
  bool get hasWarning => warning != null && warning!.isNotEmpty;

  // Mức độ cảnh báo
  String get warningLevel {
    if (highTideLevel >= 200) return 'Cao';
    if (highTideLevel >= 180) return 'Trung bình';
    return 'Bình thường';
  }

  // Màu cảnh báo
  String get warningColor {
    if (highTideLevel >= 200) return 'Đỏ';
    if (highTideLevel >= 180) return 'Cam';
    return 'Xanh';
  }
}

