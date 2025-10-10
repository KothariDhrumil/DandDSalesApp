import 'package:flutter_test/flutter_test.dart';
import 'package:dandd_sales_app/features/auth/domain/models/auth_response.dart';
import 'package:dandd_sales_app/features/auth/domain/models/user_model.dart';

void main() {
  group('AuthResponse', () {
    test('should create AuthResponse from valid JSON', () {
      // Arrange
      final json = {
        'accessToken': 'test-access-token',
        'refreshToken': 'test-refresh-token',
        'expiresIn': 3600,
        'user': {
          'id': 'user-123',
          'name': 'John Doe',
          'email': 'john@example.com',
        },
      };

      // Act
      final authResponse = AuthResponse.fromJson(json);

      // Assert
      expect(authResponse.accessToken, 'test-access-token');
      expect(authResponse.refreshToken, 'test-refresh-token');
      expect(authResponse.expiresIn, 3600);
      expect(authResponse.user, isA<UserModel>());
      expect(authResponse.user.id, 'user-123');
      expect(authResponse.user.name, 'John Doe');
      expect(authResponse.user.email, 'john@example.com');
    });

    test('should convert AuthResponse to JSON', () {
      // Arrange
      final user = UserModel(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );
      final authResponse = AuthResponse(
        accessToken: 'test-access-token',
        refreshToken: 'test-refresh-token',
        user: user,
        expiresIn: 3600,
      );

      // Act
      final json = authResponse.toJson();

      // Assert
      expect(json['accessToken'], 'test-access-token');
      expect(json['refreshToken'], 'test-refresh-token');
      expect(json['expiresIn'], 3600);
      expect(json['user'], isA<Map<String, dynamic>>());
      expect(json['user']['id'], 'user-123');
    });
  });

  group('OtpResponse', () {
    test('should create OtpResponse from valid JSON with all fields', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'OTP sent successfully',
        'requestId': 'request-123',
        'expiresIn': 300,
      };

      // Act
      final otpResponse = OtpResponse.fromJson(json);

      // Assert
      expect(otpResponse.success, true);
      expect(otpResponse.message, 'OTP sent successfully');
      expect(otpResponse.requestId, 'request-123');
      expect(otpResponse.expiresIn, 300);
    });

    test('should create OtpResponse with required fields only', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'OTP sent successfully',
      };

      // Act
      final otpResponse = OtpResponse.fromJson(json);

      // Assert
      expect(otpResponse.success, true);
      expect(otpResponse.message, 'OTP sent successfully');
      expect(otpResponse.requestId, isNull);
      expect(otpResponse.expiresIn, isNull);
    });

    test('should create OtpResponse for failure case', () {
      // Arrange
      final json = {
        'success': false,
        'message': 'Failed to send OTP',
      };

      // Act
      final otpResponse = OtpResponse.fromJson(json);

      // Assert
      expect(otpResponse.success, false);
      expect(otpResponse.message, 'Failed to send OTP');
    });

    test('should convert OtpResponse to JSON', () {
      // Arrange
      final otpResponse = OtpResponse(
        success: true,
        message: 'OTP sent successfully',
        requestId: 'request-123',
        expiresIn: 300,
      );

      // Act
      final json = otpResponse.toJson();

      // Assert
      expect(json['success'], true);
      expect(json['message'], 'OTP sent successfully');
      expect(json['requestId'], 'request-123');
      expect(json['expiresIn'], 300);
    });
  });
}
