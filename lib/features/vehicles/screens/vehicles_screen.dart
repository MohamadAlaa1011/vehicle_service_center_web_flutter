import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/search_bar.dart';
import '../providers/vehicles_provider.dart';

class VehiclesScreen extends ConsumerStatefulWidget {
  const VehiclesScreen({super.key});

  @override
  ConsumerState<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends ConsumerState<VehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    controller: _searchController,
                    hintText: 'Search vehicles by make, model, or plate...',
                    onChanged: (value) {
                      ref.read(vehiclesProvider.notifier).loadVehicles(
                            search: value.isEmpty ? null : value,
                          );
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                OutlinedButton.icon(
                  onPressed: () => ref.read(vehiclesProvider.notifier).loadVehicles(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            Expanded(
              child: vehiclesAsync.when(
                data: (paginated) {
                  if (paginated.data.isEmpty) {
                    return _EmptyState(
                      icon: Icons.directions_car_outlined,
                      message: 'No vehicles found',
                    );
                  }

                  return Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSizes.md),
                      itemCount: paginated.data.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final vehicle = paginated.data[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                            child: Icon(Icons.directions_car, color: AppTheme.primaryColor),
                          ),
                          title: Text(vehicle.displayName),
                          subtitle: Text(
                            'Plate: ${vehicle.plateNumber}'
                            '${vehicle.color != null ? ' · ${vehicle.color}' : ''}',
                          ),
                          trailing: Text(
                            vehicle.displayMileage,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _ErrorState(
                  message: error.toString(),
                  onRetry: () => ref.read(vehiclesProvider.notifier).loadVehicles(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppTheme.textTertiary),
          const SizedBox(height: AppSizes.sm),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.danger),
              const SizedBox(height: AppSizes.sm),
              Text('Failed to load vehicles', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSizes.xs),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.md),
              ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
            ],
          ),
        ),
      ),
    );
  }
}
