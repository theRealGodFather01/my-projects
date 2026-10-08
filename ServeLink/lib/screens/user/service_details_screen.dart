import 'package:flutter/material.dart';

import '../../models/service_model.dart';
import 'request_service_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({
    super.key,
    required this.service,
  });

  IconData _getServiceIcon(String iconName) {
    switch (iconName) {
      case 'plumbing':
        return Icons.plumbing;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'computer':
        return Icons.computer;
      case 'car_repair':
        return Icons.car_repair;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'build':
        return Icons.build;
      case 'home_repair_service':
        return Icons.home_repair_service;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.miscellaneous_services;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service icon
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getServiceIcon(service.icon),
                    size: 55,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Service name
              Text(
                service.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Category
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service.category,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description title
              Text(
                'About this service',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Description
              Text(
                service.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 32),

              // Request button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RequestServiceScreen(
                          service: service,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'Request This Service',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Back button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Go Back',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}