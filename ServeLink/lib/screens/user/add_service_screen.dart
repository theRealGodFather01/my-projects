import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _descriptionController =
  TextEditingController();

  String? _selectedCategory;
  String _selectedIcon = 'miscellaneous_services';

  bool _isSubmitting = false;

  final List<String> _categories = [
    'Plumbing',
    'Cleaning',
    'Technology',
    'Auto',
    'Electrical',
    'Home Repair',
    'Moving & Delivery',
    'Painting',
    'Beauty',
    'Education',
    'Other',
  ];

  final Map<String, IconData> _icons = {
    'plumbing': Icons.plumbing,
    'cleaning_services': Icons.cleaning_services,
    'computer': Icons.computer,
    'car_repair': Icons.car_repair,
    'electrical_services': Icons.electrical_services,
    'home_repair_service': Icons.home_repair_service,
    'local_shipping': Icons.local_shipping,
    'format_paint': Icons.format_paint,
    'content_cut': Icons.content_cut,
    'school': Icons.school,
    'miscellaneous_services':
    Icons.miscellaneous_services,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _firestoreService.createUserService(
        name: _nameController.text,
        description: _descriptionController.text,
        category: _selectedCategory!,
        icon: _selectedIcon,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Service submitted successfully. '
                'It is now waiting for admin approval.',
          ),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to submit service: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showIconPicker() {
    showModalBottomSheet<void>(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Service Icon',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _icons.entries.map((entry) {
                    final isSelected =
                        _selectedIcon == entry.key;

                    return InkWell(
                      borderRadius:
                      BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          _selectedIcon = entry.key;
                        });

                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              : Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                            width: 2,
                          )
                              : null,
                        ),
                        child: Icon(
                          entry.value,
                          color: isSelected
                              ? Theme.of(context)
                              .colorScheme
                              .primary
                              : Colors.grey.shade700,
                        ),
                      ),
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

  IconData _getSelectedIcon() {
    return _icons[_selectedIcon] ??
        Icons.miscellaneous_services;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              32,
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Add a service that you provide. '
                            'Your service will be reviewed by an '
                            'administrator before it becomes '
                            'available to other users.',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Service Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  hintText:
                  'e.g. Home Plumbing Services',
                  prefixIcon: Icon(Icons.business_center),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter a service name.';
                  }

                  if (value.trim().length < 3) {
                    return 'Service name is too short.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(
                    Icons.category_outlined,
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 7,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText:
                  'Describe the service you provide...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 70),
                    child: Icon(Icons.description_outlined),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please describe your service.';
                  }

                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Service Icon',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _isSubmitting
                    ? null
                    : _showIconPicker,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color:
                          colorScheme.primaryContainer,
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _getSelectedIcon(),
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose an icon',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Select an icon that represents your service.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed:
                  _isSubmitting ? null : _submitService,
                  child: _isSubmitting
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    'Submit Service',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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