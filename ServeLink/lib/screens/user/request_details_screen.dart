import 'package:flutter/material.dart';

import '../../models/service_request_model.dart';

class RequestDetailsScreen extends StatelessWidget {
  final ServiceRequestModel request;

  const RequestDetailsScreen({
    super.key,
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

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _statusColor(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 42,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    request.serviceName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Request Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  20,
                  18,
                  2,
                ),
                child: Column(
                  children: [
                    _detailRow(
                      icon: Icons.description_outlined,
                      title: 'Description',
                      value: request.description,
                    ),
                    _detailRow(
                      icon: Icons.location_on_outlined,
                      title: 'Service Address',
                      value: request.address,
                    ),
                    _detailRow(
                      icon: Icons.calendar_today_outlined,
                      title: 'Preferred Date',
                      value: _formatDate(
                        request.preferredDate,
                      ),
                    ),
                    _detailRow(
                      icon: Icons.access_time,
                      title: 'Preferred Time',
                      value: _formatTime(
                        request.preferredDate,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Request Metadata',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  20,
                  18,
                  2,
                ),
                child: Column(
                  children: [
                    _detailRow(
                      icon: Icons.tag,
                      title: 'Request ID',
                      value: request.id,
                    ),
                    _detailRow(
                      icon: Icons.access_time_outlined,
                      title: 'Request Created',
                      value: _formatDate(
                        request.createdAt,
                      ),
                    ),
                    _detailRow(
                      icon: Icons.update_outlined,
                      title: 'Last Updated',
                      value: _formatDate(
                        request.updatedAt,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}