class ContactModel {
  final int? id;
  final int? userId;
  final String contactName;
  final String contactPhone;
  final String? contactEmail;
  final String contactType; // 'personal' or 'system'
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

  // System contacts
  static List<ContactModel> getSystemContacts() {
    return [
      ContactModel(
        contactName: 'Bảo vệ FPT',
        contactPhone: '0123-456-789',
        contactType: 'system',
        icon: '🛡️',
      ),
      ContactModel(
        contactName: 'Công an 113',
        contactPhone: '113',
        contactType: 'system',
        icon: '👮',
      ),
      ContactModel(
        contactName: 'Y tế 115',
        contactPhone: '115',
        contactType: 'system',
        icon: '🏥',
      ),
      ContactModel(
        contactName: 'BV Đa khoa Quốc tế S.I.S Cần Thơ',
        contactPhone: '(0292) 378 9911',
        contactType: 'system',
        icon: '🏥',
        address: '397 Nguyễn Văn Cừ, P. An Bình, TP. Cần Thơ',
      ),
      ContactModel(
        contactName: 'BV Đa khoa TP. Cần Thơ',
        contactPhone: '(0292) 3821 236',
        contactType: 'system',
        icon: '🏥',
        address: 'Số 4 Châu Văn Liêm, P. Tân An, Q. Ninh Kiều, TP. Cần Thơ',
      ),
    ];
  }
}

