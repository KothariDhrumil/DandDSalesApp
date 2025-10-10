import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:dandd_sales_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dandd_sales_app/features/auth/domain/models/auth_response.dart';
import 'package:dandd_sales_app/features/auth/domain/models/user_model.dart';
import 'package:dandd_sales_app/core/config/app_config.dart';
import '../../mocks/mock_dio_client.dart';
import '../../mocks/mock_secure_storage.dart';
import '../../helpers/test_helpers.dart';

class MockResponse extends Mock implements Response {
  @override
  final dynamic data;
  
  MockResponse(this.data);
}

void main() {
  late AuthRepositoryImpl repository;
  late MockDioClient mockDioClient;
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockDioClient = MockDioClient();
    mockStorage = MockSecureStorageService();
    repository = AuthRepositoryImpl(
      dioClient: mockDioClient,
      storage: mockStorage,
    );
  });

  group('AuthRepository - sendOtp', () {
    test('should successfully send OTP and return OtpResponse', () async {
      // Arrange
      final phoneNumber = '1234567890';
      final otpResponse = TestHelpers.createTestOtpResponse();
      final mockResponse = MockResponse(otpResponse.toJson());

      when(mockDioClient.post(
        '/auth/send-otp',
        data: {'phoneNumber': phoneNumber},
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.sendOtp(phoneNumber);

      // Assert
      expect(result.success, true);
      expect(result.message, 'OTP sent successfully');
      expect(result.requestId, 'test-request-id');
      verify(mockDioClient.post(
        '/auth/send-otp',
        data: {'phoneNumber': phoneNumber},
      )).called(1);
    });

    test('should throw exception when sendOtp fails', () async {
      // Arrange
      final phoneNumber = '1234567890';
      when(mockDioClient.post(
        '/auth/send-otp',
        data: {'phoneNumber': phoneNumber},
      )).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => repository.sendOtp(phoneNumber),
        throwsException,
      );
    });
  });

  group('AuthRepository - verifyOtp', () {
    test('should successfully verify OTP and store tokens', () async {
      // Arrange
      final phoneNumber = '1234567890';
      final otp = '123456';
      final requestId = 'test-request-id';
      final authResponse = TestHelpers.createTestAuthResponse();
      final mockResponse = MockResponse(authResponse.toJson());

      when(mockDioClient.post(
        '/auth/verify-otp',
        data: {
          'phoneNumber': phoneNumber,
          'otp': otp,
          'requestId': requestId,
        },
      )).thenAnswer((_) async => mockResponse);

      when(mockStorage.write(any, any)).thenAnswer((_) async => {});

      // Act
      final result = await repository.verifyOtp(phoneNumber, otp, requestId);

      // Assert
      expect(result.accessToken, 'test-access-token');
      expect(result.refreshToken, 'test-refresh-token');
      expect(result.user, isA<UserModel>());
      
      verify(mockStorage.write(AppConfig.tokenKey, 'test-access-token')).called(1);
      verify(mockStorage.write(AppConfig.refreshTokenKey, 'test-refresh-token')).called(1);
      verify(mockStorage.write(AppConfig.userKey, any)).called(1);
    });

    test('should throw exception when verifyOtp fails', () async {
      // Arrange
      final phoneNumber = '1234567890';
      final otp = '123456';
      final requestId = 'test-request-id';

      when(mockDioClient.post(
        '/auth/verify-otp',
        data: anyNamed('data'),
      )).thenThrow(Exception('Invalid OTP'));

      // Act & Assert
      expect(
        () => repository.verifyOtp(phoneNumber, otp, requestId),
        throwsException,
      );
    });
  });

  group('AuthRepository - refreshToken', () {
    test('should successfully refresh token and update storage', () async {
      // Arrange
      final refreshToken = 'old-refresh-token';
      final authResponse = TestHelpers.createTestAuthResponse(
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
      );
      final mockResponse = MockResponse(authResponse.toJson());

      when(mockDioClient.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      )).thenAnswer((_) async => mockResponse);

      when(mockStorage.write(any, any)).thenAnswer((_) async => {});

      // Act
      final result = await repository.refreshToken(refreshToken);

      // Assert
      expect(result.accessToken, 'new-access-token');
      expect(result.refreshToken, 'new-refresh-token');
      verify(mockStorage.write(AppConfig.tokenKey, 'new-access-token')).called(1);
      verify(mockStorage.write(AppConfig.refreshTokenKey, 'new-refresh-token')).called(1);
    });
  });

  group('AuthRepository - logout', () {
    test('should successfully logout and clear storage', () async {
      // Arrange
      when(mockDioClient.post('/auth/logout')).thenAnswer(
        (_) async => MockResponse({'success': true}),
      );
      when(mockStorage.delete(any)).thenAnswer((_) async => {});

      // Act
      await repository.logout();

      // Assert
      verify(mockStorage.delete(AppConfig.tokenKey)).called(1);
      verify(mockStorage.delete(AppConfig.refreshTokenKey)).called(1);
      verify(mockStorage.delete(AppConfig.userKey)).called(1);
    });

    test('should clear storage even when API call fails', () async {
      // Arrange
      when(mockDioClient.post('/auth/logout')).thenThrow(Exception('API error'));
      when(mockStorage.delete(any)).thenAnswer((_) async => {});

      // Act
      await repository.logout();

      // Assert
      verify(mockStorage.delete(AppConfig.tokenKey)).called(1);
      verify(mockStorage.delete(AppConfig.refreshTokenKey)).called(1);
      verify(mockStorage.delete(AppConfig.userKey)).called(1);
    });
  });

  group('AuthRepository - getCurrentUser', () {
    test('should return user when data exists in storage', () async {
      // Arrange
      final user = TestHelpers.createTestUser();
      final userJson = '{"id":"test-user-id","name":"Test User","email":"test@example.com"}';
      
      when(mockStorage.read(AppConfig.userKey)).thenAnswer((_) async => userJson);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isNotNull);
      expect(result?.id, 'test-user-id');
      expect(result?.name, 'Test User');
      expect(result?.email, 'test@example.com');
    });

    test('should return null when no user data in storage', () async {
      // Arrange
      when(mockStorage.read(AppConfig.userKey)).thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isNull);
    });

    test('should return null when user data is invalid', () async {
      // Arrange
      when(mockStorage.read(AppConfig.userKey)).thenAnswer((_) async => 'invalid-json');

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isNull);
    });
  });

  group('AuthRepository - isLoggedIn', () {
    test('should return true when token exists', () async {
      // Arrange
      when(mockStorage.read(AppConfig.tokenKey)).thenAnswer(
        (_) async => 'valid-token',
      );

      // Act
      final result = await repository.isLoggedIn();

      // Assert
      expect(result, true);
    });

    test('should return false when token is null', () async {
      // Arrange
      when(mockStorage.read(AppConfig.tokenKey)).thenAnswer((_) async => null);

      // Act
      final result = await repository.isLoggedIn();

      // Assert
      expect(result, false);
    });

    test('should return false when token is empty', () async {
      // Arrange
      when(mockStorage.read(AppConfig.tokenKey)).thenAnswer((_) async => '');

      // Act
      final result = await repository.isLoggedIn();

      // Assert
      expect(result, false);
    });

    test('should return false on storage error', () async {
      // Arrange
      when(mockStorage.read(AppConfig.tokenKey)).thenThrow(Exception('Storage error'));

      // Act
      final result = await repository.isLoggedIn();

      // Assert
      expect(result, false);
    });
  });
}
