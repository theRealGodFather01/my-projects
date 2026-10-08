import 'package:flutter/material.dart';

import '../../models/admin_user_model.dart';
import '../../services/admin_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() =>
      _AdminUsersScreenState();
}

class _AdminUsersScreenState
    extends State<AdminUsersScreen> {
  final AdminService _adminService = AdminService();

  final TextEditingController _searchController =
  TextEditingController();

  bool _isSuperAdmin = false;
  bool _checkingPermissions = true;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery =
            _searchController.text.trim().toLowerCase();
      });
    });

    _loadPermissions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPermissions() async {
    try {
      final isSuperAdmin =
      await _adminService.isCurrentUserSuperAdmin();

      if (!mounted) {
        return;
      }

      setState(() {
        _isSuperAdmin = isSuperAdmin;
        _checkingPermissions = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSuperAdmin = false;
        _checkingPermissions = false;
      });

      _showError(e);
    }
  }

  List<AdminUserModel> _filterUsers(
      List<AdminUserModel> users,
      ) {
    if (_searchQuery.isEmpty) {
      return users;
    }

    return users.where((user) {
      final name =
      user.fullName.toLowerCase();

      final email =
      user.email.toLowerCase();

      final phone =
      user.phone.toLowerCase();

      final role =
      user.roleLabel.toLowerCase();

      final uid =
      user.uid.toLowerCase();

      return name.contains(_searchQuery) ||
          email.contains(_searchQuery) ||
          phone.contains(_searchQuery) ||
          role.contains(_searchQuery) ||
          uid.contains(_searchQuery);
    }).toList();
  }

  Future<void> _openUserActions(
      AdminUserModel user,
      ) async {
    final isCurrentUser =
        _adminService.currentUserId == user.uid;

    final canManageUser =
        _isSuperAdmin &&
            !isCurrentUser &&
            user.role != 'super_admin';

    final canPromote =
        _isSuperAdmin &&
            !isCurrentUser &&
            user.role == 'user';

    final canDemote =
        _isSuperAdmin &&
            !isCurrentUser &&
            user.role == 'admin';

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _UserAvatar(
                  user: user,
                  size: 64,
                ),

                const SizedBox(height: 12),

                Text(
                  user.fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    _RoleBadge(
                      role: user.role,
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(
                      isActive: user.isActive,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                  ),
                  title: const Text(
                    'View Details',
                  ),
                  subtitle: const Text(
                    'View complete user information',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showUserDetails(user);
                  },
                ),

                if (canManageUser) ...[
                  ListTile(
                    leading: Icon(
                      user.isActive
                          ? Icons.person_off_outlined
                          : Icons.person_outline,
                    ),
                    title: Text(
                      user.isActive
                          ? 'Deactivate Account'
                          : 'Activate Account',
                    ),
                    subtitle: Text(
                      user.isActive
                          ? 'Prevent this user from logging in'
                          : 'Allow this user to log in again',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _confirmToggleActive(user);
                    },
                  ),
                ],

                if (canPromote) ...[
                  ListTile(
                    leading: const Icon(
                      Icons.admin_panel_settings_outlined,
                    ),
                    title: const Text(
                      'Promote to Administrator',
                    ),
                    subtitle: const Text(
                      'Give this user admin privileges',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _confirmPromote(user);
                    },
                  ),
                ],

                if (canDemote) ...[
                  ListTile(
                    leading: const Icon(
                      Icons.person_remove_outlined,
                    ),
                    title: const Text(
                      'Demote to User',
                    ),
                    subtitle: const Text(
                      'Remove administrator privileges',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _confirmDemote(user);
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmPromote(
      AdminUserModel user,
      ) async {
    if (!_isSuperAdmin) {
      _showError(
        'Only a Super Administrator can promote users.',
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Promote User?',
          ),
          content: Text(
            'Are you sure you want to make '
                '${user.fullName} an Administrator?',
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
              child: const Text('Promote'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _adminService.promoteUserToAdmin(
        user.uid,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${user.fullName} is now an Administrator.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e);
    }
  }

  Future<void> _confirmDemote(
      AdminUserModel user,
      ) async {
    if (!_isSuperAdmin) {
      _showError(
        'Only a Super Administrator can demote administrators.',
      );
      return;
    }

    if (user.role == 'super_admin') {
      _showError(
        'A Super Administrator cannot be demoted.',
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Demote Administrator?',
          ),
          content: Text(
            'Are you sure you want to change '
                '${user.fullName} back to a regular User?',
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
              child: const Text('Demote'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _adminService.demoteAdminToUser(
        user.uid,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${user.fullName} is now a regular User.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e);
    }
  }

  Future<void> _confirmToggleActive(
      AdminUserModel user,
      ) async {
    if (!_isSuperAdmin) {
      _showError(
        'Only a Super Administrator can change account status.',
      );
      return;
    }

    if (user.role == 'super_admin') {
      _showError(
        'A Super Administrator cannot be deactivated.',
      );
      return;
    }

    if (_adminService.currentUserId == user.uid) {
      _showError(
        'You cannot change your own account status.',
      );
      return;
    }

    final willActivate =
    !user.isActive;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            willActivate
                ? 'Activate Account?'
                : 'Deactivate Account?',
          ),
          content: Text(
            willActivate
                ? 'Allow ${user.fullName} to log in to ServeLink again?'
                : 'Prevent ${user.fullName} from logging in to ServeLink?',
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
              child: Text(
                willActivate
                    ? 'Activate'
                    : 'Deactivate',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _adminService.setUserActive(
        user.uid,
        willActivate,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            willActivate
                ? '${user.fullName} has been activated.'
                : '${user.fullName} has been deactivated.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e);
    }
  }

  void _showUserDetails(
      AdminUserModel user,
      ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              _UserAvatar(
                user: user,
                size: 46,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _DetailRow(
                  label: 'Role',
                  value: user.roleLabel,
                ),

                const SizedBox(height: 12),

                _DetailRow(
                  label: 'Status',
                  value: user.isActive
                      ? 'Active'
                      : 'Inactive',
                ),

                const SizedBox(height: 12),

                _DetailRow(
                  label: 'Email',
                  value: user.email.isEmpty
                      ? 'Not provided'
                      : user.email,
                ),

                const SizedBox(height: 12),

                _DetailRow(
                  label: 'Phone',
                  value: user.phone.isEmpty
                      ? 'Not provided'
                      : user.phone,
                ),

                const SizedBox(height: 12),

                _DetailRow(
                  label: 'User ID',
                  value: user.uid,
                ),

                const SizedBox(height: 12),

                _DetailRow(
                  label: 'Created',
                  value: _formatDate(
                    user.createdAt,
                  ),
                ),

                const SizedBox(height: 12),

                _DetailRow(
                  label: 'Updated',
                  value: _formatDate(
                    user.updatedAt,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Not available';
    }

    final day =
    date.day.toString().padLeft(2, '0');

    final month =
    date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  void _showError(Object error) {
    final message = error
        .toString()
        .replaceFirst('Exception: ', '');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPermissions) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<AdminUserModel>>(
        stream: _adminService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
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
                      'Unable to load users.',
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

          final users =
              snapshot.data ?? [];

          final filteredUsers =
          _filterUsers(users);

          final userCount = users
              .where(
                (user) => user.role == 'user',
          )
              .length;

          final adminCount = users
              .where(
                (user) => user.role == 'admin',
          )
              .length;

          final superAdminCount = users
              .where(
                (user) =>
            user.role == 'super_admin',
          )
              .length;

          final activeCount = users
              .where(
                (user) => user.isActive,
          )
              .length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  8,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                    'Search users...',
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        _searchController
                            .clear();
                      },
                      icon: const Icon(
                        Icons.clear,
                      ),
                    )
                        : null,
                  ),
                ),
              ),

              SingleChildScrollView(
                scrollDirection:
                Axis.horizontal,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    _CountChip(
                      label: 'All',
                      count: users.length,
                    ),
                    _CountChip(
                      label: 'Users',
                      count: userCount,
                    ),
                    _CountChip(
                      label: 'Admins',
                      count: adminCount,
                    ),
                    _CountChip(
                      label: 'Super Admins',
                      count:
                      superAdminCount,
                    ),
                    _CountChip(
                      label: 'Active',
                      count: activeCount,
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      '${filteredUsers.length} user${filteredUsers.length == 1 ? '' : 's'}',
                      style: TextStyle(
                        color:
                        Colors.grey.shade600,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: filteredUsers.isEmpty
                    ? const Center(
                  child: Text(
                    'No users found.',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                )
                    : ListView.separated(
                  padding:
                  const EdgeInsets
                      .fromLTRB(
                    16,
                    4,
                    16,
                    24,
                  ),
                  itemCount:
                  filteredUsers.length,
                  separatorBuilder:
                      (_, __) =>
                  const SizedBox(
                    height: 10,
                  ),
                  itemBuilder:
                      (context, index) {
                    final user =
                    filteredUsers[
                    index];

                    return _UserCard(
                      user: user,
                      onTap: () {
                        _openUserActions(
                          user,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _UserCard
    extends StatelessWidget {
  final AdminUserModel user;
  final VoidCallback onTap;

  const _UserCard({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(16),
        child: Padding(
          padding:
          const EdgeInsets.all(14),
          child: Row(
            children: [
              _UserAvatar(
                user: user,
                size: 52,
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      user.email,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                        Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _RoleBadge(
                          role: user.role,
                        ),
                        _StatusBadge(
                          isActive:
                          user.isActive,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserAvatar
    extends StatelessWidget {
  final AdminUserModel user;
  final double size;

  const _UserAvatar({
    required this.user,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        user.profileImageUrl;

    if (imageUrl != null &&
        imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage:
        NetworkImage(imageUrl),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      child: Text(
        _initials(user.fullName),
        style: TextStyle(
          fontSize: size * 0.30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'));

    if (parts.isEmpty ||
        parts.first.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (
        '${parts.first[0]}'
            '${parts.last[0]}'
    ).toUpperCase();
  }
}

class _RoleBadge
    extends StatelessWidget {
  final String role;

  const _RoleBadge({
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration:
      BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        role == 'super_admin'
            ? 'Super Admin'
            : role == 'admin'
            ? 'Admin'
            : 'User',
        style: TextStyle(
          color: Theme.of(context)
              .colorScheme
              .primary,
          fontSize: 11,
          fontWeight:
          FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusBadge
    extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color =
    isActive ? Colors.green : Colors.red;

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration:
      BoxDecoration(
        color:
        color.withValues(alpha: 0.12),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            isActive
                ? Icons.check_circle_outline
                : Icons.block_outlined,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isActive
                ? 'Active'
                : 'Inactive',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountChip
    extends StatelessWidget {
  final String label;
  final int count;

  const _CountChip({
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          '$label ($count)',
        ),
      ),
    );
  }
}

class _DetailRow
    extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}