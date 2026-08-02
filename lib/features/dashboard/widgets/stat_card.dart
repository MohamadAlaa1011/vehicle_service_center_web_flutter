import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool trendUp;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.trendUp = true,
  });

  const StatCard.loading({super.key})
      : title = '',
        value = '',
        icon = Icons.circle,
        color = AppTheme.primaryColor,
        trend = null,
        trendUp = true;

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      // Loading state
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              Container(
                width: double.infinity,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Container(
                width: 80,
                height: 16,
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
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                const Spacer(),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: trendUp
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendUp ? Icons.trending_up : Icons.trending_down,
                          size: 12,
                          color: trendUp ? AppColors.success : AppColors.danger,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          trend!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: trendUp ? AppColors.success : AppColors.danger,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              value,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}