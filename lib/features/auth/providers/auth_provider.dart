import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../../../shared/models/user.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(() => AuthNotifier());

class AuthNotifier extends AsyncNotifier<User?> {
  late ApiService _apiService;

  @override
  Future<User?> build() async {
    _apiService = ref.read(apiServiceProvider);
    
    // Check if user is already logged in
    final isLoggedIn = await _apiService.isLoggedIn();
    if (isLoggedIn) {
      final userData = await _apiService.getUser();
      if (userData != null) {
        return User.fromJson(userData);
      }
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    
    try {
      final response = await _apiService.login(email, password);
      final user = User.fromJson(response['user']);
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    
    try {
      await _apiService.logout();
      state = const AsyncData(null);
    } catch (e) {
      // Even if logout fails, clear the local state
      state = const AsyncData(null);
    }
  }

  Future<void> refreshUser() async {
    final userData = await _apiService.getUser();
    if (userData != null) {
      state = AsyncData(User.fromJson(userData));
    } else {
      state = const AsyncData(null);
    }
  }
}