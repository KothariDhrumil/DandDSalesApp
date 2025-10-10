import '../models/auth_response.dart';
import '../models/user_model.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Send OTP to phone number
  Future<OtpResponse> sendOtp(String phoneNumber);
  
  /// Verify OTP and login
  Future<AuthResponse> verifyOtp(String phoneNumber, String otp, String requestId);
  
  /// Refresh access token
  Future<AuthResponse> refreshToken(String refreshToken);
  
  /// Logout
  Future<void> logout();
  
  /// Get current user
  Future<UserModel?> getCurrentUser();
  
  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
