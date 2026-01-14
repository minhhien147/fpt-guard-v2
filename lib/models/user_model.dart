class UserModel {
  final int? id;
  final String fullName;
  final String studentId;
  final String phone;
  final String email;
  final DateTime? createdAt;

  UserModel({
    this.id,
    required this.fullName,
    required this.studentId,
    required this.phone,
    required this.email,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  UserModel copyWith({
    int? id,
    String? fullName,
    String? studentId,
    String? phone,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

