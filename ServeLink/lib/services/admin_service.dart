import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/admin_service_request_model.dart';
import '../models/service_request_model.dart';
import '../models/admin_user_model.dart';
import '../models/service_model.dart';

class AdminService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  // =========================================================
  // ADMIN ACCESS
  // =========================================================

  Future<bool> isCurrentUserAdmin() async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    final document = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!document.exists || document.data() == null) {
      return false;
    }

    final role = document.data()!['role']?.toString();

    return role == 'admin' || role == 'super_admin';
  }

  Future<bool> isCurrentUserSuperAdmin() async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    final document = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!document.exists || document.data() == null) {
      return false;
    }

    return document.data()!['role']?.toString() ==
        'super_admin';
  }

  // =========================================================
  // USERS
  // =========================================================

  Stream<List<AdminUserModel>> getUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) {
      final users = snapshot.docs.map((doc) {
        return AdminUserModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();

      users.sort((a, b) {
        final aDate = a.createdAt;
        final bDate = b.createdAt;

        if (aDate == null && bDate == null) {
          return a.fullName.compareTo(b.fullName);
        }

        if (aDate == null) {
          return 1;
        }

        if (bDate == null) {
          return -1;
        }

        return bDate.compareTo(aDate);
      });

      return users;
    });
  }

  Stream<List<AdminUserModel>> getAdmins() {
    return _firestore
        .collection('users')
        .where(
      'role',
      whereIn: ['admin', 'super_admin'],
    )
        .snapshots()
        .map((snapshot) {
      final admins = snapshot.docs.map((doc) {
        return AdminUserModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();

      admins.sort(
            (a, b) => a.fullName.compareTo(b.fullName),
      );

      return admins;
    });
  }

  Future<AdminUserModel?> getUser(
      String uid,
      ) async {
    final document = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return AdminUserModel.fromMap(
      document.id,
      document.data()!,
    );
  }

  // =========================================================
  // USER ROLE MANAGEMENT
  // =========================================================

  Future<void> promoteUserToAdmin(String uid) async {
    await _ensureSuperAdmin();

    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('You must be logged in.');
    }

    if (currentUser.uid == uid) {
      throw Exception(
        'You cannot change your own administrator role.',
      );
    }

    final userDoc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      throw Exception('User account not found.');
    }

    final data = userDoc.data();

    if (data == null) {
      throw Exception('Unable to read user account.');
    }

    final currentRole =
        data['role']?.toString() ?? 'user';

    if (currentRole == 'super_admin') {
      throw Exception(
        'A Super Administrator cannot be changed to Administrator.',
      );
    }

    if (currentRole == 'admin') {
      throw Exception(
        'This user is already an Administrator.',
      );
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .update({
      'role': 'admin',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> demoteAdminToUser(String uid) async {
    await _ensureSuperAdmin();

    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('You must be logged in.');
    }

    if (currentUser.uid == uid) {
      throw Exception(
        'You cannot change your own administrator role.',
      );
    }

    final userDoc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      throw Exception('User account not found.');
    }

    final data = userDoc.data();

    if (data == null) {
      throw Exception('Unable to read user account.');
    }

    final currentRole =
        data['role']?.toString() ?? 'user';

    if (currentRole == 'super_admin') {
      throw Exception(
        'A Super Administrator cannot be demoted.',
      );
    }

    if (currentRole != 'admin') {
      throw Exception(
        'This user is not an Administrator.',
      );
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .update({
      'role': 'user',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setUserActive(
      String uid,
      bool isActive,
      ) async {
    await _ensureSuperAdmin();

    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('You must be logged in.');
    }

    if (currentUser.uid == uid) {
      throw Exception(
        'You cannot change your own account status.',
      );
    }

    final userDoc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      throw Exception('User account not found.');
    }

    final data = userDoc.data();

    if (data == null) {
      throw Exception('Unable to read user account.');
    }

    final role = data['role']?.toString() ?? 'user';

    if (role == 'super_admin') {
      throw Exception(
        'A Super Administrator cannot be deactivated.',
      );
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _ensureSuperAdmin() async {
    final isSuperAdmin =
    await isCurrentUserSuperAdmin();

    if (!isSuperAdmin) {
      throw Exception(
        'Only the Super Admin can perform this action.',
      );
    }
  }

  // =========================================================
  // SERVICES
  // =========================================================

  Stream<List<ServiceModel>> getAllServices() {
    return _firestore
        .collection('services')
        .snapshots()
        .map((snapshot) {
      final services = snapshot.docs.map((doc) {
        return ServiceModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();

      services.sort((a, b) {
        final aDate = a.createdAt;
        final bDate = b.createdAt;

        if (aDate == null && bDate == null) {
          return a.name.compareTo(b.name);
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
    });
  }

  Stream<List<ServiceModel>> getPendingServices() {
    return _firestore
        .collection('services')
        .where(
      'approvalStatus',
      isEqualTo: 'pending',
    )
        .snapshots()
        .map((snapshot) {
      final services = snapshot.docs.map((doc) {
        return ServiceModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();

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
    });
  }

  Stream<List<AdminServiceRequestModel>> getAdminServiceRequests() {
    return _firestore
        .collection('service_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final results = <AdminServiceRequestModel>[];

      for (final doc in snapshot.docs) {
        final request =
        ServiceRequestModel.fromMap(doc.id, doc.data());

        String customerName = 'Unknown Customer';
        String customerEmail = '';
        String customerPhone = '';

        try {
          final userDoc = await _firestore
              .collection('users')
              .doc(request.userId)
              .get();

          if (userDoc.exists) {
            final userData = userDoc.data();

            if (userData != null) {
              customerName =
                  userData['fullName']?.toString() ??
                      'Unknown Customer';

              customerEmail =
                  userData['email']?.toString() ?? '';

              customerPhone =
                  userData['phone']?.toString() ?? '';
            }
          }
        } catch (_) {
          // Keep the request visible even if customer
          // information cannot be loaded.
        }

        results.add(
          AdminServiceRequestModel(
            request: request,
            customerName: customerName,
            customerEmail: customerEmail,
            customerPhone: customerPhone,
          ),
        );
      }

      return results;
    });
  }

  Future<void> approveService(
      String serviceId,
      ) async {
    await _ensureAdmin();

    await _firestore
        .collection('services')
        .doc(serviceId)
        .update({
      'approvalStatus': 'approved',
      'isPublished': true,
      'isActive': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectService(
      String serviceId,
      ) async {
    await _ensureAdmin();

    await _firestore
        .collection('services')
        .doc(serviceId)
        .update({
      'approvalStatus': 'rejected',
      'isPublished': false,
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setServiceActive(
      String serviceId,
      bool isActive,
      ) async {
    await _ensureAdmin();

    await _firestore
        .collection('services')
        .doc(serviceId)
        .update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _ensureAdmin() async {
    final isAdmin =
    await isCurrentUserAdmin();

    if (!isAdmin) {
      throw Exception(
        'You do not have permission to perform this action.',
      );
    }
  }

  // =========================================================
  // SERVICE REQUESTS
  // =========================================================

  Stream<List<ServiceRequestModel>>
  getAllServiceRequests() {
    return _firestore
        .collection('service_requests')
        .snapshots()
        .map((snapshot) {
      final requests = snapshot.docs.map((doc) {
        return ServiceRequestModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();

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
    });
  }

  Future<void> updateServiceRequestStatus(
      String requestId,
      String status,
      ) async {
    await _ensureAdmin();

    const allowedStatuses = [
      'pending',
      'accepted',
      'in_progress',
      'completed',
      'cancelled',
    ];

    if (!allowedStatuses.contains(status)) {
      throw Exception('Invalid request status.');
    }

    await _firestore
        .collection('service_requests')
        .doc(requestId)
        .update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // DASHBOARD COUNTS
  // =========================================================

  Future<int> getUserCount() async {
    final snapshot =
    await _firestore.collection('users').count().get();

    return snapshot.count ?? 0;
  }

  Future<int> getServiceCount() async {
    final snapshot =
    await _firestore.collection('services').count().get();

    return snapshot.count ?? 0;
  }

  Future<int> getPendingServiceCount() async {
    final snapshot = await _firestore
        .collection('services')
        .where(
      'approvalStatus',
      isEqualTo: 'pending',
    )
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  Future<int> getRequestCount() async {
    final snapshot = await _firestore
        .collection('service_requests')
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  Future<Map<String, int>> getDashboardCounts() async {
    await _ensureAdmin();

    final usersSnapshot =
    await _firestore.collection('users').get();

    final servicesSnapshot =
    await _firestore.collection('services').get();

    final requestsSnapshot =
    await _firestore.collection('service_requests').get();

    int userCount = 0;
    int adminCount = 0;
    int superAdminCount = 0;
    int activeUserCount = 0;
    int inactiveUserCount = 0;

    for (final doc in usersSnapshot.docs) {
      final data = doc.data();

      final role =
          data['role']?.toString() ?? 'user';

      final isActive =
          data['isActive'] ?? true;

      if (role == 'super_admin') {
        superAdminCount++;
      } else if (role == 'admin') {
        adminCount++;
      } else {
        userCount++;
      }

      if (isActive == true) {
        activeUserCount++;
      } else {
        inactiveUserCount++;
      }
    }

    int pendingServices = 0;
    int approvedServices = 0;
    int rejectedServices = 0;
    int activeServices = 0;
    int inactiveServices = 0;

    for (final doc in servicesSnapshot.docs) {
      final data = doc.data();

      final approvalStatus =
          data['approvalStatus']?.toString() ??
              'pending';

      final isActive =
          data['isActive'] ?? true;

      switch (approvalStatus) {
        case 'approved':
          approvedServices++;
          break;

        case 'rejected':
          rejectedServices++;
          break;

        default:
          pendingServices++;
      }

      if (isActive == true) {
        activeServices++;
      } else {
        inactiveServices++;
      }
    }

    int pendingRequests = 0;
    int acceptedRequests = 0;
    int inProgressRequests = 0;
    int completedRequests = 0;
    int cancelledRequests = 0;

    for (final doc in requestsSnapshot.docs) {
      final data = doc.data();

      final status =
          data['status']?.toString() ??
              'pending';

      switch (status) {
        case 'accepted':
          acceptedRequests++;
          break;

        case 'in_progress':
          inProgressRequests++;
          break;

        case 'completed':
          completedRequests++;
          break;

        case 'cancelled':
          cancelledRequests++;
          break;

        default:
          pendingRequests++;
      }
    }

    return {
      'users': userCount,
      'admins': adminCount,
      'superAdmins': superAdminCount,
      'activeUsers': activeUserCount,
      'inactiveUsers': inactiveUserCount,

      'services': servicesSnapshot.size,
      'pendingServices': pendingServices,
      'approvedServices': approvedServices,
      'rejectedServices': rejectedServices,
      'activeServices': activeServices,
      'inactiveServices': inactiveServices,

      'requests': requestsSnapshot.size,
      'pendingRequests': pendingRequests,
      'acceptedRequests': acceptedRequests,
      'inProgressRequests': inProgressRequests,
      'completedRequests': completedRequests,
      'cancelledRequests': cancelledRequests,
    };
  }
}
