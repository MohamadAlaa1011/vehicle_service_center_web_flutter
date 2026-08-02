class ApiConstants {
  // Base URLs
  static const String localBaseUrl = 'http://localhost:3000/api/v1';
  static const String bontoBaseUrl = 'https://vsc-api.bonto.run/api/v1';

  // Production API on Bonto
  static const String baseUrl = bontoBaseUrl;

  // API Endpoints
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String refreshToken = '$auth/refresh';
  static const String profile = '$auth/profile';

  static const String customers = '/customers';
  static const String vehicles = '/vehicles';
  static const String serviceOrders = '/service-orders';
  static const String spareParts = '/spare-parts';
  static const String invoices = '/invoices';
  static const String payments = '/payments';
  static const String dashboard = '/dashboard';
  static const String dashboardStats = '$dashboard/stats';
  static const String dashboardAlerts = '$dashboard/alerts';
  static const String dashboardRecentOrders = '$dashboard/recent-orders';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
