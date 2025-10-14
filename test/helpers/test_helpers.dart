import 'package:dandd_sales_app/features/auth/domain/models/auth_response.dart';
import 'package:dandd_sales_app/features/auth/domain/models/user_model.dart';

/// Test data helpers for consistent test data across tests

class TestHelpers {
  // Test User Models
  static UserModel createTestUser({
    String id = 'test-user-id',
    String name = 'Test User',
    String email = 'test@example.com',
    String? phone = '1234567890',
    String? role = 'Sales Manager',
    String? company = 'Test Company',
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: role,
      company: company,
      profileImage: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Test Auth Response
  static AuthResponse createTestAuthResponse({
    String? accessToken,
    String? refreshToken,
    UserModel? user,
    int expiresIn = 3600,
  }) {
    return AuthResponse(
      accessToken: accessToken ?? 'test-access-token',
      refreshToken: refreshToken ?? 'test-refresh-token',
      user: user ?? createTestUser(),
      expiresIn: expiresIn,
    );
  }

  // Test OTP Response
  static OtpResponse createTestOtpResponse({
    bool success = true,
    String message = 'OTP sent successfully',
    String? requestId = 'test-request-id',
    int expiresIn = 300,
  }) {
    return OtpResponse(
      success: success,
      message: message,
      requestId: requestId,
      expiresIn: expiresIn,
    );
  }
}
