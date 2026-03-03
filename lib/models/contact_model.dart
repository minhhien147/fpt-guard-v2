class ContactModel {
  final int? id;
  final int? userId;
  final String contactName;
  final String contactPhone;
  final String? contactEmail;
  final String contactType;
  final String? icon;
  final String? address;
  final DateTime? createdAt;

  ContactModel({
    this.id,
    this.userId,
    required this.contactName,
    required this.contactPhone,
    this.contactEmail,
    this.contactType = 'personal',
    this.icon,
    this.address,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'contact_type': contactType,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      userId: map['user_id'],
      contactName: map['contact_name'] ?? '',
      contactPhone: map['contact_phone'] ?? '',
      contactEmail: map['contact_email'],
      contactType: map['contact_type'] ?? 'personal',
      icon: map['icon'],
      address: map['address'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

}

