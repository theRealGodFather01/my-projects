import 'package:flutter/material.dart';

import '../../models/service_request_model.dart';
import '../../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services_screen.dart';
import 'requests_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboard(),
    ServicesScreen(),
    RequestsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? HomeDashboard(
        onOpenRequests: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      )
          : _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  final VoidCallback? onOpenRequests;

  const HomeDashboard({
    super.key,
    this.onOpenRequests,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .get(),
                        builder: (context, snapshot) {
                          String userName = 'there';

                          if (snapshot.hasData && snapshot.data?.data() != null) {
                            final data = snapshot.data!.data()!;
                            final fullName = data['fullName']?.toString().trim();

                            if (fullName != null && fullName.isNotEmpty) {
                              userName = fullName;
                            }
                          }

                          return Text(
                            'Hello 👋, $userName',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Welcome to ServeLink',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Search
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ServicesScreen(),
                        ),
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'What service do you need?',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    tooltip: 'Filter services',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ServicesScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.tune,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Service Categories
            const Text(
              'Service Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _CategoryCard(
                    icon: Icons.plumbing,
                    title: 'Plumbing',
                  ),
                  _CategoryCard(
                    icon: Icons.cleaning_services,
                    title: 'Cleaning',
                  ),
                  _CategoryCard(
                    icon: Icons.computer,
                    title: 'Technology',
                  ),
                  _CategoryCard(
                    icon: Icons.car_repair,
                    title: 'Auto',
                  ),
                  _CategoryCard(
                    icon: Icons.electrical_services,
                    title: 'Electrical',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // My Requests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: onOpenRequests,
                  child: const Text('View all'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const _MyRequestsCard(),

            const SizedBox(height: 28),

            // Popular Services
            const Text(
              'Popular Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.miscellaneous_services_outlined,
                    size: 44,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Services coming soon',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Available services will appear here when they are added.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
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
}

class _MyRequestsCard extends StatelessWidget {
  const _MyRequestsCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ServiceRequestModel>>(
      stream: FirestoreService().getMyRequests(),
      builder: (context, snapshot) {
        final colorScheme = Theme.of(context).colorScheme;

        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 42,
                  height: 42,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Loading your requests...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 42,
                  color: Colors.red.shade700,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Unable to load your requests.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final requests = snapshot.data ?? [];

        // No requests
        if (requests.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 42,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No requests yet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Request a service and track it here.',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Show the most recent request
        final request = requests.first;

        return _ActiveRequestCard(
          request: request,
        );
      },
    );
  }
}

class _ActiveRequestCard extends StatelessWidget {
  final ServiceRequestModel request;

  const _ActiveRequestCard({
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.serviceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      request.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

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

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 18,
              ),
              const SizedBox(width: 6),
              const Text(
                'Status:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              _StatusChip(
                status: request.status,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({
    required this.status,
  });

  String _getStatusLabel() {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      case 'accepted':
        return 'Accepted';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
      default:
        return 'Pending';
    }
  }

  Color _getStatusColor() {
    switch (status) {
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
        return Colors.amber.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusLabel(),
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CategoryCard({
    required this.icon,
    required this.title,
  });

  void _openCategory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServicesScreen(
          selectedCategory: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openCategory(context),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

