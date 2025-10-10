import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dandd_sales_app/main.dart' as app;

/// Main app smoke tests
/// These tests verify that the app can launch and basic functionality works
void main() {
  group('App Smoke Tests', () {
    testWidgets('App should launch without crashing', (WidgetTester tester) async {
      // Build the app
      app.main();
      await tester.pumpAndSettle();

      // Verify app launched successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have MaterialApp as root widget', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Check for MaterialApp
      final materialApp = find.byType(MaterialApp);
      expect(materialApp, findsOneWidget);
    });

    testWidgets('App should initialize without errors', (WidgetTester tester) async {
      // This test ensures app initialization completes
      app.main();
      await tester.pump();
      
      // Allow initialization to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // App should be rendered
      expect(tester.takeException(), isNull);
    });

    testWidgets('App should display initial route', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should display some UI (exact widget depends on auth state)
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('App should have consistent theme', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verify theme is set
      expect(materialApp.theme, isNotNull);
    });
  });

  group('App Configuration Tests', () {
    testWidgets('Debug banner should be disabled', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });

    testWidgets('App should have proper title', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, isNotEmpty);
    });
  });
}

/// To run these tests:
/// flutter test test/widget_test.dart
/// 
/// For more comprehensive tests, see:
/// - test/unit/ - Unit tests for models, repositories, services
/// - test/widget/ - Widget tests for UI components
/// - test/integration/ - Integration tests for workflows
/// - integration_test/ - End-to-end tests
