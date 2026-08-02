// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      totalCustomers: json['totalCustomers'] as int,
      totalVehicles: json['totalVehicles'] as int,
      activeServiceOrders: json['activeServiceOrders'] as int,
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      inventoryValue: (json['inventoryValue'] as num).toDouble(),
      lowStockAlerts: json['lowStockAlerts'] as int,
      pendingAppointments: json['pendingAppointments'] as int,
      overdueServiceOrders: json['overdueServiceOrders'] as int,
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'totalCustomers': instance.totalCustomers,
      'totalVehicles': instance.totalVehicles,
      'activeServiceOrders': instance.activeServiceOrders,
      'monthlyRevenue': instance.monthlyRevenue,
      'inventoryValue': instance.inventoryValue,
      'lowStockAlerts': instance.lowStockAlerts,
      'pendingAppointments': instance.pendingAppointments,
      'overdueServiceOrders': instance.overdueServiceOrders,
    };