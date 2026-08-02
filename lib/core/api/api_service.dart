import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class ApiService {
  late final Dio _dio;
  static const _storage = FlutterSecureStorage();
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.defaultHeaders,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // Request interceptor to add auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 errors by attempting token refresh
          if (error.response?.statusCode == 401) {
            final success = await _refreshToken();
            if (success) {
              // Retry the original request
              final token = await getAccessToken();
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } else {
              // Refresh failed, clear tokens and redirect to login
              await clearTokens();
            }
          }
          handler.next(error);
        },
      ),
    );
  }
  
  // Auth Methods
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      final data = response.data;
      await _saveTokens(data['accessToken'], data['refreshToken']);
      await _saveUser(data['user']);
      
      return data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;
      
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      
      final data = response.data;
      await _saveTokens(data['accessToken'], data['refreshToken']);
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> logout() async {
    await clearTokens();
  }
  
  // Generic HTTP Methods
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response> patch(String endpoint, {dynamic data}) async {
    try {
      return await _dio.patch(endpoint, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Token Management
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: ApiConstants.accessTokenKey, value: accessToken);
    await _storage.write(key: ApiConstants.refreshTokenKey, value: refreshToken);
  }
  
  Future<void> _saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: ApiConstants.userKey, value: jsonEncode(user));
  }
  
  Future<String?> getAccessToken() async {
    return await _storage.read(key: ApiConstants.accessTokenKey);
  }
  
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: ApiConstants.refreshTokenKey);
  }
  
  Future<Map<String, dynamic>?> getUser() async {
    final userJson = await _storage.read(key: ApiConstants.userKey);
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }
  
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }
  
  Future<void> clearTokens() async {
    await _storage.delete(key: ApiConstants.accessTokenKey);
    await _storage.delete(key: ApiConstants.refreshTokenKey);
    await _storage.delete(key: ApiConstants.userKey);
  }
  
  // Error Handling
  ApiException _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final rawMessage = e.response?.data?['message'];
        final message = rawMessage is List
            ? rawMessage.join(', ')
            : rawMessage?.toString() ?? 'An error occurred';
        
        switch (statusCode) {
          case 400:
            return ApiException('Bad request: $message');
          case 401:
            return ApiException('Unauthorized. Please login again.');
          case 403:
            return ApiException('Access denied. You don\'t have permission.');
          case 404:
            return ApiException('Resource not found.');
          case 500:
            return ApiException('Server error. Please try again later.');
          default:
            return ApiException('Error $statusCode: $message');
        }
      
      case DioExceptionType.cancel:
        return ApiException('Request cancelled');
      
      case DioExceptionType.connectionError:
        return ApiException(
          'Cannot reach the API server. If using Bonto, the app may be waking up — try again in a few seconds.',
        );
      
      default:
        return ApiException('Unexpected error occurred');
    }
  }
}

class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => message;
}