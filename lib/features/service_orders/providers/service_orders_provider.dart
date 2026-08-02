import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../../../features/auth/providers/auth_provider.dart';

final serviceOrdersProvider =
    StateNotifierProvider<ServiceOrdersNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return ServiceOrdersNotifier(ref.watch(apiServiceProvider));
});

class ServiceOrdersNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final ApiService _apiService;

  ServiceOrdersNotifier(this._apiService) : super(const AsyncLoading()) {
    loadServiceOrders();
  }

  Future<void> loadServiceOrders() async {
    try {
      state = const AsyncLoading();

      final response = await _apiService.get('/service-orders', queryParameters: {
        'page': 1,
        'limit': 20,
        'sortBy': 'createdAt',
        'order': 'DESC',
      });

      final data = response.data as Map<String, dynamic>;
      state = AsyncData(List<Map<String, dynamic>>.from(data['data'] as List));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
