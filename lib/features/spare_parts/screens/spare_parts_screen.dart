import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/json_utils.dart';
import '../providers/spare_parts_provider.dart';

class SparePartsScreen extends ConsumerWidget {
  const SparePartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partsAsync = ref.watch(sparePartsProvider);

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
                  onPressed: () => ref.read(sparePartsProvider.notifier).loadSpareParts(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            Expanded(
              child: partsAsync.when(
                data: (parts) {
                  if (parts.isEmpty) {
                    return const Center(child: Text('No spare parts in inventory'));
                  }

                  return Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSizes.md),
                      itemCount: parts.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final part = parts[index];
                        final quantity = parseJsonInt(part['quantity']);
                        final minimumStock = parseJsonInt(part['minimumStock']);
                        final isLowStock = quantity <= minimumStock;
                        final price = parseJsonDouble(part['sellingPrice']);

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isLowStock
                                ? AppColors.warning.withValues(alpha: 0.1)
                                : AppTheme.primaryColor.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.inventory_2_outlined,
                              color: isLowStock ? AppColors.warning : AppTheme.primaryColor,
                            ),
                          ),
                          title: Text(part['name']?.toString() ?? 'Unknown part'),
                          subtitle: Text(
                            'SKU: ${part['sku']} · ${part['category']}\n'
                            'Stock: $quantity (min $minimumStock)',
                          ),
                          isThreeLine: true,
                          trailing: Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
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
                      Text('Failed to load spare parts: $error'),
                      const SizedBox(height: AppSizes.md),
                      ElevatedButton(
                        onPressed: () => ref.read(sparePartsProvider.notifier).loadSpareParts(),
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
}
