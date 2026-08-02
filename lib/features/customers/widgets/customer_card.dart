import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer? customer;

  const CustomerCard({super.key, required this.customer});

  const CustomerCard.loading({super.key}) : customer = null;

  @override
  Widget build(BuildContext context) {
    if (customer == null) {
      // Loading state
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Container(
                width: 120,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: InkWell(
        onTap: () => _showCustomerDetails(context),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      customer!.fullName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(context, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                customer!.fullName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.xs),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      customer!.phone,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (customer!.email != null) ...[
                const SizedBox(height: AppSizes.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      size: 14,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        customer!.email!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Customer since ${_formatDate(customer!.createdAt)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomerDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Customer Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${customer!.fullName}'),
            const SizedBox(height: 8),
            Text('Phone: ${customer!.phone}'),
            if (customer!.email != null) ...[
              const SizedBox(height: 8),
              Text('Email: ${customer!.email}'),
            ],
            if (customer!.address != null) ...[
              const SizedBox(height: 8),
              Text('Address: ${customer!.address}'),
            ],
            if (customer!.notes != null) ...[
              const SizedBox(height: 8),
              Text('Notes: ${customer!.notes}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        // TODO: Implement edit functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit functionality coming soon')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text('Are you sure you want to delete ${customer!.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete functionality coming soon')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).round();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).round();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}