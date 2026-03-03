class UserModel {
  final int? id;
  final String fullName;
  final String studentId;
  final String phone;
  final String email;
  final DateTime? createdAt;
  final bool isPro;
  final int sosCount;
  final String role;

  const UserModel({
    this.id,
    required this.fullName,
    required this.studentId,
    required this.phone,
    required this.email,
    this.createdAt,
    this.isPro = false,
    this.sosCount = 0,
    this.role = 'user',
  });

  static const int freeSosLimit = 10;
  int get sosRemaining => isPro ? -1 : (freeSosLimit - sosCount).clamp(0, freeSosLimit);
  bool get canSendSos => isPro || sosCount < freeSosLimit;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'student_id': studentId,
      'phone': phone,
      'email': email,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'is_pro': isPro ? 1 : 0,
      'sos_count': sosCount,
      'role': role,
    };
  }

  /// Chỉ bao gồm các cột tồn tại trong bảng users của SQLite local
  Map<String, dynamic> toDbMap() {
    return {
      'full_name': fullName,
      'student_id': studentId,
      'phone': phone,
      'email': email,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['full_name'] ?? '',
      studentId: map['student_id'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
      isPro: (map['is_pro'] == true || map['is_pro'] == 1),
      sosCount: (map['sos_count'] as num?)?.toInt() ?? 0,
      role: map['role'] ?? 'user',
    );
  }

  UserModel copyWith({
    int? id,
    String? fullName,
    String? studentId,
    String? phone,
    String? email,
    DateTime? createdAt,
    bool? isPro,
    int? sosCount,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      isPro: isPro ?? this.isPro,
      sosCount: sosCount ?? this.sosCount,
      role: role ?? this.role,
    );
  }
}
