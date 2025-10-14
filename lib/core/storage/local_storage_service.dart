import 'package:shared_preferences/shared_preferences.dart';
import 'package:dandd_sales_app/core/logging/app_logger.dart';

/// Local storage service for non-sensitive data
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  late SharedPreferences _prefs;
  bool _initialized = false;
  
  factory LocalStorageService() {
    return _instance;
  }
  
  LocalStorageService._internal();
  
  /// Initialize the service
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      AppLogger.info('LocalStorage: Initialized');
    } catch (e, stackTrace) {
      AppLogger.error('LocalStorage: Failed to initialize', e, stackTrace);
      rethrow;
    }
  }
  
  /// Write string value
  Future<bool> setString(String key, String value) async {
    _ensureInitialized();
    try {
      final result = await _prefs.setString(key, value);
      AppLogger.debug('LocalStorage: Set string key: $key');
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('LocalStorage: Failed to set string key: $key', e, stackTrace);
      return false;
    }
  }
  
  /// Read string value
  String? getString(String key) {
    _ensureInitialized();
    try {
      final value = _prefs.getString(key);
      AppLogger.debug('LocalStorage: Get string key: $key, has value: ${value != null}');
      return value;
    } catch (e, stackTrace) {
      AppLogger.error('LocalStorage: Failed to get string key: $key', e, stackTrace);
      return null;
    }
  }
  
  /// Write int value
  Future<bool> setInt(String key, int value) async {
    _ensureInitialized();
    try {
      final result = await _prefs.setInt(key, value);
      AppLogger.debug('LocalStorage: Set int key: $key');
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('LocalStorage: Failed to set int key: $key', e, stackTrace);
      return false;
    }
  }
  
  /// Read int value
  int? getInt(String key) {
    _ensureInitialized();
    try {
      final value = _prefs.getInt(key);
      AppLogger.debug('LocalStorage: Get int key: $key, has value: ${value != null}');
      return value;
    } catch (e, stackTrace) {
      AppLogger.error('LocalStorage: Failed to get int key: $key', e, stackTrace);
      return null;
    }
  }
  
  /// Write bool value
  Future<bool> setBool(String key, bool value) async {
    _ensureInitialized();
    try {
      final result = await _prefs.setBool(key, value);
      AppLogger.debug('LocalStorage: Set bool key: $key');
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('LocalStorage: Failed to set bool key: $key', e, stackTrace);
      return false;
    }
  }
  
  /// Read bool value
  bool? getBool(String key) {
    _ensureInitialized();
    try {
      final value = _prefs.getBool(key);
      AppLogger.debug('LocalStorage: Get bool key: $key, has value: ${value != null}');
      return value;
    } catch (e, stackTrace) {
      AppLogger.error('LocalStorage: Failed to get bool key: $key', e, stackTrace);
      return null;
    }
  }
  
  /// Remove value
  Future<bool> remove(String key) async {
    _ensureInitialized();
    try {
      final result = await _prefs.remove(key);
      AppLogger.debug('LocalStorage: Removed key: $key');
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('LocalStorage: Failed to remove key: $key', e, stackTrace);
      return false;
    }
  }
  
  /// Clear all data
  Future<bool> clear() async {
    _ensureInitialized();
    try {
      final result = await _prefs.clear();
      AppLogger.info('LocalStorage: Cleared all data');
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('LocalStorage: Failed to clear all data', e, stackTrace);
      return false;
    }
  }
  
  void _ensureInitialized() {
    if (!_initialized) {
      throw Exception('LocalStorageService not initialized. Call init() first.');
    }
  }
}
