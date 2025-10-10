import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/models/auth_response.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    dioClient: DioClient(),
    storage: SecureStorageService(),
  );
});

/// Auth state
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  
  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });
  
  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  
  AuthNotifier(this._repository) : super(AuthState()) {
    _checkAuthStatus();
  }
  
  /// Check authentication status on init
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    final isLoggedIn = await _repository.isLoggedIn();
    if (isLoggedIn) {
      final user = await _repository.getCurrentUser();
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
  
  /// Send OTP
  Future<OtpResponse?> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _repository.sendOtp(phoneNumber);
      state = state.copyWith(isLoading: false);
      return response;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }
  
  /// Verify OTP and login
  Future<bool> verifyOtp(String phoneNumber, String otp, String requestId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _repository.verifyOtp(phoneNumber, otp, requestId);
      state = state.copyWith(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _repository.logout();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Refresh user data
  Future<void> refreshUser() async {
    final user = await _repository.getCurrentUser();
    if (user != null) {
      state = state.copyWith(user: user);
    }
  }
}

/// Auth state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
