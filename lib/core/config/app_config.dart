/// Application configuration
class AppConfig {
  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com/v1',
  );
  
  static const String apiTimeout = '30';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Authentication Configuration
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  
  // OTP Configuration
  static const int otpLength = 6;
  static const int otpExpirySeconds = 300; // 5 minutes
  static const int otpResendSeconds = 60; // 1 minute
  
  // App Configuration
  static const String appName = 'D&D Sales App';
  static const String appVersion = '1.0.0';
  
  // Logging Configuration
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
  
  // Cache Configuration
  static const int cacheExpiryHours = 24;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
