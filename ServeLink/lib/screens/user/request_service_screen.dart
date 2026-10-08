import 'package:flutter/material.dart';

import '../../models/service_model.dart';
import '../../services/firestore_service.dart';

class RequestServiceScreen extends StatefulWidget {
  final ServiceModel service;

  const RequestServiceScreen({
    super.key,
    required this.service,
  });

  @override
  State<RequestServiceScreen> createState() =>
      _RequestServiceScreenState();
}

class _RequestServiceScreenState
    extends State<RequestServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  DateTime? _preferredDate;
  TimeOfDay? _preferredTime;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(
        now.year + 1,
        now.month,
        now.day,
      ),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _preferredDate = selectedDate;
    });
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) {
      return;
    }

    setState(() {
      _preferredTime = selectedTime;
    });
  }

  DateTime? _getPreferredDateTime() {
    if (_preferredDate == null || _preferredTime == null) {
      return null;
    }

    return DateTime(
      _preferredDate!.year,
      _preferredDate!.month,
      _preferredDate!.day,
      _preferredTime!.hour,
      _preferredTime!.minute,
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_preferredDate == null) {
      _showMessage('Please select your preferred date.');
      return;
    }

    if (_preferredTime == null) {
      _showMessage('Please select your preferred time.');
      return;
    }

    final preferredDateTime = _getPreferredDateTime();

    if (preferredDateTime == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _firestoreService.createServiceRequest(
        serviceId: widget.service.id,
        serviceName: widget.service.name,
        description: _descriptionController.text,
        address: _addressController.text,
        preferredDate: preferredDateTime,
      );

      if (!mounted) return;

      _showMessage(
        'Service request submitted successfully.',
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Unable to submit request. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _formatDate() {
    if (_preferredDate == null) {
      return 'Select preferred date';
    }

    return '${_preferredDate!.day}/'
        '${_preferredDate!.month}/'
        '${_preferredDate!.year}';
  }

  String _formatTime() {
    if (_preferredTime == null) {
      return 'Select preferred time';
    }

    return _preferredTime!.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Service'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Service
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.miscellaneous_services,
                      size: 36,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Service',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.service.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Describe what you need',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText:
                  'Tell us what you need help with...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please describe your request.';
                  }

                  if (value.trim().length < 10) {
                    return 'Please provide a little more detail.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Service location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                  'Enter the address where the service is needed',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter the service address.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Preferred date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : _selectDate,
                icon: const Icon(Icons.calendar_today),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_formatDate()),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Preferred time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : _selectTime,
                icon: const Icon(Icons.access_time),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_formatTime()),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed:
                  _isSubmitting ? null : _submitRequest,
                  child: _isSubmitting
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Submit Service Request',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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