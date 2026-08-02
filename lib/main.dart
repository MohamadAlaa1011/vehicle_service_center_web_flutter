import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: VehicleServiceCenterApp(),
    ),
  );
}

class VehicleServiceCenterApp extends ConsumerWidget {
  const VehicleServiceCenterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Vehicle Service Center',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}