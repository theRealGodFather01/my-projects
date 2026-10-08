import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to log out: ${e.toString()}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to load your profile.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Profile information not found.',
              ),
            );
          }

          final data = snapshot.data!.data() ?? {};

          final fullName = data['fullName'] ?? 'User';
          final email = data['email'] ?? '';
          final phone = data['phone'] ?? '';
          final role = data['role'] ?? 'user';
          final profileImageUrl = data['profileImageUrl'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile picture
                CircleAvatar(
                  radius: 55,
                  backgroundColor:
                  theme.colorScheme.primaryContainer,
                  backgroundImage:
                  profileImageUrl != null &&
                      profileImageUrl.toString().isNotEmpty
                      ? NetworkImage(
                    profileImageUrl.toString(),
                  )
                      : null,
                  child: profileImageUrl == null ||
                      profileImageUrl.toString().isEmpty
                      ? Icon(
                    Icons.person,
                    size: 55,
                    color: theme.colorScheme.primary,
                  )
                      : null,
                ),

                const SizedBox(height: 20),

                // Name
                Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // Role
                Text(
                  role == 'super_admin'
                      ? 'Super Administrator'
                      : role == 'admin'
                      ? 'Administrator'
                      : 'ServeLink User',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 30),

                // Profile information
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _ProfileInfoTile(
                          icon: Icons.person_outline,
                          title: 'Full Name',
                          value: fullName,
                        ),
                        const Divider(height: 28),
                        _ProfileInfoTile(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: email,
                        ),
                        const Divider(height: 28),
                        _ProfileInfoTile(
                          icon: Icons.phone_outlined,
                          title: 'Phone',
                          value: phone.isEmpty
                              ? 'Not provided'
                              : phone,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Logout
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'ServeLink',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Connect. Request. Get Served.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}