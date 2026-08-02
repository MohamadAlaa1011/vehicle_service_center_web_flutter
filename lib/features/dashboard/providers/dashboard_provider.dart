import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/models/dashboard_stats.dart';

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final response = await apiService.get('/dashboard/stats');
  return DashboardStats.fromJson(response.data as Map<String, dynamic>);
});

final recentActivitiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final response = await apiService.get('/dashboard/recent-orders');
  final orders = List<Map<String, dynamic>>.from(response.data as List);

  return orders.map((order) {
    final vehicle = order['vehicle'] as Map<String, dynamic>?;
    return {
      'orderNumber': order['orderNumber'],
      'status': order['status'],
      'createdAt': order['createdAt'],
      'vehicleMake': vehicle?['make'],
      'vehicleModel': vehicle?['model'],
    };
  }).toList();
});

final systemAlertsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final response = await apiService.get('/dashboard/alerts');
  final data = response.data as Map<String, dynamic>;
  final alerts = <Map<String, dynamic>>[];

  for (final part in (data['lowStockParts'] as List? ?? [])) {
    final item = part as Map<String, dynamic>;
    alerts.add({
      'type': 'LOW_STOCK',
      'message': 'Low stock: ${item['name']} (${item['quantity']} remaining)',
      'createdAt': item['updatedAt']?.toString() ?? '',
    });
  }

  for (final order in (data['overdueOrders'] as List? ?? [])) {
    final item = order as Map<String, dynamic>;
    alerts.add({
      'type': 'OVERDUE_SERVICE',
      'message': 'Overdue order #${item['orderNumber']}',
      'createdAt': item['createdAt']?.toString() ?? '',
    });
  }

  for (final appointment in (data['upcomingAppointments'] as List? ?? [])) {
    final item = appointment as Map<String, dynamic>;
    final customer = item['customer'] as Map<String, dynamic>?;
    alerts.add({
      'type': 'SYSTEM',
      'message': 'Upcoming appointment: ${customer?['fullName'] ?? 'Customer'}',
      'createdAt': item['appointmentDate']?.toString() ?? '',
    });
  }

  return alerts;
});
