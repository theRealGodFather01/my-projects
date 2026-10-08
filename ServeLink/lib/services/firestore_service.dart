import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/service_model.dart';
import '../models/service_request_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ---------------------------------------------------------------------------
  // SERVICES
  // ---------------------------------------------------------------------------

  /// Returns services that are publicly available.
  ///
  /// These are services approved and published by the system.
  Stream<List<ServiceModel>> getActiveServices() {
    return _firestore
        .collection('services')
        .where('isActive', isEqualTo: true)
        .where('isPublished', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) {
        return snapshot.docs
            .map(
              (doc) => ServiceModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
            .toList();
      },
    );
  }

  /// Returns the services created by the currently logged-in user.
  ///
  /// This includes pending, approved and rejected services.
  Stream<List<ServiceModel>> getMyServices() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('services')
        .where('createdBy', isEqualTo: user.uid)
        .snapshots()
        .map(
          (snapshot) {
        final services = snapshot.docs
            .map(
              (doc) => ServiceModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
            .toList();

        services.sort((a, b) {
          final aDate = a.createdAt;
          final bDate = b.createdAt;

          if (aDate == null && bDate == null) {
            return 0;
          }

          if (aDate == null) {
            return 1;
          }

          if (bDate == null) {
            return -1;
          }

          return bDate.compareTo(aDate);
        });

        return services;
      },
    );
  }

  /// Creates a service submitted by a normal user.
  ///
  /// User-created services always start as pending and unpublished.
  Future<String> createUserService({
    required String name,
    required String description,
    required String category,
    required String icon,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'You must be logged in to add a service.',
      );
    }

    final serviceRef =
    _firestore.collection('services').doc();

    await serviceRef.set({
      'name': name.trim(),
      'description': description.trim(),
      'category': category.trim(),
      'icon': icon,

      // User services are not publicly visible until approved.
      'isActive': true,
      'isPublished': false,
      'approvalStatus': 'pending',

      'createdBy': user.uid,
      'createdByRole': 'user',

      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return serviceRef.id;
  }

  Future<ServiceModel?> getService(String serviceId) async {
    final doc = await _firestore
        .collection('services')
        .doc(serviceId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return ServiceModel.fromMap(
      doc.id,
      doc.data()!,
    );
  }

  // ---------------------------------------------------------------------------
  // SERVICE REQUESTS
  // ---------------------------------------------------------------------------

  Future<String> createServiceRequest({
    required String serviceId,
    required String serviceName,
    required String description,
    required String address,
    required DateTime preferredDate,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'You must be logged in to make a request.',
      );
    }

    final requestRef =
    _firestore.collection('service_requests').doc();

    await requestRef.set({
      'userId': user.uid,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'description': description.trim(),
      'address': address.trim(),
      'preferredDate': Timestamp.fromDate(preferredDate),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return requestRef.id;
  }

  Stream<List<ServiceRequestModel>> getMyRequests() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('service_requests')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map(
          (snapshot) {
        final requests = snapshot.docs
            .map(
              (doc) => ServiceRequestModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
            .toList();

        requests.sort((a, b) {
          final aDate = a.createdAt;
          final bDate = b.createdAt;

          if (aDate == null && bDate == null) {
            return 0;
          }

          if (aDate == null) {
            return 1;
          }

          if (bDate == null) {
            return -1;
          }

          return bDate.compareTo(aDate);
        });

        return requests;
      },
    );
  }
}