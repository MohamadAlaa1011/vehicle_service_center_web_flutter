import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';

class RecentActivitiesWidget extends ConsumerWidget {
  const RecentActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(recentActivitiesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activities',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            activitiesAsync.when(
              data: (activities) => activities.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.history,
                              size: 48,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(height: AppSizes.sm),
                            Text(
                              'No recent activities',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activities.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return _ActivityTile(
                          activity: activity,
                        );
                      },
                    ),
              loading: () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) => const _ActivityTile.loading(),
              ),
              error: (error, stackTrace) => Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.danger,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        'Failed to load activities',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final Map<String, dynamic>? activity;

  const _ActivityTile({this.activity});

  const _ActivityTile.loading() : activity = null;

  @override
  Widget build(BuildContext context) {
    if (activity == null) {
      // Loading state
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.mediumGray,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Container(
          width: double.infinity,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.mediumGray,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Container(
              width: 120,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.mediumGray,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getStatusColor(activity!['status']).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getStatusIcon(activity!['status']),
          color: _getStatusColor(activity!['status']),
          size: 20,
        ),
      ),
      title: Text(
        'Service Order #${activity!['orderNumber'] ?? 'N/A'}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${activity!['vehicleMake'] ?? ''} ${activity!['vehicleModel'] ?? ''}'.trim().isEmpty 
                ? 'Unknown Vehicle'
                : '${activity!['vehicleMake']} ${activity!['vehicleModel']}',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(activity!['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _getStatusText(activity!['status']),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _getStatusColor(activity!['status']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                _formatDate(activity!['createdAt']),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
      dense: true,
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return AppColors.warning;
      case 'IN_PROGRESS':
        return AppColors.info;
      case 'COMPLETED':
        return AppColors.success;
      case 'CANCELLED':
        return AppTheme.textSecondary;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'PENDING':
        return Icons.schedule;
      case 'IN_PROGRESS':
        return Icons.build_circle;
      case 'COMPLETED':
        return Icons.check_circle;
      case 'CANCELLED':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'PENDING':
        return 'Pending';
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}