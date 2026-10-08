import 'package:flutter/material.dart';

import '../../models/admin_service_request_model.dart';
import '../../services/admin_service.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() =>
      _AdminRequestsScreenState();
}

class _AdminRequestsScreenState
    extends State<AdminRequestsScreen> {
  final AdminService _adminService = AdminService();

  final TextEditingController _searchController =
  TextEditingController();

  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<Map<String, String>> _filters = const [
    {
      'label': 'All',
      'value': 'all',
    },
    {
      'label': 'Pending',
      'value': 'pending',
    },
    {
      'label': 'Accepted',
      'value': 'accepted',
    },
    {
      'label': 'In Progress',
      'value': 'in_progress',
    },
    {
      'label': 'Completed',
      'value': 'completed',
    },
    {
      'label': 'Cancelled',
      'value': 'cancelled',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminServiceRequestModel> _filterRequests(
      List<AdminServiceRequestModel> requests,
      ) {
    final query = _searchQuery.trim().toLowerCase();

    return requests.where((item) {
      final request = item.request;

      final matchesFilter =
          _selectedFilter == 'All' ||
              request.status == _selectedFilter;

      if (!matchesFilter) {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }

      return item.customerDisplayName
          .toLowerCase()
          .contains(query) ||
          item.customerEmailDisplay
              .toLowerCase()
              .contains(query) ||
          item.customerPhoneDisplay
              .toLowerCase()
              .contains(query) ||
          request.serviceName
              .toLowerCase()
              .contains(query) ||
          request.description
              .toLowerCase()
              .contains(query) ||
          request.address
              .toLowerCase()
              .contains(query) ||
          request.status
              .toLowerCase()
              .contains(query) ||
          request.userId
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Requests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<AdminServiceRequestModel>>(
        stream: _adminService.getAdminServiceRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState(
              snapshot.error.toString(),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final requests = snapshot.data ?? [];

          final filteredRequests =
          _filterRequests(requests);

          return Column(
            children: [
              _buildSearchField(),
              _buildFilterChips(),
              Expanded(
                child: filteredRequests.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      24,
                    ),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      return _buildRequestCard(
                        filteredRequests[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        8,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText:
          'Search customer, service, phone or address...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();

              setState(() {
                _searchQuery = '';
              });
            },
            icon: const Icon(Icons.clear),
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final label = filter['label']!;
          // final value = filter['value']!;

          final selected =
              _selectedFilter == label;

          return FilterChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedFilter = label;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(
      AdminServiceRequestModel item,
      ) {
    final request = item.request;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openRequestActions(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Text(
                      item.customerDisplayName
                          .trim()
                          .isNotEmpty
                          ? item.customerDisplayName
                          .trim()
                          .substring(0, 1)
                          .toUpperCase()
                          : '?',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.customerDisplayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.customerEmailDisplay,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(request.status),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.miscellaneous_services,
                    size: 18,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      request.serviceName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (request.address.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        request.address,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (request.preferredDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(
                        request.preferredDate!,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap to manage',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 13,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    String label;

    switch (status) {
      case 'in_progress':
        label = 'In Progress';
        break;
      case 'accepted':
        label = 'Accepted';
        break;
      case 'completed':
        label = 'Completed';
        break;
      case 'cancelled':
        label = 'Cancelled';
        break;
      default:
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _statusColor(status),
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.amber.shade800;
    }
  }

  Future<void> _openRequestActions(
      AdminServiceRequestModel item,
      ) async {
    final request = item.request;

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  request.serviceName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.customerDisplayName,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.visibility),
                  title: const Text('View Details'),
                  onTap: () {
                    Navigator.pop(context);

                    _showRequestDetails(item);
                  },
                ),
                ListTile(
                  leading:
                  const Icon(Icons.sync_alt),
                  title: const Text(
                    'Change Request Status',
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    _showStatusSelector(item);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showStatusSelector(
      AdminServiceRequestModel item,
      ) async {
    final request = item.request;

    final statuses = [
      {
        'value': 'pending',
        'label': 'Pending',
      },
      {
        'value': 'accepted',
        'label': 'Accepted',
      },
      {
        'value': 'in_progress',
        'label': 'In Progress',
      },
      {
        'value': 'completed',
        'label': 'Completed',
      },
      {
        'value': 'cancelled',
        'label': 'Cancelled',
      },
    ];

    String selectedStatus = request.status;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return AlertDialog(
              title: const Text(
                'Change Request Status',
              ),
              content: DropdownButtonFormField<String>(
                initialValue:
                statuses.any(
                      (status) =>
                  status['value'] ==
                      selectedStatus,
                )
                    ? selectedStatus
                    : 'pending',
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                items: statuses.map((status) {
                  return DropdownMenuItem<String>(
                    value: status['value'],
                    child: Text(
                      status['label']!,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setDialogState(() {
                    selectedStatus = value;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed:
                  selectedStatus == request.status
                      ? null
                      : () async {
                    Navigator.pop(context);

                    await _updateStatus(
                      request.id,
                      selectedStatus,
                    );
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateStatus(
      String requestId,
      String status,
      ) async {
    try {
      await _adminService
          .updateServiceRequestStatus(
        requestId,
        status,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Request status updated successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e.toString());
    }
  }

  void _showRequestDetails(
      AdminServiceRequestModel item,
      ) {
    final request = item.request;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Request Details',
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _detailSection(
                  'Customer',
                  item.customerDisplayName,
                ),
                _detailSection(
                  'Email',
                  item.customerEmailDisplay,
                ),
                _detailSection(
                  'Phone',
                  item.customerPhoneDisplay,
                ),
                _detailSection(
                  'Service',
                  request.serviceName,
                ),
                _detailSection(
                  'Description',
                  request.description.isEmpty
                      ? 'No description provided.'
                      : request.description,
                ),
                _detailSection(
                  'Address',
                  request.address.isEmpty
                      ? 'No address provided.'
                      : request.address,
                ),
                _detailSection(
                  'Preferred Date',
                  request.preferredDate == null
                      ? 'Not specified'
                      : _formatDate(
                    request.preferredDate!,
                  ),
                ),
                _detailSection(
                  'Status',
                  _statusLabel(request.status),
                ),
                _detailSection(
                  'Request ID',
                  request.id,
                ),
                _detailSection(
                  'Customer ID',
                  request.userId,
                ),
                if (request.createdAt != null)
                  _detailSection(
                    'Created',
                    _formatDate(
                      request.createdAt!,
                    ),
                  ),
                if (request.updatedAt != null)
                  _detailSection(
                    'Last Updated',
                    _formatDate(
                      request.updatedAt!,
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

  Widget _detailSection(
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          SelectableText(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      case 'accepted':
        return 'Accepted';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  String _formatDate(DateTime date) {
    final day =
    date.day.toString().padLeft(2, '0');
    final month =
    date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No service requests found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty ||
                  _selectedFilter != 'All'
                  ? 'Try changing your search or filter.'
                  : 'There are no service requests yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 56,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load service requests.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    final cleanedMessage =
    message.replaceFirst(
      'Exception: ',
      '',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cleanedMessage),
      ),
    );
  }
}