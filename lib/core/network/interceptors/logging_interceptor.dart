import 'package:dio/dio.dart';
import '../../logging/app_logger.dart';

/// Logging interceptor for API requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.logRequest(
      options.method,
      '${options.baseUrl}${options.path}',
      data: options.data,
    );
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.logResponse(
      response.statusCode ?? 0,
      response.requestOptions.uri.toString(),
      data: response.data,
    );
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'API Error: ${err.requestOptions.method} ${err.requestOptions.uri}',
      err.message,
    );
    super.onError(err, handler);
  }
}
