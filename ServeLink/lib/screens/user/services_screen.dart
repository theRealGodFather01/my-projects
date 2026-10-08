import 'package:flutter/material.dart';

import '../../models/service_model.dart';
import '../../services/firestore_service.dart';
import 'add_service_screen.dart';
import 'service_details_screen.dart';

class ServicesScreen extends StatefulWidget {
  final String? selectedCategory;
  final String? initialSearch;

  const ServicesScreen({super.key, this.selectedCategory, this.initialSearch});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget.selectedCategory ?? 'All';
    _searchQuery = widget.initialSearch?.trim() ?? '';

    _searchController.text = _searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _getCategories(List<ServiceModel> services) {
    final categories = services
        .map((service) => service.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();

    categories.sort();

    return ['All', ...categories];
  }

  List<ServiceModel> _filterServices(List<ServiceModel> services) {
    final query = _searchQuery.trim().toLowerCase();

    return services.where((service) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          service.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          service.name.toLowerCase().contains(query) ||
          service.description.toLowerCase().contains(query) ||
          service.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  void _clearFilters() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
    });
  }

  void _showFilterOptions(List<String> categories) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    final isSelected = _selectedCategory == category;

                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = category;
                        });

                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

      case 'home_repair_service':
        return Icons.home_repair_service;

      case 'local_shipping':
        return Icons.local_shipping;

      case 'format_paint':
        return Icons.format_paint;

      case 'content_cut':
        return Icons.content_cut;

      case 'school':
        return Icons.school;

      default:
        return Icons.miscellaneous_services;
    }
  }

  void _openAddService() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddServiceScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------------------------
            // HEADER
            // -------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    tooltip: 'Filter services',
                    onPressed: () async {
                      final services = await _firestoreService
                          .getActiveServices()
                          .first;

                      final myServices = await _firestoreService
                          .getMyServices()
                          .first;

                      if (!mounted) {
                        return;
                      }

                      final allServices = [
                        ...services,
                        ...myServices.where(
                          (myService) => !services.any(
                            (service) => service.id == myService.id,
                          ),
                        ),
                      ];

                      final categories = _getCategories(allServices);

                      _showFilterOptions(categories);
                    },
                    icon: const Icon(Icons.tune),
                  ),

                  IconButton(
                    tooltip: 'Add a service',
                    onPressed: _openAddService,
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // -------------------------------------------------------------------
            // SEARCH
            // -------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          tooltip: 'Clear search',
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
              ),
            ),

            // -------------------------------------------------------------------
            // SELECTED CATEGORY
            // -------------------------------------------------------------------
            if (_selectedCategory != 'All')
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  children: [
                    const Text(
                      'Filtered by:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    InputChip(
                      label: Text(_selectedCategory),
                      onDeleted: () {
                        setState(() {
                          _selectedCategory = 'All';
                        });
                      },
                    ),
                  ],
                ),
              ),

            // -------------------------------------------------------------------
            // SERVICES
            // -------------------------------------------------------------------
            Expanded(
              child: StreamBuilder<List<ServiceModel>>(
                stream: _firestoreService.getActiveServices(),
                builder: (context, publicSnapshot) {
                  if (publicSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (publicSnapshot.hasError) {
                    return _ErrorState(
                      message: 'Unable to load services.',
                      details: '${publicSnapshot.error}',
                    );
                  }

                  final publicServices = publicSnapshot.data ?? [];

                  return StreamBuilder<List<ServiceModel>>(
                    stream: _firestoreService.getMyServices(),
                    builder: (context, mySnapshot) {
                      if (mySnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (mySnapshot.hasError) {
                        return _ErrorState(
                          message: 'Unable to load your services.',
                          details: '${mySnapshot.error}',
                        );
                      }

                      final myServices = mySnapshot.data ?? [];

                      // ---------------------------------------------------------
                      // Combine public services with the user's own services.
                      //
                      // Approved user services already exist in the public
                      // list, so we only add the user's services that aren't
                      // already there. This allows pending/rejected services
                      // to appear to their owner without creating duplicates.
                      // ---------------------------------------------------------

                      final allServices = [
                        ...publicServices,
                        ...myServices.where(
                          (myService) => !publicServices.any(
                            (service) => service.id == myService.id,
                          ),
                        ),
                      ];

                      if (allServices.isEmpty) {
                        return _EmptyServicesState(
                          onAddService: _openAddService,
                        );
                      }

                      final categories = _getCategories(allServices);

                      final filteredServices = _filterServices(allServices);

                      final myFilteredServices = filteredServices
                          .where(
                            (service) => myServices.any(
                              (myService) => myService.id == service.id,
                            ),
                          )
                          .toList();

                      final otherFilteredServices = filteredServices
                          .where(
                            (service) => !myServices.any(
                              (myService) => myService.id == service.id,
                            ),
                          )
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // -----------------------------------------------------
                          // CATEGORY CHIPS
                          // -----------------------------------------------------
                          SizedBox(
                            height: 48,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final category = categories[index];

                                return ChoiceChip(
                                  label: Text(category),
                                  selected: _selectedCategory == category,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 8),

                          // -----------------------------------------------------
                          // RESULTS
                          // -----------------------------------------------------
                          Expanded(
                            child: filteredServices.isEmpty
                                ? _NoMatchingServicesState(
                                    hasFilters:
                                        _searchQuery.isNotEmpty ||
                                        _selectedCategory != 'All',
                                    onClear: _clearFilters,
                                  )
                                : ListView(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      8,
                                      20,
                                      24,
                                    ),
                                    children: [
                                      // -----------------------------------------
                                      // YOUR SERVICES
                                      // -----------------------------------------
                                      if (myFilteredServices.isNotEmpty) ...[
                                        const _SectionTitle(
                                          title: 'Your Services',
                                        ),
                                        const SizedBox(height: 10),
                                        ...myFilteredServices.map(
                                          (service) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: _ServiceCard(
                                              service: service,
                                              icon: _getServiceIcon(
                                                service.icon,
                                              ),
                                              colorScheme: colorScheme,
                                              isOwner: true,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],

                                      // -----------------------------------------
                                      // OTHER SERVICES
                                      // -----------------------------------------
                                      if (otherFilteredServices.isNotEmpty) ...[
                                        const _SectionTitle(
                                          title: 'Other Services',
                                        ),
                                        const SizedBox(height: 10),
                                        ...otherFilteredServices.map(
                                          (service) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: _ServiceCard(
                                              service: service,
                                              icon: _getServiceIcon(
                                                service.icon,
                                              ),
                                              colorScheme: colorScheme,
                                              isOwner: false,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION TITLE
// =============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

// =============================================================================
// SERVICE CARD
// =============================================================================

class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final IconData icon;
  final ColorScheme colorScheme;
  final bool isOwner;

  const _ServiceCard({
    required this.service,
    required this.icon,
    required this.colorScheme,
    required this.isOwner,
  });

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ServiceDetailsScreen(service: service)),
    );
  }

  Color _getStatusColor() {
    switch (service.approvalStatus) {
      case 'approved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'pending':
      default:
        return Colors.orange;
    }
  }

  String _getStatusText() {
    switch (service.approvalStatus) {
      case 'approved':
        return 'Approved';

      case 'rejected':
        return 'Rejected';

      case 'pending':
      default:
        return 'Pending approval';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------------------------------
              // ICON
              // ---------------------------------------------------------------
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 28),
              ),

              const SizedBox(width: 14),

              // ---------------------------------------------------------------
              // CONTENT
              // ---------------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isOwner)
                          _StatusBadge(
                            text: _getStatusText(),
                            color: _getStatusColor(),
                          ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      service.category,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      service.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        if (isOwner) ...[
                          Icon(
                            Icons.person_outline,
                            size: 15,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Your Service',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ] else ...[
                          Icon(
                            Icons.person_outline,
                            size: 15,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Other provider',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],

                        const Spacer(),

                        Text(
                          'View Details',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 4),

                        Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// STATUS BADGE
// =============================================================================

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// =============================================================================
// EMPTY STATE
// =============================================================================

class _EmptyServicesState extends StatelessWidget {
  final VoidCallback onAddService;

  const _EmptyServicesState({required this.onAddService});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.miscellaneous_services_outlined,
              size: 70,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No services available yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Be the first to add a service you provide.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAddService,
              icon: const Icon(Icons.add),
              label: const Text('Add Your Service'),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// NO MATCHING SERVICES
// =============================================================================

class _NoMatchingServicesState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClear;

  const _NoMatchingServicesState({
    required this.hasFilters,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade500),
            const SizedBox(height: 16),
            const Text(
              'No matching services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Try another search or change the category filter.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            if (hasFilters)
              OutlinedButton(
                onPressed: onClear,
                child: const Text('Clear Filters'),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ERROR STATE
// =============================================================================

class _ErrorState extends StatelessWidget {
  final String message;
  final String details;

  const _ErrorState({required this.message, required this.details});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              details,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
