import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/router/app_router.dart';
import '../../features/auth/providers/auth_provider.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  
  const MainLayout({super.key, required this.child});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          const SideNavigationBar(),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Top app bar
                const TopAppBar(),
                // Main content area
                Expanded(
                  child: Container(
                    color: AppColors.lightGray,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SideNavigationBar extends ConsumerWidget {
  const SideNavigationBar({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      child: Column(
        children: [
          // Logo/Header
          Container(
            height: 80,
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.build_circle,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Service Center',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Management System',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.sm),
              children: [
                _NavigationItem(
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  label: 'Dashboard',
                  route: AppRoutes.dashboard,
                  isSelected: currentLocation == AppRoutes.dashboard,
                ),
                _NavigationItem(
                  icon: Icons.people_outline,
                  selectedIcon: Icons.people,
                  label: 'Customers',
                  route: AppRoutes.customers,
                  isSelected: currentLocation == AppRoutes.customers,
                ),
                _NavigationItem(
                  icon: Icons.directions_car_outlined,
                  selectedIcon: Icons.directions_car,
                  label: 'Vehicles',
                  route: AppRoutes.vehicles,
                  isSelected: currentLocation == AppRoutes.vehicles,
                ),
                _NavigationItem(
                  icon: Icons.build_outlined,
                  selectedIcon: Icons.build,
                  label: 'Service Orders',
                  route: AppRoutes.serviceOrders,
                  isSelected: currentLocation == AppRoutes.serviceOrders,
                ),
                _NavigationItem(
                  icon: Icons.inventory_outlined,
                  selectedIcon: Icons.inventory,
                  label: 'Spare Parts',
                  route: AppRoutes.parts,
                  isSelected: currentLocation == AppRoutes.parts,
                ),
                _NavigationItem(
                  icon: Icons.receipt_long_outlined,
                  selectedIcon: Icons.receipt_long,
                  label: 'Invoices',
                  route: AppRoutes.invoices,
                  isSelected: currentLocation == AppRoutes.invoices,
                ),
                _NavigationItem(
                  icon: Icons.analytics_outlined,
                  selectedIcon: Icons.analytics,
                  label: 'Reports',
                  route: AppRoutes.reports,
                  isSelected: currentLocation == AppRoutes.reports,
                ),
              ],
            ),
          ),
          
          // User profile section
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.borderColor),
              ),
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final authState = ref.watch(authProvider);
                
                return authState.when(
                  data: (user) => Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          user?.fullName.substring(0, 1).toUpperCase() ?? '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Unknown User',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user?.displayRole ?? 'User',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onSelected: (value) {
                          if (value == 'logout') {
                            ref.read(authProvider.notifier).logout();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(width: 8),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => const Icon(Icons.error),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final bool isSelected;
  
  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
    required this.isSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () => context.go(route),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      ),
    );
  }
}

class TopAppBar extends StatelessWidget {
  const TopAppBar({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getPageTitle(context),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Welcome back! Here\'s what\'s happening today.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Action buttons
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Notifications',
              ),
              const SizedBox(width: AppSizes.sm),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getPageTitle(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    switch (location) {
      case AppRoutes.dashboard:
        return 'Dashboard';
      case AppRoutes.customers:
        return 'Customers';
      case AppRoutes.vehicles:
        return 'Vehicles';
      case AppRoutes.serviceOrders:
        return 'Service Orders';
      case AppRoutes.parts:
        return 'Spare Parts';
      case AppRoutes.invoices:
        return 'Invoices';
      case AppRoutes.reports:
        return 'Reports';
      default:
        return 'Vehicle Service Center';
    }
  }
}