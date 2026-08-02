import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSizes.lg),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: AppSizes.md,
              mainAxisSpacing: AppSizes.md,
              childAspectRatio: 1.2,
              children: [
                _QuickActionCard(
                  icon: Icons.person_add_outlined,
                  title: 'Add Customer',
                  color: AppTheme.primaryColor,
                  onTap: () => context.go(AppRoutes.customers),
                ),
                _QuickActionCard(
                  icon: Icons.directions_car_outlined,
                  title: 'Add Vehicle',
                  color: AppColors.info,
                  onTap: () => context.go(AppRoutes.vehicles),
                ),
                _QuickActionCard(
                  icon: Icons.build_circle_outlined,
                  title: 'New Service Order',
                  color: AppColors.success,
                  onTap: () => context.go(AppRoutes.serviceOrders),
                ),
                _QuickActionCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Manage Parts',
                  color: AppColors.warning,
                  onTap: () => context.go(AppRoutes.parts),
                ),
                _QuickActionCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Create Invoice',
                  color: AppTheme.secondaryColor,
                  onTap: () => context.go(AppRoutes.invoices),
                ),
                _QuickActionCard(
                  icon: Icons.analytics_outlined,
                  title: 'View Reports',
                  color: Colors.purple,
                  onTap: () => context.go(AppRoutes.reports),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          border: Border.all(color: color.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}