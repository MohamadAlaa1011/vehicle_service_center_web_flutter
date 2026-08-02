import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_activities.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards Row
            Consumer(
              builder: (context, ref, child) {
                final statsAsync = ref.watch(dashboardStatsProvider);
                
                return statsAsync.when(
                  data: (stats) => Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Total Customers',
                          value: stats.totalCustomers.toString(),
                          icon: Icons.people,
                          color: AppTheme.primaryColor,
                          trend: '+12%',
                          trendUp: true,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: StatCard(
                          title: 'Active Orders',
                          value: stats.activeServiceOrders.toString(),
                          icon: Icons.build_circle,
                          color: AppColors.warning,
                          trend: '+5%',
                          trendUp: true,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: StatCard(
                          title: 'Monthly Revenue',
                          value: '\$${stats.monthlyRevenue.toStringAsFixed(0)}',
                          icon: Icons.attach_money,
                          color: AppColors.success,
                          trend: '+18%',
                          trendUp: true,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: StatCard(
                          title: 'Total Vehicles',
                          value: stats.totalVehicles.toString(),
                          icon: Icons.directions_car,
                          color: AppColors.info,
                          trend: '+3%',
                          trendUp: true,
                        ),
                      ),
                    ],
                  ),
                  loading: () => Row(
                    children: List.generate(
                      4,
                      (index) => Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: index < 3 ? AppSizes.md : 0,
                          ),
                          child: const StatCard.loading(),
                        ),
                      ),
                    ),
                  ),
                  error: (error, stackTrace) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.lg),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: AppColors.danger),
                        const SizedBox(width: AppSizes.sm),
                        Text(
                          'Failed to load dashboard stats: ${error.toString()}',
                          style: TextStyle(color: AppColors.danger),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Main content row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Quick Actions
                      const QuickActionsWidget(),
                      const SizedBox(height: AppSizes.lg),
                      
                      // Revenue Chart
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Revenue Overview',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  DropdownButton<String>(
                                    value: 'This Month',
                                    items: const [
                                      DropdownMenuItem(value: 'This Week', child: Text('This Week')),
                                      DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                                      DropdownMenuItem(value: 'This Year', child: Text('This Year')),
                                    ],
                                    onChanged: (value) {},
                                    underline: const SizedBox(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.lg),
                              SizedBox(
                                height: 200,
                                child: LineChart(
                                  LineChartData(
                                    gridData: const FlGridData(show: false),
                                    titlesData: const FlTitlesData(show: false),
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: [
                                          const FlSpot(0, 3),
                                          const FlSpot(1, 4),
                                          const FlSpot(2, 3.5),
                                          const FlSpot(3, 5),
                                          const FlSpot(4, 4),
                                          const FlSpot(5, 6),
                                          const FlSpot(6, 5.5),
                                        ],
                                        isCurved: true,
                                        color: AppTheme.primaryColor,
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: AppTheme.primaryColor.withOpacity(0.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: AppSizes.lg),
                
                // Right column
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Recent Activities
                      const RecentActivitiesWidget(),
                      const SizedBox(height: AppSizes.lg),
                      
                      // System Alerts
                      Consumer(
                        builder: (context, ref, child) {
                          final alertsAsync = ref.watch(systemAlertsProvider);
                          
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSizes.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.warning_amber_outlined,
                                        color: AppColors.warning,
                                        size: 20,
                                      ),
                                      const SizedBox(width: AppSizes.sm),
                                      Text(
                                        'System Alerts',
                                        style: Theme.of(context).textTheme.headlineSmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSizes.md),
                                  alertsAsync.when(
                                    data: (alerts) => alerts.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(AppSizes.md),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle_outline,
                                                    color: AppColors.success,
                                                    size: 48,
                                                  ),
                                                  const SizedBox(height: AppSizes.sm),
                                                  Text(
                                                    'All systems running smoothly',
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
                                            itemCount: alerts.length,
                                            separatorBuilder: (context, index) => const Divider(),
                                            itemBuilder: (context, index) {
                                              final alert = alerts[index];
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: Icon(
                                                  _getAlertIcon(alert['type']),
                                                  color: _getAlertColor(alert['type']),
                                                  size: 20,
                                                ),
                                                title: Text(
                                                  alert['message'] ?? 'Unknown alert',
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                                subtitle: Text(
                                                  alert['createdAt'] ?? 'Unknown time',
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                ),
                                                dense: true,
                                              );
                                            },
                                          ),
                                    loading: () => const Center(child: CircularProgressIndicator()),
                                    error: (error, stackTrace) => Padding(
                                      padding: const EdgeInsets.all(AppSizes.md),
                                      child: Text(
                                        'Failed to load alerts',
                                        style: TextStyle(color: AppColors.danger),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAlertIcon(String? type) {
    switch (type) {
      case 'LOW_STOCK':
        return Icons.inventory_2_outlined;
      case 'OVERDUE_SERVICE':
        return Icons.schedule_outlined;
      case 'SYSTEM':
        return Icons.settings_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getAlertColor(String? type) {
    switch (type) {
      case 'LOW_STOCK':
        return AppColors.warning;
      case 'OVERDUE_SERVICE':
        return AppColors.danger;
      case 'SYSTEM':
        return AppColors.info;
      default:
        return AppTheme.textSecondary;
    }
  }
}