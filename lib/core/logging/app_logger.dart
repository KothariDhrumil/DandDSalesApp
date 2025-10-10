import 'package:logger/logger.dart';
import '../config/app_config.dart';

/// Centralized logging utility for the application
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  late Logger _logger;
  
  factory AppLogger() {
    return _instance;
  }
  
  AppLogger._internal() {
    _logger = Logger(
      filter: AppConfig.enableLogging ? ProductionFilter() : ProductionFilter(),
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      output: null,
    );
  }
  
  /// Log debug message
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.d(message, error: error, stackTrace: stackTrace);
  }
  
  /// Log info message
  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.i(message, error: error, stackTrace: stackTrace);
  }
  
  /// Log warning message
  static void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.w(message, error: error, stackTrace: stackTrace);
  }
  
  /// Log error message
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.e(message, error: error, stackTrace: stackTrace);
  }
  
  /// Log fatal message
  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.f(message, error: error, stackTrace: stackTrace);
  }
  
  /// Log API request
  static void logRequest(String method, String url, {Map<String, dynamic>? data}) {
    info('API Request: $method $url', data);
  }
  
  /// Log API response
  static void logResponse(int statusCode, String url, {dynamic data}) {
    info('API Response: $statusCode $url', data);
  }
  
  /// Log authentication event
  static void logAuth(String event, {dynamic details}) {
    info('Auth Event: $event', details);
  }
  
  /// Log navigation event
  static void logNavigation(String from, String to) {
    debug('Navigation: $from -> $to');
  }
}
