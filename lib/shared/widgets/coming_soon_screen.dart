import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.construction_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 64, color: AppTheme.primaryColor),
                  const SizedBox(height: AppSizes.lg),
                  Text(title, style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Coming soon',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
