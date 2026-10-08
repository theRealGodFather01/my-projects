import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'admin_requests_screen.dart';
import 'admin_services_screen.dart';
import 'admin_users_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() =>
      _AdminHomeScreenState();
}

class _AdminHomeScreenState
    extends State<AdminHomeScreen> {
  final AdminService _adminService = AdminService();
  final AuthService _authService = AuthService();

  Map<String, int> _counts = {};
  bool _isLoading = true;
  bool _isSuperAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final results = await Future.wait([
        _adminService.getDashboardCounts(),
        _adminService.isCurrentUserSuperAdmin(),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _counts =
        results[0] as Map<String, int>;
        _isSuperAdmin =
        results[1] as bool;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showError(e.toString());
    }
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _isLoading = true;
    });

    await _loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed:
            _isLoading ? null : _loadDashboard,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: _isLoading && _counts.isEmpty
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            32,
          ),
          children: [
            _buildWelcomeCard(user),
            const SizedBox(height: 20),
            _buildOverviewTitle(),
            const SizedBox(height: 10),
            _buildOverviewGrid(),
            const SizedBox(height: 24),
            _buildServicesSection(),
            const SizedBox(height: 24),
            _buildRequestsSection(),
            const SizedBox(height: 24),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(User? user) {
    final displayName =
    user?.displayName?.trim();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Text(
                displayName != null &&
                    displayName.isNotEmpty
                    ? displayName
                    .substring(0, 1)
                    .toUpperCase()
                    : 'A',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName?.isNotEmpty == true
                        ? 'Welcome, $displayName'
                        : 'Welcome, Administrator',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _isSuperAdmin
                        ? 'Super Administrator'
                        : 'Administrator',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTitle() {
    return const Text(
      'Overview',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.45,
      children: [
        _buildStatCard(
          title: 'Users',
          value: _count('users'),
          icon: Icons.people_outline,
          onTap: _openUsers,
        ),
        _buildStatCard(
          title: 'Services',
          value: _count('services'),
          icon: Icons.miscellaneous_services,
          onTap: _openServices,
        ),
        _buildStatCard(
          title: 'Pending Services',
          value: _count('pendingServices'),
          icon: Icons.pending_actions,
          onTap: _openServices,
        ),
        _buildStatCard(
          title: 'Requests',
          value: _count('requests'),
          icon: Icons.assignment_outlined,
          onTap: _openRequests,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required int value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProgressRow(
                  label: 'Pending',
                  value:
                  _count('pendingServices'),
                  total: _count('services'),
                  icon:
                  Icons.pending_actions,
                ),
                const SizedBox(height: 14),
                _buildProgressRow(
                  label: 'Approved',
                  value:
                  _count('approvedServices'),
                  total: _count('services'),
                  icon:
                  Icons.check_circle_outline,
                ),
                const SizedBox(height: 14),
                _buildProgressRow(
                  label: 'Rejected',
                  value:
                  _count('rejectedServices'),
                  total: _count('services'),
                  icon:
                  Icons.cancel_outlined,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsSection() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Requests',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProgressRow(
                  label: 'Pending',
                  value:
                  _count('pendingRequests'),
                  total: _count('requests'),
                  icon:
                  Icons.pending_actions,
                ),
                const SizedBox(height: 14),
                _buildProgressRow(
                  label: 'Accepted',
                  value:
                  _count('acceptedRequests'),
                  total: _count('requests'),
                  icon:
                  Icons.check_circle_outline,
                ),
                const SizedBox(height: 14),
                _buildProgressRow(
                  label: 'In Progress',
                  value:
                  _count('inProgressRequests'),
                  total: _count('requests'),
                  icon:
                  Icons.sync,
                ),
                const SizedBox(height: 14),
                _buildProgressRow(
                  label: 'Completed',
                  value:
                  _count('completedRequests'),
                  total: _count('requests'),
                  icon:
                  Icons.done_all,
                ),
                const SizedBox(height: 14),
                _buildProgressRow(
                  label: 'Cancelled',
                  value:
                  _count('cancelledRequests'),
                  total: _count('requests'),
                  icon:
                  Icons.cancel_outlined,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow({
    required String label,
    required int value,
    required int total,
    required IconData icon,
  }) {
    final progress = total == 0
        ? 0.0
        : (value / total).clamp(0.0, 1.0);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade700,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                borderRadius:
                BorderRadius.circular(10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildActionTile(
          icon: Icons.miscellaneous_services,
          title: 'Review Services',
          subtitle:
          'Approve, reject or manage services',
          onTap: _openServices,
        ),
        const SizedBox(height: 10),
        _buildActionTile(
          icon: Icons.assignment_outlined,
          title: 'Service Requests',
          subtitle:
          'Review and update customer requests',
          onTap: _openRequests,
        ),
        const SizedBox(height: 10),
        _buildActionTile(
          icon: Icons.people_outline,
          title: 'Manage Users',
          subtitle:
          'View customer accounts and roles',
          onTap: _openUsers,
        ),
        if (_isSuperAdmin) ...[
          const SizedBox(height: 10),
          _buildActionTile(
            icon:
            Icons.admin_panel_settings_outlined,
            title: 'Manage Administrators',
            subtitle:
            'Promote or demote administrators',
            onTap: _openUsers,
          ),
        ],
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing:
        const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  int _count(String key) {
    return _counts[key] ?? 0;
  }

  Future<void> _openServices() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const AdminServicesScreen(),
      ),
    );

    if (mounted) {
      _loadDashboard();
    }
  }

  Future<void> _openRequests() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const AdminRequestsScreen(),
      ),
    );

    if (mounted) {
      _loadDashboard();
    }
  }

  Future<void> _openUsers() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const AdminUsersScreen(),
      ),
    );

    if (mounted) {
      _loadDashboard();
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to log out?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await _authService.logout();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  void _showError(String message) {
    final cleanedMessage =
    message.replaceFirst(
      'Exception: ',
      '',
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(cleanedMessage),
      ),
    );
  }
}