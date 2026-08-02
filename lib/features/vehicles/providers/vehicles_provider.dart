import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/models/customer.dart';
import '../../../shared/models/vehicle.dart';

final vehiclesProvider =
    StateNotifierProvider<VehiclesNotifier, AsyncValue<PaginatedVehicles>>((ref) {
  return VehiclesNotifier(ref.watch(apiServiceProvider));
});

class PaginatedVehicles {
  final List<Vehicle> data;
  final PaginationMeta meta;

  PaginatedVehicles({required this.data, required this.meta});

  factory PaginatedVehicles.fromJson(Map<String, dynamic> json) {
    return PaginatedVehicles(
      data: (json['data'] as List<dynamic>)
          .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

class VehiclesNotifier extends StateNotifier<AsyncValue<PaginatedVehicles>> {
  final ApiService _apiService;

  VehiclesNotifier(this._apiService) : super(const AsyncLoading()) {
    loadVehicles();
  }

  Future<void> loadVehicles({String? search}) async {
    try {
      state = const AsyncLoading();

      final queryParams = <String, dynamic>{
        'page': 1,
        'limit': 20,
        'sortBy': 'createdAt',
        'order': 'DESC',
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiService.get('/vehicles', queryParameters: queryParams);
      state = AsyncData(PaginatedVehicles.fromJson(response.data as Map<String, dynamic>));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
