import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/models/customer.dart';

final customersProvider = StateNotifierProvider<CustomersNotifier, AsyncValue<PaginatedCustomers>>((ref) {
  return CustomersNotifier(ref.watch(apiServiceProvider));
});

class CustomersNotifier extends StateNotifier<AsyncValue<PaginatedCustomers>> {
  final ApiService _apiService;
  
  CustomersNotifier(this._apiService) : super(const AsyncLoading()) {
    loadCustomers();
  }
  
  Future<void> loadCustomers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      if (page == 1) {
        state = const AsyncLoading();
      }
      
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'sortBy': 'createdAt',
        'order': 'DESC',
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      
      final response = await _apiService.get('/customers', queryParameters: queryParams);
      final customers = PaginatedCustomers.fromJson(response.data);
      
      state = AsyncData(customers);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
  
  Future<void> createCustomer(Map<String, dynamic> customerData) async {
    try {
      await _apiService.post('/customers', data: customerData);
      // Reload the list after creation
      await loadCustomers();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> updateCustomer(String id, Map<String, dynamic> customerData) async {
    try {
      await _apiService.patch('/customers/$id', data: customerData);
      // Reload the list after update
      await loadCustomers();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> deleteCustomer(String id) async {
    try {
      await _apiService.delete('/customers/$id');
      // Reload the list after deletion
      await loadCustomers();
    } catch (e) {
      rethrow;
    }
  }
}