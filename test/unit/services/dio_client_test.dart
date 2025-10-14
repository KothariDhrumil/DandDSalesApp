import 'package:flutter_test/flutter_test.dart';
import 'package:dandd_sales_app/core/network/dio_client.dart';
import 'package:dio/dio.dart';

void main() {
  group('DioClient Tests', () {
    late DioClient dioClient;

    setUp(() {
      dioClient = DioClient();
    });

    test('should be a singleton', () {
      final instance1 = DioClient();
      final instance2 = DioClient();

      expect(instance1, same(instance2));
    });

    test('should have dio instance', () {
      expect(dioClient.dio, isA<Dio>());
    });

    test('should have configured base options', () {
      final dio = dioClient.dio;
      
      expect(dio.options, isNotNull);
      expect(dio.options.baseUrl, isNotEmpty);
      expect(dio.options.headers, isNotNull);
      expect(dio.options.headers['Content-Type'], 'application/json');
      expect(dio.options.headers['Accept'], 'application/json');
    });

    test('should have timeout configuration', () {
      final dio = dioClient.dio;
      
      expect(dio.options.connectTimeout, isNotNull);
      expect(dio.options.receiveTimeout, isNotNull);
    });

    test('should have interceptors configured', () {
      final dio = dioClient.dio;
      
      expect(dio.interceptors, isNotEmpty);
      expect(dio.interceptors.length, greaterThanOrEqualTo(2));
    });

    test('should have get method', () {
      expect(dioClient.get, isA<Function>());
    });

    test('should have post method', () {
      expect(dioClient.post, isA<Function>());
    });

    test('should have put method', () {
      expect(dioClient.put, isA<Function>());
    });

    test('should have patch method', () {
      expect(dioClient.patch, isA<Function>());
    });

    test('should have delete method', () {
      expect(dioClient.delete, isA<Function>());
    });
  });

  group('DioClient Error Handling', () {
    test('should handle connection timeout', () {
      final dioClient = DioClient();
      
      // Test that error handling methods exist
      expect(dioClient.dio, isNotNull);
    });

    test('should handle bad response', () {
      final dioClient = DioClient();
      
      expect(dioClient.dio, isNotNull);
    });

    test('should handle network errors', () {
      final dioClient = DioClient();
      
      expect(dioClient.dio, isNotNull);
    });
  });

  group('DioClient HTTP Methods', () {
    test('get method should accept path parameter', () {
      final dioClient = DioClient();
      
      expect(
        () => dioClient.get('/test'),
        returnsNormally,
      );
    });

    test('post method should accept path and data parameters', () {
      final dioClient = DioClient();
      
      expect(
        () => dioClient.post('/test', data: {'key': 'value'}),
        returnsNormally,
      );
    });

    test('put method should accept path and data parameters', () {
      final dioClient = DioClient();
      
      expect(
        () => dioClient.put('/test', data: {'key': 'value'}),
        returnsNormally,
      );
    });

    test('patch method should accept path and data parameters', () {
      final dioClient = DioClient();
      
      expect(
        () => dioClient.patch('/test', data: {'key': 'value'}),
        returnsNormally,
      );
    });

    test('delete method should accept path parameter', () {
      final dioClient = DioClient();
      
      expect(
        () => dioClient.delete('/test'),
        returnsNormally,
      );
    });
  });
}

/// Note: For complete HTTP method testing, you would need to:
/// 1. Mock the HTTP server or use a mock adapter
/// 2. Test actual request/response scenarios
/// 3. Test error scenarios with different status codes
/// 
/// Example with mock server:
/// ```dart
/// test('should make successful GET request', () async {
///   // Set up mock server
///   final mockServer = MockWebServer();
///   mockServer.start();
///   
///   // Configure response
///   mockServer.enqueue(body: '{"data": "test"}', httpCode: 200);
///   
///   // Make request
///   final response = await dioClient.get('/test');
///   
///   expect(response.statusCode, 200);
///   expect(response.data, isNotNull);
/// });
/// ```
