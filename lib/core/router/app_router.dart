import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/customers/screens/customers_screen.dart';
import '../../features/vehicles/screens/vehicles_screen.dart';
import '../../features/service_orders/screens/service_orders_screen.dart';
import '../../features/spare_parts/screens/spare_parts_screen.dart';
import '../../shared/widgets/coming_soon_screen.dart';
import '../../shared/widgets/main_layout.dart';
import '../../features/auth/providers/auth_provider.dart';

// Routes
class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/';
  static const String customers = '/customers';
  static const String vehicles = '/vehicles';
  static const String serviceOrders = '/service-orders';
  static const String parts = '/parts';
  static const String invoices = '/invoices';
  static const String reports = '/reports';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    redirect: (context, state) async {
      final apiService = ref.read(apiServiceProvider);
      final isLoggedIn = await apiService.isLoggedIn();
      final isLoggingIn = state.uri.toString() == AppRoutes.login;
      
      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.login;
      }
      
      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.dashboard;
      }
      
      return null;
    },
    routes: [
      // Login route (no layout)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Main app routes (with layout)
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.customers,
            builder: (context, state) => const CustomersScreen(),
          ),
          GoRoute(
            path: AppRoutes.vehicles,
            builder: (context, state) => const VehiclesScreen(),
          ),
          GoRoute(
            path: AppRoutes.serviceOrders,
            builder: (context, state) => const ServiceOrdersScreen(),
          ),
          GoRoute(
            path: AppRoutes.parts,
            builder: (context, state) => const SparePartsScreen(),
          ),
          GoRoute(
            path: AppRoutes.invoices,
            builder: (context, state) => const ComingSoonScreen(
              title: 'Invoices',
              description: 'Invoice management and payment tracking will be available here.',
              icon: Icons.receipt_long_outlined,
            ),
          ),
          GoRoute(
            path: AppRoutes.reports,
            builder: (context, state) => const ComingSoonScreen(
              title: 'Reports',
              description: 'Business reports and analytics will be available here.',
              icon: Icons.analytics_outlined,
            ),
          ),
        ],
      ),
    ],
  );
});