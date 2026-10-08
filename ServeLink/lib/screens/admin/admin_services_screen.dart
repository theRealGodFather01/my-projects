import 'package:flutter/material.dart';

import '../../models/service_model.dart';
import '../../services/admin_service.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() =>
      _AdminServicesScreenState();
}

class _AdminServicesScreenState
    extends State<AdminServicesScreen> {
  final AdminService _adminService = AdminService();

  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery =
            _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceModel> _filterServices(
      List<ServiceModel> services,
      ) {
    List<ServiceModel> filtered = services;

    if (_selectedTab == 1) {
      filtered = filtered
          .where(
            (service) =>
        service.approvalStatus == 'pending',
      )
          .toList();
    } else if (_selectedTab == 2) {
      filtered = filtered
          .where(
            (service) =>
        service.approvalStatus == 'approved',
      )
          .toList();
    } else if (_selectedTab == 3) {
      filtered = filtered
          .where(
            (service) =>
        service.approvalStatus == 'rejected',
      )
          .toList();
    }

    if (_searchQuery.isEmpty) {
      return filtered;
    }

    return filtered.where((service) {
      final name = service.name.toLowerCase();
      final description =
      service.description.toLowerCase();
      final category =
      service.category.toLowerCase();
      final status =
      service.approvalStatus.toLowerCase();

      return name.contains(_searchQuery) ||
          description.contains(_searchQuery) ||
          category.contains(_searchQuery) ||
          status.contains(_searchQuery);
    }).toList();
  }

  Future<void> _openServiceActions(
      ServiceModel service,
      ) async {
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
                _ServiceIcon(
                  iconName: service.icon,
                  size: 58,
                ),
                const SizedBox(height: 12),
                Text(
                  service.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  service.category,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 14),
                _ApprovalBadge(
                  status: service.approvalStatus,
                ),
                const SizedBox(height: 20),

                if (service.approvalStatus == 'pending') ...[
                  ListTile(
                    leading: const Icon(
                      Icons.check_circle_outline,
                    ),
                    title: const Text(
                      'Approve Service',
                    ),
                    subtitle: const Text(
                      'Publish this service for users',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _confirmApproveService(service);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.cancel_outlined,
                    ),
                    title: const Text(
                      'Reject Service',
                    ),
                    subtitle: const Text(
                      'Reject this service submission',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _confirmRejectService(service);
                    },
                  ),
                ],

                if (service.approvalStatus == 'approved')
                  ListTile(
                    leading: Icon(
                      service.isActive
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    title: Text(
                      service.isActive
                          ? 'Deactivate Service'
                          : 'Activate Service',
                    ),
                    subtitle: Text(
                      service.isActive
                          ? 'Hide this service from users'
                          : 'Make this service available to users',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _toggleService(service);
                    },
                  ),

                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                  ),
                  title: const Text(
                    'View Details',
                  ),
                  subtitle: const Text(
                    'View complete service information',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showServiceDetails(service);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmApproveService(
      ServiceModel service,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Approve Service?',
          ),
          content: Text(
            'Are you sure you want to approve "${service.name}"? '
                'It will become visible to users.',
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
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _adminService.approveService(
        service.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${service.name} has been approved.',
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

  Future<void> _confirmRejectService(
      ServiceModel service,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Reject Service?',
          ),
          content: Text(
            'Are you sure you want to reject "${service.name}"?',
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
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _adminService.rejectService(
        service.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${service.name} has been rejected.',
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

  Future<void> _toggleService(
      ServiceModel service,
      ) async {
    try {
      await _adminService.setServiceActive(
        service.id,
        !service.isActive,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            service.isActive
                ? '${service.name} has been deactivated.'
                : '${service.name} has been activated.',
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

  void _showServiceDetails(
      ServiceModel service,
      ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              _ServiceIcon(
                iconName: service.icon,
                size: 42,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  service.name,
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
                  label: 'Category',
                  value: service.category,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Status',
                  value: _statusLabel(
                    service.approvalStatus,
                  ),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Visibility',
                  value: service.isPublished
                      ? 'Published'
                      : 'Not published',
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Active',
                  value: service.isActive
                      ? 'Yes'
                      : 'No',
                ),
                const SizedBox(height: 18),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  service.description.isEmpty
                      ? 'No description provided.'
                      : service.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Created By',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  service.createdBy,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
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

  String _statusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending Approval';
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Services',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: _adminService.getAllServices(),
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
                      'Unable to load services.',
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

          final services = snapshot.data ?? [];
          final filteredServices =
          _filterServices(services);

          final pendingCount = services
              .where(
                (service) =>
            service.approvalStatus == 'pending',
          )
              .length;

          final approvedCount = services
              .where(
                (service) =>
            service.approvalStatus == 'approved',
          )
              .length;

          final rejectedCount = services
              .where(
                (service) =>
            service.approvalStatus == 'rejected',
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
                    hintText: 'Search services...',
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        _searchController.clear();
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
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      count: services.length,
                      selected: _selectedTab == 0,
                      onTap: () {
                        setState(() {
                          _selectedTab = 0;
                        });
                      },
                    ),
                    _FilterChip(
                      label: 'Pending',
                      count: pendingCount,
                      selected: _selectedTab == 1,
                      onTap: () {
                        setState(() {
                          _selectedTab = 1;
                        });
                      },
                    ),
                    _FilterChip(
                      label: 'Approved',
                      count: approvedCount,
                      selected: _selectedTab == 2,
                      onTap: () {
                        setState(() {
                          _selectedTab = 2;
                        });
                      },
                    ),
                    _FilterChip(
                      label: 'Rejected',
                      count: rejectedCount,
                      selected: _selectedTab == 3,
                      onTap: () {
                        setState(() {
                          _selectedTab = 3;
                        });
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      '${filteredServices.length} service${filteredServices.length == 1 ? '' : 's'}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: filteredServices.isEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons
                              .miscellaneous_services_outlined,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No services match your search.'
                              : _selectedTab == 1
                              ? 'No pending services.'
                              : _selectedTab == 2
                              ? 'No approved services.'
                              : _selectedTab == 3
                              ? 'No rejected services.'
                              : 'No services found.',
                          textAlign:
                          TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    4,
                    16,
                    24,
                  ),
                  itemCount:
                  filteredServices.length,
                  separatorBuilder:
                      (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final service =
                    filteredServices[index];

                    return _ServiceCard(
                      service: service,
                      onTap: () {
                        _openServiceActions(
                          service,
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

class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _ServiceIcon(
                iconName: service.icon,
                size: 50,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.category,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _ApprovalBadge(
                          status:
                          service.approvalStatus,
                        ),
                        if (service.approvalStatus ==
                            'approved') ...[
                          const SizedBox(width: 8),
                          _ActiveBadge(
                            isActive:
                            service.isActive,
                          ),
                        ],
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

class _ServiceIcon extends StatelessWidget {
  final String iconName;
  final double size;

  const _ServiceIcon({
    required this.iconName,
    required this.size,
  });

  IconData _getIcon(String name) {
    switch (name) {
      case 'cleaning_services':
        return Icons.cleaning_services_outlined;

      case 'plumbing':
        return Icons.plumbing_outlined;

      case 'electrical_services':
        return Icons.electrical_services_outlined;

      case 'car_repair':
        return Icons.car_repair_outlined;

      case 'home_repair_service':
        return Icons.home_repair_service_outlined;

      case 'local_shipping':
        return Icons.local_shipping_outlined;

      case 'restaurant':
        return Icons.restaurant_outlined;

      case 'computer':
        return Icons.computer_outlined;

      case 'phone_android':
        return Icons.phone_android_outlined;

      case 'school':
        return Icons.school_outlined;

      case 'event':
        return Icons.event_outlined;

      default:
        return Icons.miscellaneous_services_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(
          size * 0.25,
        ),
      ),
      child: Icon(
        _getIcon(iconName),
        color: colorScheme.primary,
        size: size * 0.48,
      ),
    );
  }
}

class _ApprovalBadge extends StatelessWidget {
  final String status;

  const _ApprovalBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    final String label;

    switch (status) {
      case 'approved':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        label = 'Approved';
        break;

      case 'rejected':
        color = Colors.red;
        icon = Icons.cancel_outlined;
        label = 'Rejected';
        break;

      default:
        color = Colors.orange;
        icon = Icons.pending_outlined;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  final bool isActive;

  const _ActiveBadge({
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
    isActive ? Colors.green : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        onSelected: (_) {
          onTap();
        },
        label: Text(
          '$label ($count)',
        ),
        avatar: selected
            ? const Icon(
          Icons.check,
          size: 16,
        )
            : null,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
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
          width: 85,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

