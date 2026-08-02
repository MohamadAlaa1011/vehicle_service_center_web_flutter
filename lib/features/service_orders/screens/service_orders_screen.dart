import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/service_orders_provider.dart';

class ServiceOrdersScreen extends ConsumerWidget {
  const ServiceOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(serviceOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => ref.read(serviceOrdersProvider.notifier).loadServiceOrders(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            Expanded(
              child: ordersAsync.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return const Center(child: Text('No service orders yet'));
                  }

                  return Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSizes.md),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final vehicle = order['vehicle'] as Map<String, dynamic>?;
                        final customer = order['customer'] as Map<String, dynamic>?;
                        final vehicleLabel = vehicle != null
                            ? '${vehicle['year']} ${vehicle['make']} ${vehicle['model']}'
                            : 'Unknown vehicle';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _statusColor(order['status']?.toString())
                                .withValues(alpha: 0.1),
                            child: Icon(Icons.build_circle, color: _statusColor(order['status']?.toString())),
                          ),
                          title: Text('Order #${order['orderNumber']}'),
                          subtitle: Text(
                            '${customer?['fullName'] ?? 'Unknown customer'} · $vehicleLabel\n'
                            '${order['issueDescription'] ?? ''}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
                          trailing: _StatusChip(status: order['status']?.toString()),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Failed to load service orders: $error'),
                      const SizedBox(height: AppSizes.md),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(serviceOrdersProvider.notifier).loadServiceOrders(),
                        child: const Text('Try Again'),
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

  Color _statusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return AppColors.warning;
      case 'IN_PROGRESS':
      case 'DIAGNOSING':
        return AppColors.info;
      case 'COMPLETED':
        return AppColors.success;
      case 'CANCELLED':
        return AppTheme.textSecondary;
      default:
        return AppTheme.primaryColor;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String? status;

  const _StatusChip({this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status?.replaceAll('_', ' ') ?? 'UNKNOWN',
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
