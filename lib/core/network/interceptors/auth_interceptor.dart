import 'package:dio/dio.dart';
import '../../config/app_config.dart';
import '../../logging/app_logger.dart';
import '../../storage/secure_storage_service.dart';

/// Authentication interceptor for adding tokens to requests
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage = SecureStorageService();
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get access token from secure storage
    final token = await _storage.read(AppConfig.tokenKey);
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      AppLogger.debug('AuthInterceptor: Added token to request');
    }
    
    super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      AppLogger.warning('AuthInterceptor: 401 Unauthorized - Attempting token refresh');
      
      // Try to refresh token
      final refreshed = await _refreshToken();
      
      if (refreshed) {
        // Retry the original request
        try {
          final token = await _storage.read(AppConfig.tokenKey);
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          AppLogger.error('AuthInterceptor: Retry failed after token refresh', e);
        }
      } else {
        // Clear tokens and redirect to login
        await _storage.delete(AppConfig.tokenKey);
        await _storage.delete(AppConfig.refreshTokenKey);
        AppLogger.info('AuthInterceptor: Token refresh failed - Cleared tokens');
      }
    }
    
    super.onError(err, handler);
  }
  
  /// Refresh access token using refresh token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(AppConfig.refreshTokenKey);
      
      if (refreshToken == null) {
        AppLogger.warning('AuthInterceptor: No refresh token available');
        return false;
      }
      
      // Make refresh token API call
      final dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
      final response = await dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      
      if (response.statusCode == 200) {
        final newToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];
        
        await _storage.write(AppConfig.tokenKey, newToken);
        await _storage.write(AppConfig.refreshTokenKey, newRefreshToken);
        
        AppLogger.info('AuthInterceptor: Token refreshed successfully');
        return true;
      }
      
      return false;
    } catch (e, stackTrace) {
      AppLogger.error('AuthInterceptor: Token refresh failed', e, stackTrace);
      return false;
    }
  }
}
