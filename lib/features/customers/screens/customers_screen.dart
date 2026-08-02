import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/search_bar.dart';
import '../providers/customers_provider.dart';
import '../widgets/customer_card.dart';
import '../widgets/add_customer_dialog.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    ref.read(customersProvider.notifier).loadCustomers(search: value.isEmpty ? null : value);
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddCustomerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            // Header with search and actions
            Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    controller: _searchController,
                    hintText: 'Search customers by name, phone, or email...',
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                ElevatedButton.icon(
                  onPressed: _showAddCustomerDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Customer'),
                ),
                const SizedBox(width: AppSizes.sm),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(customersProvider.notifier).loadCustomers();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // Content
            Expanded(
              child: customersAsync.when(
                data: (paginatedCustomers) {
                  final customers = paginatedCustomers.data;
                  
                  if (customers.isEmpty) {
                    return _buildEmptyState();
                  }

                  return Column(
                    children: [
                      // Results info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Showing ${customers.length} of ${paginatedCustomers.meta.total} customers',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            if (_searchQuery.isNotEmpty)
                              Chip(
                                label: Text('Search: $_searchQuery'),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Customers grid
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: AppSizes.md,
                            mainAxisSpacing: AppSizes.md,
                          ),
                          itemCount: customers.length,
                          itemBuilder: (context, index) {
                            return CustomerCard(customer: customers[index]);
                          },
                        ),
                      ),

                      // Pagination (if needed)
                      if (paginatedCustomers.meta.totalPages > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSizes.md),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: paginatedCustomers.meta.hasPrevPage
                                    ? () => ref.read(customersProvider.notifier).loadCustomers(
                                          page: paginatedCustomers.meta.page - 1,
                                          search: _searchQuery.isEmpty ? null : _searchQuery,
                                        )
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                              ),
                              Text(
                                'Page ${paginatedCustomers.meta.page} of ${paginatedCustomers.meta.totalPages}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              IconButton(
                                onPressed: paginatedCustomers.meta.hasNextPage
                                    ? () => ref.read(customersProvider.notifier).loadCustomers(
                                          page: paginatedCustomers.meta.page + 1,
                                          search: _searchQuery.isEmpty ? null : _searchQuery,
                                        )
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
                loading: () => _buildLoadingState(),
                error: (error, stackTrace) => _buildErrorState(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: AppTheme.textTertiary,
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                _searchQuery.isEmpty ? 'No customers found' : 'No matching customers',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                _searchQuery.isEmpty 
                    ? 'Get started by adding your first customer'
                    : 'Try adjusting your search terms',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.lg),
              if (_searchQuery.isEmpty)
                ElevatedButton.icon(
                  onPressed: _showAddCustomerDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add First Customer'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppSizes.md,
        mainAxisSpacing: AppSizes.md,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const CustomerCard.loading(),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.danger,
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                'Failed to load customers',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.lg),
              ElevatedButton.icon(
                onPressed: () => ref.read(customersProvider.notifier).loadCustomers(),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}