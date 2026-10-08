class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String icon;
  final bool isActive;
  final bool isPublished;
  final String approvalStatus;
  final String createdBy;
  final String createdByRole;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.isActive,
    required this.isPublished,
    required this.approvalStatus,
    required this.createdBy,
    required this.createdByRole,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromMap(
      String id,
      Map<String, dynamic> data,
      ) {
    return ServiceModel(
      id: id,
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      icon: data['icon']?.toString() ?? 'miscellaneous_services',
      isActive: data['isActive'] ?? true,
      isPublished: data['isPublished'] ?? false,
      approvalStatus:
      data['approvalStatus']?.toString() ?? 'pending',
      createdBy: data['createdBy']?.toString() ?? '',
      createdByRole:
      data['createdByRole']?.toString() ?? 'user',
      createdAt: _toDateTime(data['createdAt']),
      updatedAt: _toDateTime(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'icon': icon,
      'isActive': isActive,
      'isPublished': isPublished,
      'approvalStatus': approvalStatus,
      'createdBy': createdBy,
      'createdByRole': createdByRole,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
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
}