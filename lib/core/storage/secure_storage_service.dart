import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../logging/app_logger.dart';

/// Secure storage service for sensitive data
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  late FlutterSecureStorage _storage;
  
  factory SecureStorageService() {
    return _instance;
  }
  
  SecureStorageService._internal() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }
  
  /// Write data to secure storage
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      AppLogger.debug('SecureStorage: Written key: $key');
    } catch (e, stackTrace) {
      AppLogger.error('SecureStorage: Failed to write key: $key', e, stackTrace);
      rethrow;
    }
  }
  
  /// Read data from secure storage
  Future<String?> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      AppLogger.debug('SecureStorage: Read key: $key, has value: ${value != null}');
      return value;
    } catch (e, stackTrace) {
      AppLogger.error('SecureStorage: Failed to read key: $key', e, stackTrace);
      return null;
    }
  }
  
  /// Delete data from secure storage
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      AppLogger.debug('SecureStorage: Deleted key: $key');
    } catch (e, stackTrace) {
      AppLogger.error('SecureStorage: Failed to delete key: $key', e, stackTrace);
      rethrow;
    }
  }
  
  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e, stackTrace) {
      AppLogger.error('SecureStorage: Failed to check key: $key', e, stackTrace);
      return false;
    }
  }
  
  /// Clear all data
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.info('SecureStorage: Cleared all data');
    } catch (e, stackTrace) {
      AppLogger.error('SecureStorage: Failed to clear all data', e, stackTrace);
      rethrow;
    }
  }
}
