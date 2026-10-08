import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    UserCredential credential;

    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }

    final user = credential.user;

    if (user == null) {
      throw Exception('Unable to create account.');
    }

    try {
      await user.updateDisplayName(fullName.trim());

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullName': fullName.trim(),
        'email': email.trim(),
        'phone': phone.trim(),

        // Every newly registered account starts as a normal user.
        'role': 'user',

        'profileImageUrl': null,
        'fcmToken': null,

        // Used later to disable accounts without deleting them.
        'isActive': true,

        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return user;
    } catch (e) {
      // If creating the Firestore profile fails, remove
      // the newly-created Authentication account.
      await user.delete();
      rethrow;
    }
  }

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    final credential =
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Unable to sign in.');
    }

    final userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      await _auth.signOut();

      throw Exception(
        'Your ServeLink profile could not be found.',
      );
    }

    final data = userDoc.data();

    final isActive =
        data?['isActive'] ?? true;

    if (isActive != true) {
      await _auth.signOut();

      throw Exception(
        'Your ServeLink account is currently inactive. '
            'Please contact an administrator.',
      );
    }

    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(
      String uid,
      ) async {
    return _firestore.collection('users').doc(uid).get();
  }
}

