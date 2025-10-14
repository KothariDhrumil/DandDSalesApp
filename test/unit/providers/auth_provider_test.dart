import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dandd_sales_app/features/auth/presentation/providers/auth_provider.dart';
import '../../mocks/mock_auth_repository.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late AuthNotifier authNotifier;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    authNotifier = AuthNotifier(mockRepository);
  });

  group('AuthNotifier - Initial State', () {
    test('should have correct initial state', () {
      // Assert
      expect(authNotifier.state.user, isNull);
      expect(authNotifier.state.isAuthenticated, false);
      expect(authNotifier.state.error, isNull);
    });
  });

  group('AuthNotifier - sendOtp', () {
    test('should successfully send OTP and update state', () async {
      // Arrange
      final phoneNumber = '1234567890';
      final otpResponse = TestHelpers.createTestOtpResponse();
      
      when(mockRepository.sendOtp(phoneNumber))
          .thenAnswer((_) async => otpResponse);

      // Act
      final result = await authNotifier.sendOtp(phoneNumber);

      // Assert
      expect(result, isNotNull);
      expect(result?.success, true);
      expect(result?.requestId, 'test-request-id');
      expect(authNotifier.state.isLoading, false);
      expect(authNotifier.state.error, isNull);
      verify(mockRepository.sendOtp(phoneNumber)).called(1);
    });

    test('should handle error when sending OTP fails', () async {
      // Arrange
      final phoneNumber = '1234567890';
      
      when(mockRepository.sendOtp(phoneNumber))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await authNotifier.sendOtp(phoneNumber);

      // Assert
      expect(result, isNull);
      expect(authNotifier.state.isLoading, false);
      expect(authNotifier.state.error, isNotNull);
      expect(authNotifier.state.error, contains('Exception'));
    });
  });

  group('AuthNotifier - verifyOtp', () {
    test('should successfully verify OTP and update auth state', () async {
      // Arrange
      final phoneNumber = '1234567890';
      final otp = '123456';
      final requestId = 'test-request-id';
      final authResponse = TestHelpers.createTestAuthResponse();
      
      when(mockRepository.verifyOtp(phoneNumber, otp, requestId))
          .thenAnswer((_) async => authResponse);

      // Act
      final result = await authNotifier.verifyOtp(phoneNumber, otp, requestId);

      // Assert
      expect(result, true);
      expect(authNotifier.state.isAuthenticated, true);
      expect(authNotifier.state.user, isNotNull);
      expect(authNotifier.state.user?.id, 'test-user-id');
      expect(authNotifier.state.isLoading, false);
      expect(authNotifier.state.error, isNull);
      verify(mockRepository.verifyOtp(phoneNumber, otp, requestId)).called(1);
    });

    test('should handle error when OTP verification fails', () async {
      // Arrange
      final phoneNumber = '1234567890';
      final otp = '123456';
      final requestId = 'test-request-id';
      
      when(mockRepository.verifyOtp(phoneNumber, otp, requestId))
          .thenThrow(Exception('Invalid OTP'));

      // Act
      final result = await authNotifier.verifyOtp(phoneNumber, otp, requestId);

      // Assert
      expect(result, false);
      expect(authNotifier.state.isAuthenticated, false);
      expect(authNotifier.state.user, isNull);
      expect(authNotifier.state.isLoading, false);
      expect(authNotifier.state.error, isNotNull);
    });
  });

  group('AuthNotifier - logout', () {
    test('should successfully logout and reset state', () async {
      // Arrange
      when(mockRepository.logout()).thenAnswer((_) async => {});

      // First authenticate
      final authResponse = TestHelpers.createTestAuthResponse();
      when(mockRepository.verifyOtp(any, any, any))
          .thenAnswer((_) async => authResponse);
      await authNotifier.verifyOtp('1234567890', '123456', 'test-id');

      // Act
      await authNotifier.logout();

      // Assert
      expect(authNotifier.state.user, isNull);
      expect(authNotifier.state.isAuthenticated, false);
      expect(authNotifier.state.isLoading, false);
      verify(mockRepository.logout()).called(1);
    });

    test('should handle error during logout', () async {
      // Arrange
      when(mockRepository.logout()).thenThrow(Exception('Logout error'));

      // Act
      await authNotifier.logout();

      // Assert
      expect(authNotifier.state.error, isNotNull);
      expect(authNotifier.state.isLoading, false);
    });
  });

  group('AuthNotifier - refreshUser', () {
    test('should successfully refresh user data', () async {
      // Arrange
      final user = TestHelpers.createTestUser(name: 'Updated User');
      when(mockRepository.getCurrentUser()).thenAnswer((_) async => user);

      // Act
      await authNotifier.refreshUser();

      // Assert
      expect(authNotifier.state.user, isNotNull);
      expect(authNotifier.state.user?.name, 'Updated User');
      verify(mockRepository.getCurrentUser()).called(1);
    });

    test('should handle null user when refreshing', () async {
      // Arrange
      when(mockRepository.getCurrentUser()).thenAnswer((_) async => null);

      // Act
      await authNotifier.refreshUser();

      // Assert
      // State should remain unchanged
      verify(mockRepository.getCurrentUser()).called(1);
    });
  });

  group('AuthState', () {
    test('should create AuthState with default values', () {
      // Act
      final state = AuthState();

      // Assert
      expect(state.user, isNull);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.isAuthenticated, false);
    });

    test('should create copy with updated values', () {
      // Arrange
      final user = TestHelpers.createTestUser();
      final initialState = AuthState();

      // Act
      final newState = initialState.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: true,
      );

      // Assert
      expect(newState.user, user);
      expect(newState.isAuthenticated, true);
      expect(newState.isLoading, true);
      expect(newState.error, isNull);
    });

    test('copyWith should preserve unchanged values', () {
      // Arrange
      final user = TestHelpers.createTestUser();
      final initialState = AuthState(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        error: 'Some error',
      );

      // Act
      final newState = initialState.copyWith(isLoading: true);

      // Assert
      expect(newState.user, user);
      expect(newState.isAuthenticated, true);
      expect(newState.isLoading, true);
      expect(newState.error, isNull); // error is reset when not provided
    });
  });
}
