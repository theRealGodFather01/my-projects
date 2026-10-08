class AdminUserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final bool isActive;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminUserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminUserModel.fromMap(
      String uid,
      Map<String, dynamic> data,
      ) {
    return AdminUserModel(
      uid: uid,
      fullName: data['fullName']?.toString() ?? 'Unknown User',
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      role: data['role']?.toString() ?? 'user',
      isActive: data['isActive'] ?? true,
      profileImageUrl:
      data['profileImageUrl']?.toString(),
      createdAt: _toDateTime(data['createdAt']),
      updatedAt: _toDateTime(data['updatedAt']),
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    try {
      return value.toDate();
    } catch (_) {
      return null;
    }
  }

  String get roleLabel {
    switch (role) {
      case 'super_admin':
        return 'Super Administrator';

      case 'admin':
        return 'Administrator';

      default:
        return 'User';
    }
  }
}