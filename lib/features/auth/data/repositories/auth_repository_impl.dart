import 'dart:convert';
import '../../../../core/config/app_config.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/models/auth_response.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation of authentication repository
class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final SecureStorageService _storage;
  
  AuthRepositoryImpl({
    required DioClient dioClient,
    required SecureStorageService storage,
  })  : _dioClient = dioClient,
        _storage = storage;
  
  @override
  Future<OtpResponse> sendOtp(String phoneNumber) async {
    try {
      AppLogger.logAuth('Sending OTP', details: {'phone': phoneNumber});
      
      final response = await _dioClient.post(
        '/auth/send-otp',
        data: {'phoneNumber': phoneNumber},
      );
      
      final otpResponse = OtpResponse.fromJson(response.data);
      AppLogger.logAuth('OTP sent successfully');
      return otpResponse;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to send OTP', e, stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<AuthResponse> verifyOtp(
    String phoneNumber,
    String otp,
    String requestId,
  ) async {
    try {
      AppLogger.logAuth('Verifying OTP', details: {'phone': phoneNumber});
      
      final response = await _dioClient.post(
        '/auth/verify-otp',
        data: {
          'phoneNumber': phoneNumber,
          'otp': otp,
          'requestId': requestId,
        },
      );
      
      final authResponse = AuthResponse.fromJson(response.data);
      
      // Save tokens and user data
      await _storage.write(AppConfig.tokenKey, authResponse.accessToken);
      await _storage.write(AppConfig.refreshTokenKey, authResponse.refreshToken);
      await _storage.write(AppConfig.userKey, jsonEncode(authResponse.user.toJson()));
      
      AppLogger.logAuth('OTP verified successfully', details: {'userId': authResponse.user.id});
      return authResponse;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to verify OTP', e, stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      AppLogger.logAuth('Refreshing token');
      
      final response = await _dioClient.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      
      final authResponse = AuthResponse.fromJson(response.data);
      
      // Update tokens
      await _storage.write(AppConfig.tokenKey, authResponse.accessToken);
      await _storage.write(AppConfig.refreshTokenKey, authResponse.refreshToken);
      
      AppLogger.logAuth('Token refreshed successfully');
      return authResponse;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to refresh token', e, stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      AppLogger.logAuth('Logging out');
      
      // Call logout API
      await _dioClient.post('/auth/logout');
      
      // Clear all stored data
      await _storage.delete(AppConfig.tokenKey);
      await _storage.delete(AppConfig.refreshTokenKey);
      await _storage.delete(AppConfig.userKey);
      
      AppLogger.logAuth('Logged out successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Logout error', e, stackTrace);
      // Even if API call fails, clear local data
      await _storage.delete(AppConfig.tokenKey);
      await _storage.delete(AppConfig.refreshTokenKey);
      await _storage.delete(AppConfig.userKey);
    }
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userJson = await _storage.read(AppConfig.userKey);
      if (userJson == null) return null;
      
      final userData = jsonDecode(userJson);
      return UserModel.fromJson(userData);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get current user', e, stackTrace);
      return null;
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(AppConfig.tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to check login status', e, stackTrace);
      return false;
    }
  }
}
