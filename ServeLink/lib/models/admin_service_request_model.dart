import 'service_request_model.dart';

class AdminServiceRequestModel {
  final ServiceRequestModel request;

  final String customerName;
  final String customerEmail;
  final String customerPhone;

  const AdminServiceRequestModel({
    required this.request,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
  });

  String get customerDisplayName {
    if (customerName.trim().isNotEmpty) {
      return customerName.trim();
    }

    return 'Unknown Customer';
  }

  String get customerEmailDisplay {
    if (customerEmail.trim().isNotEmpty) {
      return customerEmail.trim();
    }

    return 'No email available';
  }

  String get customerPhoneDisplay {
    if (customerPhone.trim().isNotEmpty) {
      return customerPhone.trim();
    }

    return 'No phone number available';
  }
}