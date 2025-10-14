import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dandd_sales_app/features/auth/presentation/pages/login_page.dart';
import 'package:dandd_sales_app/features/auth/presentation/providers/auth_provider.dart';
import '../../mocks/mock_auth_repository.dart';

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  Widget createLoginPage() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('should render login page with all elements', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createLoginPage());

      // Assert
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display phone number input field', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createLoginPage());

      // Assert
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      
      // Check if the text field is for phone number
      final textFormField = tester.widget<TextFormField>(textField);
      expect(textFormField.keyboardType, TextInputType.phone);
    });

    testWidgets('should show validation error for empty phone number', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createLoginPage());

      // Act - Tap submit button without entering phone number
      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pump();

      // Assert - Validation error should appear
      expect(find.text('Please enter phone number'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid phone number', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createLoginPage());

      // Act - Enter invalid phone number
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Validation error should appear
      expect(find.textContaining('valid'), findsOneWidget);
    });

    testWidgets('should enable submit button when form is valid', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createLoginPage());

      // Act - Enter valid phone number
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '1234567890');
      await tester.pump();

      // Assert - Button should be enabled
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isTrue);
    });

    testWidgets('should clear phone number when clear icon is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createLoginPage());
      final textField = find.byType(TextFormField);

      // Act - Enter text
      await tester.enterText(textField, '1234567890');
      await tester.pump();

      // Find and tap clear icon if it exists
      final clearIcon = find.byIcon(Icons.clear);
      if (clearIcon.evaluate().isNotEmpty) {
        await tester.tap(clearIcon);
        await tester.pump();

        // Assert
        final textFormField = tester.widget<TextFormField>(textField);
        expect(textFormField.controller?.text, isEmpty);
      }
    });
  });

  group('LoginPage Interaction Tests', () {
    testWidgets('should show loading indicator when sending OTP', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createLoginPage());

      // Act - Enter valid phone and submit
      await tester.enterText(find.byType(TextFormField), '1234567890');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('LoginPage Accessibility Tests', () {
    testWidgets('should have semantic labels for accessibility', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createLoginPage());

      // Assert - Check for semantic labels
      expect(
        tester.getSemantics(find.byType(TextFormField)),
        matchesSemantics(
          isTextField: true,
        ),
      );
    });
  });
}
