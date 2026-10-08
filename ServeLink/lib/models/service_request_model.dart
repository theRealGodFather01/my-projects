import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequestModel {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final String description;
  final String address;
  final DateTime? preferredDate;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceRequestModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.description,
    required this.address,
    required this.preferredDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceRequestModel.fromMap(
      String id,
      Map<String, dynamic> data,
      ) {
    return ServiceRequestModel(
      id: id,
      userId: data['userId'] ?? '',
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      preferredDate: _toDateTime(data['preferredDate']),
      status: data['status'] ?? 'pending',
      createdAt: _toDateTime(data['createdAt']),
      updatedAt: _toDateTime(data['updatedAt']),
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}