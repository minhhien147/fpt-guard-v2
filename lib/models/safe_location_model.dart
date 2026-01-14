class SafeLocationModel {
  final int? id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final int? distance;
  final String? locationType; // 'fpt', 'security', 'police', 'hospital'
  final DateTime? createdAt;

  SafeLocationModel({
    this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.distance,
    this.locationType,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'location_type': locationType,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory SafeLocationModel.fromMap(Map<String, dynamic> map) {
    return SafeLocationModel(
      id: map['id'],
      name: map['name'] ?? '',
      address: map['address'],
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      distance: map['distance'],
      locationType: map['location_type'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  String getIcon() {
    switch (locationType) {
      case 'fpt':
        return '🏫';
      case 'security':
        return '🛡️';
      case 'police':
        return '👮';
      case 'hospital':
        return '🏥';
      default:
        return '📍';
    }
  }
}

