import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/customers_provider.dart';

class AddCustomerDialog extends ConsumerStatefulWidget {
  const AddCustomerDialog({super.key});

  @override
  ConsumerState<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends ConsumerState<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final customerData = {
        'fullName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        'address': _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        'notes': _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      };

      await ref.read(customersProvider.notifier).createCustomer(customerData);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Customer added successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add customer: ${e.toString()}'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.borderColor),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_add,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    'Add New Customer',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name *',
                          hintText: 'Enter customer\'s full name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          if (value.trim().length < 2) {
                            return 'Full name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Phone
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number *',
                          hintText: 'Enter phone number',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          if (value.trim().length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'Enter email address (optional)',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Address
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          hintText: 'Enter address (optional)',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          hintText: 'Additional notes (optional)',
                          prefixIcon: Icon(Icons.note_outlined),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.borderColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Add Customer'),
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