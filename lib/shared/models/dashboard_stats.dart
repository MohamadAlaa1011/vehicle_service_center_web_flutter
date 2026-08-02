import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats.g.dart';

@JsonSerializable()
class DashboardStats {
  final int totalCustomers;
  final int totalVehicles;
  final int activeServiceOrders;
  final double monthlyRevenue;
  final double inventoryValue;
  final int lowStockAlerts;
  final int pendingAppointments;
  final int overdueServiceOrders;
  
  DashboardStats({
    required this.totalCustomers,
    required this.totalVehicles,
    required this.activeServiceOrders,
    required this.monthlyRevenue,
    required this.inventoryValue,
    required this.lowStockAlerts,
    required this.pendingAppointments,
    required this.overdueServiceOrders,
  });
  
  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}