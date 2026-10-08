import 'package:flutter/material.dart';

import '../../models/service_request_model.dart';
import '../../services/firestore_service.dart';
import 'request_details_screen.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              'My Requests',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ServiceRequestModel>>(
              stream: firestoreService.getMyRequests(),
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
                      child: Text(
                        'Unable to load your requests.\n\n'
                            '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final requests = snapshot.data ?? [];

                if (requests.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 70,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No service requests yet.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Browse our services and submit '
                                'a request when you need help.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    20,
                  ),
                  itemCount: requests.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _RequestCard(
                      request: requests[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final ServiceRequestModel request;

  const _RequestCard({
    required this.request,
  });

  Color _statusColor(BuildContext context) {
    switch (request.status) {
      case 'accepted':
        return Colors.blue;

      case 'in_progress':
        return Colors.orange;

      case 'completed':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      case 'pending':
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _statusText() {
    switch (request.status) {
      case 'in_progress':
        return 'In Progress';

      case 'pending':
        return 'Pending';

      case 'accepted':
        return 'Accepted';

      case 'completed':
        return 'Completed';

      case 'cancelled':
        return 'Cancelled';

      default:
        return request.status;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Not available';
    }

    return '${date.day}/'
        '${date.month}/'
        '${date.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) {
      return 'Not available';
    }

    final hour = date.hour == 0
        ? 12
        : date.hour > 12
        ? date.hour - 12
        : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');

    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RequestDetailsScreen(
          request: request,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.serviceName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(
                        alpha: 0.12,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusText(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                request.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      request.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(request.preferredDate),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.access_time,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(request.preferredDate),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}