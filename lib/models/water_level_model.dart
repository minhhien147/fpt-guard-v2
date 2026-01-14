/// Model cho dữ liệu mực nước từ API
class WaterLevelStation {
  final String stationId;
  final String stationName;
  final String stationNameEn;
  final Coordinates coordinates;
  final CurrentWaterLevel current;
  final Alert alert;
  final Forecast? forecast;
  final Trend trend;
  final Statistics statistics;
  final List<DataPoint> dataPoints;
  final String lastUpdated;

  WaterLevelStation({
    required this.stationId,
    required this.stationName,
    required this.stationNameEn,
    required this.coordinates,
    required this.current,
    required this.alert,
    this.forecast,
    required this.trend,
    required this.statistics,
    required this.dataPoints,
    required this.lastUpdated,
  });

  factory WaterLevelStation.fromJson(Map<String, dynamic> json) {
    return WaterLevelStation(
      stationId: json['station_id'] ?? '',
      stationName: json['station_name'] ?? '',
      stationNameEn: json['station_name_en'] ?? '',
      coordinates: Coordinates.fromJson(json['coordinates'] ?? {}),
      current: CurrentWaterLevel.fromJson(json['current'] ?? {}),
      alert: Alert.fromJson(json['alert'] ?? {}),
      forecast: json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null,
      trend: Trend.fromJson(json['trend'] ?? {}),
      statistics: Statistics.fromJson(json['statistics'] ?? {}),
      dataPoints: (json['data_points'] as List<dynamic>?)
              ?.map((e) => DataPoint.fromJson(e))
              .toList() ??
          [],
      lastUpdated: json['last_updated'] ?? '',
    );
  }
}

class Coordinates {
  final double lat;
  final double lon;

  Coordinates({required this.lat, required this.lon});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
    );
  }
}

class CurrentWaterLevel {
  final double waterLevel;
  final String timestamp;
  final String timestampVn;
  final String unit;

  CurrentWaterLevel({
    required this.waterLevel,
    required this.timestamp,
    required this.timestampVn,
    required this.unit,
  });

  factory CurrentWaterLevel.fromJson(Map<String, dynamic> json) {
    return CurrentWaterLevel(
      waterLevel: (json['water_level'] ?? 0).toDouble(),
      timestamp: json['timestamp'] ?? '',
      timestampVn: json['timestamp_vn'] ?? '',
      unit: json['unit'] ?? 'm',
    );
  }
}

class Alert {
  final String level;
  final String message;
  final double thresholdWarning;
  final double thresholdFlood;

  Alert({
    required this.level,
    required this.message,
    required this.thresholdWarning,
    required this.thresholdFlood,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      level: json['level'] ?? 'NORMAL',
      message: json['message'] ?? '',
      thresholdWarning: (json['threshold_warning'] ?? 0).toDouble(),
      thresholdFlood: (json['threshold_flood'] ?? 0).toDouble(),
    );
  }

  bool get isCritical => level == 'CRITICAL';
  bool get isWarning => level == 'WARNING';
  bool get isNormal => level == 'NORMAL';
}

class Forecast {
  final TidePrediction? nextHighTide;
  final TidePrediction? nextLowTide;

  Forecast({this.nextHighTide, this.nextLowTide});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      nextHighTide: json['next_high_tide'] != null
          ? TidePrediction.fromJson(json['next_high_tide'])
          : null,
      nextLowTide: json['next_low_tide'] != null
          ? TidePrediction.fromJson(json['next_low_tide'])
          : null,
    );
  }
}

class TidePrediction {
  final String time;
  final String timeVn;
  final double predictedLevel;
  final String type;
  final String confidence;

  TidePrediction({
    required this.time,
    required this.timeVn,
    required this.predictedLevel,
    required this.type,
    required this.confidence,
  });

  factory TidePrediction.fromJson(Map<String, dynamic> json) {
    return TidePrediction(
      time: json['time'] ?? '',
      timeVn: json['time_vn'] ?? '',
      predictedLevel: (json['predicted_level'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      confidence: json['confidence'] ?? '',
    );
  }
}

class Trend {
  final String direction;
  final String directionVn;
  final double rate;
  final String rateDescription;

  Trend({
    required this.direction,
    required this.directionVn,
    required this.rate,
    required this.rateDescription,
  });

  factory Trend.fromJson(Map<String, dynamic> json) {
    return Trend(
      direction: json['direction'] ?? '',
      directionVn: json['direction_vn'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
      rateDescription: json['rate_description'] ?? '',
    );
  }

  bool get isRising => direction == 'rising';
  bool get isFalling => direction == 'falling';
  bool get isStable => direction == 'stable';
}

class Statistics {
  final double max;
  final double min;
  final double mean;
  final double std;
  final double range;

  Statistics({
    required this.max,
    required this.min,
    required this.mean,
    required this.std,
    required this.range,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      max: (json['max'] ?? 0).toDouble(),
      min: (json['min'] ?? 0).toDouble(),
      mean: (json['mean'] ?? 0).toDouble(),
      std: (json['std'] ?? 0).toDouble(),
      range: (json['range'] ?? 0).toDouble(),
    );
  }
}

class DataPoint {
  final int timestamp;
  final String datetime;
  final double waterLevel;

  DataPoint({
    required this.timestamp,
    required this.datetime,
    required this.waterLevel,
  });

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    return DataPoint(
      timestamp: json['timestamp'] ?? 0,
      datetime: json['datetime'] ?? '',
      waterLevel: (json['water_level'] ?? 0).toDouble(),
    );
  }
}

