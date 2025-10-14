import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dandd_sales_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dandd_sales_app/features/auth/presentation/providers/auth_provider.dart';
import '../mocks/mock_dio_client.dart';
import '../mocks/mock_secure_storage.dart';
import '../helpers/test_helpers.dart';
import '../unit/repositories/auth_repository_test.dart';

void main() {
  group('Authentication Flow Integration Tests', () {
    late AuthRepositoryImpl repository;
    late MockDioClient mockDioClient;
    late MockSecureStorageService mockStorage;
    late AuthNotifier authNotifier;

    setUp(() {
      mockDioClient = MockDioClient();
      mockStorage = MockSecureStorageService();
      repository = AuthRepositoryImpl(
        dioClient: mockDioClient,
        storage: mockStorage,
      );
      authNotifier = AuthNotifier(repository);
    });

    test('Complete authentication flow - from OTP send to login', () async {
      // Step 1: Send OTP
      final phoneNumber = '1234567890';
      final otpResponse = TestHelpers.createTestOtpResponse();
      final mockOtpResponse = MockResponse(otpResponse.toJson());

      when(mockDioClient.post(
        '/auth/send-otp',
        data: {'phoneNumber': phoneNumber},
      )).thenAnswer((_) async => mockOtpResponse);

      final sendResult = await authNotifier.sendOtp(phoneNumber);

      expect(sendResult, isNotNull);
      expect(sendResult?.success, true);
      expect(sendResult?.requestId, isNotNull);

      // Step 2: Verify OTP
      final otp = '123456';
      final requestId = sendResult!.requestId!;
      final authResponse = TestHelpers.createTestAuthResponse();
      final mockAuthResponse = MockResponse(authResponse.toJson());

      when(mockDioClient.post(
        '/auth/verify-otp',
        data: {
          'phoneNumber': phoneNumber,
          'otp': otp,
          'requestId': requestId,
        },
      )).thenAnswer((_) async => mockAuthResponse);

      when(mockStorage.write(any, any)).thenAnswer((_) async => {});

      final verifyResult = await authNotifier.verifyOtp(phoneNumber, otp, requestId);

      expect(verifyResult, true);
      expect(authNotifier.state.isAuthenticated, true);
      expect(authNotifier.state.user, isNotNull);

      // Step 3: Verify tokens were stored
      verify(mockStorage.write('access_token', any)).called(1);
      verify(mockStorage.write('refresh_token', any)).called(1);
      verify(mockStorage.write('user', any)).called(1);

      // Step 4: Check if user is logged in
      when(mockStorage.read('access_token')).thenAnswer((_) async => 'test-token');
      final isLoggedIn = await repository.isLoggedIn();
      expect(isLoggedIn, true);
    });

    test('Authentication flow with failed OTP verification', () async {
      // Step 1: Send OTP successfully
      final phoneNumber = '1234567890';
      final otpResponse = TestHelpers.createTestOtpResponse();
      final mockOtpResponse = MockResponse(otpResponse.toJson());

      when(mockDioClient.post(
        '/auth/send-otp',
        data: {'phoneNumber': phoneNumber},
      )).thenAnswer((_) async => mockOtpResponse);

      final sendResult = await authNotifier.sendOtp(phoneNumber);
      expect(sendResult?.success, true);

      // Step 2: Verify OTP with invalid code
      when(mockDioClient.post(
        '/auth/verify-otp',
        data: anyNamed('data'),
      )).thenThrow(Exception('Invalid OTP'));

      final verifyResult = await authNotifier.verifyOtp(
        phoneNumber,
        'wrong-otp',
        sendResult!.requestId!,
      );

      expect(verifyResult, false);
      expect(authNotifier.state.isAuthenticated, false);
      expect(authNotifier.state.error, isNotNull);
    });

    test('Complete authentication and logout flow', () async {
      // Step 1: Login
      final phoneNumber = '1234567890';
      final authResponse = TestHelpers.createTestAuthResponse();
      final mockAuthResponse = MockResponse(authResponse.toJson());

      when(mockDioClient.post('/auth/verify-otp', data: anyNamed('data')))
          .thenAnswer((_) async => mockAuthResponse);
      when(mockStorage.write(any, any)).thenAnswer((_) async => {});

      await authNotifier.verifyOtp(phoneNumber, '123456', 'test-request-id');
      expect(authNotifier.state.isAuthenticated, true);

      // Step 2: Logout
      when(mockDioClient.post('/auth/logout'))
          .thenAnswer((_) async => MockResponse({'success': true}));
      when(mockStorage.delete(any)).thenAnswer((_) async => {});

      await authNotifier.logout();

      expect(authNotifier.state.isAuthenticated, false);
      expect(authNotifier.state.user, isNull);
      verify(mockStorage.delete('access_token')).called(1);
      verify(mockStorage.delete('refresh_token')).called(1);
      verify(mockStorage.delete('user')).called(1);
    });

    test('Token refresh flow', () async {
      // Step 1: Initial login
      final authResponse = TestHelpers.createTestAuthResponse(
        accessToken: 'old-access-token',
        refreshToken: 'old-refresh-token',
      );

      when(mockStorage.read('refresh_token'))
          .thenAnswer((_) async => 'old-refresh-token');

      // Step 2: Refresh token
      final newAuthResponse = TestHelpers.createTestAuthResponse(
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
      );
      final mockRefreshResponse = MockResponse(newAuthResponse.toJson());

      when(mockDioClient.post(
        '/auth/refresh',
        data: {'refreshToken': 'old-refresh-token'},
      )).thenAnswer((_) async => mockRefreshResponse);

      when(mockStorage.write(any, any)).thenAnswer((_) async => {});

      final result = await repository.refreshToken('old-refresh-token');

      expect(result.accessToken, 'new-access-token');
      expect(result.refreshToken, 'new-refresh-token');
      verify(mockStorage.write('access_token', 'new-access-token')).called(1);
      verify(mockStorage.write('refresh_token', 'new-refresh-token')).called(1);
    });

    test('Persistent session check on app restart', () async {
      // Simulate app restart with stored token
      when(mockStorage.read('access_token'))
          .thenAnswer((_) async => 'stored-token');
      when(mockStorage.read('user')).thenAnswer(
        (_) async => '{"id":"user-123","name":"Test User","email":"test@example.com"}',
      );

      // Check if user is logged in
      final isLoggedIn = await repository.isLoggedIn();
      expect(isLoggedIn, true);

      // Get current user
      final user = await repository.getCurrentUser();
      expect(user, isNotNull);
      expect(user?.id, 'user-123');
    });

    test('Handle expired session - no stored token', () async {
      // Simulate expired/cleared session
      when(mockStorage.read('access_token')).thenAnswer((_) async => null);

      final isLoggedIn = await repository.isLoggedIn();
      expect(isLoggedIn, false);

      final user = await repository.getCurrentUser();
      expect(user, isNull);
    });
  });

  group('Error Recovery Integration Tests', () {
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

    test('Should clear local data on logout even if API fails', () async {
      // API fails
      when(mockDioClient.post('/auth/logout'))
          .thenThrow(Exception('Network error'));
      when(mockStorage.delete(any)).thenAnswer((_) async => {});

      // Logout should still succeed locally
      await repository.logout();

      // Verify local data was cleared
      verify(mockStorage.delete('access_token')).called(1);
      verify(mockStorage.delete('refresh_token')).called(1);
      verify(mockStorage.delete('user')).called(1);
    });

    test('Should handle corrupted user data gracefully', () async {
      // Corrupted data in storage
      when(mockStorage.read('user')).thenAnswer((_) async => 'corrupted-json-data');

      final user = await repository.getCurrentUser();
      expect(user, isNull); // Should return null instead of crashing
    });
  });
}
