# Testing Quick Reference - D&D Sales App

## Quick Commands ⚡

```bash
# Run all tests
flutter test

# Run specific test type
./run_tests.sh unit          # Unit tests only
./run_tests.sh widget        # Widget tests only
./run_tests.sh integration   # Integration tests only
./run_tests.sh e2e           # E2E tests only

# Run with coverage
./run_tests.sh coverage

# Run single file
flutter test test/unit/models/user_model_test.dart

# Run tests in watch mode
flutter test --watch
```

---

## Test File Locations 📁

```
Unit Tests:         test/unit/
Widget Tests:       test/widget/
Integration Tests:  test/integration/
E2E Tests:          integration_test/
Mocks:             test/mocks/
Helpers:           test/helpers/
```

---

## Writing a Unit Test 🧪

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyClass', () {
    test('should do something', () {
      // Arrange
      final myClass = MyClass();
      
      // Act
      final result = myClass.doSomething();
      
      // Assert
      expect(result, expectedValue);
    });
  });
}
```

---

## Writing a Widget Test 🎨

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should display widget', (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(MyWidget());
    
    // Assert
    expect(find.byType(MyWidget), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
  });
}
```

---

## Using Mocks 🎭

```dart
import 'package:mockito/mockito.dart';
import '../mocks/mock_repository.dart';

void main() {
  late MockRepository mockRepo;
  
  setUp(() {
    mockRepo = MockRepository();
  });
  
  test('should call repository', () {
    // Stub method
    when(mockRepo.getData()).thenAnswer((_) async => 'data');
    
    // Use mock
    final result = await mockRepo.getData();
    
    // Verify call
    verify(mockRepo.getData()).called(1);
    expect(result, 'data');
  });
}
```

---

## Test Helpers 🛠️

```dart
import '../helpers/test_helpers.dart';

// Create test data
final user = TestHelpers.createTestUser();
final authResponse = TestHelpers.createTestAuthResponse();
final otpResponse = TestHelpers.createTestOtpResponse();
```

---

## Common Matchers 🎯

```dart
// Equality
expect(actual, equals(expected));
expect(actual, expected);  // shorthand

// Type checking
expect(actual, isA<MyClass>());

// Null checks
expect(value, isNull);
expect(value, isNotNull);

// Numeric
expect(value, greaterThan(5));
expect(value, lessThan(10));
expect(value, isPositive);
expect(value, isNegative);

// Strings
expect(text, contains('substring'));
expect(text, startsWith('prefix'));
expect(text, endsWith('suffix'));
expect(text, isEmpty);
expect(text, isNotEmpty);

// Collections
expect(list, hasLength(3));
expect(list, isEmpty);
expect(list, contains(item));

// Boolean
expect(value, isTrue);
expect(value, isFalse);

// Exceptions
expect(() => throwError(), throwsException);
expect(() => throwError(), throwsA(isA<MyException>()));
```

---

## Widget Finders 🔍

```dart
// By type
find.byType(MyWidget)

// By text
find.text('Click Me')

// By key
find.byKey(Key('my-key'))

// By icon
find.byIcon(Icons.home)

// By widget
find.byWidget(myWidget)

// Descendants
find.descendant(
  of: find.byType(Parent),
  matching: find.byType(Child),
)

// Count expectations
findsOneWidget
findsNothing
findsWidgets
findsNWidgets(3)
findsAtLeastNWidgets(2)
```

---

## Widget Interactions 👆

```dart
// Tap
await tester.tap(find.byType(Button));
await tester.pumpAndSettle();

// Enter text
await tester.enterText(find.byType(TextField), 'Hello');

// Drag
await tester.drag(find.byType(ListView), Offset(0, -200));
await tester.pumpAndSettle();

// Long press
await tester.longPress(find.byType(Button));

// Dismiss keyboard
await tester.testTextInput.receiveAction(TextInputAction.done);
```

---

## Async Testing ⏱️

```dart
test('async test', () async {
  // Must use async
  final result = await asyncMethod();
  expect(result, expected);
});

testWidgets('async widget test', (tester) async {
  await tester.pumpWidget(MyWidget());
  
  // Wait for all async operations
  await tester.pumpAndSettle();
  
  // Or pump specific duration
  await tester.pump(Duration(seconds: 1));
});
```

---

## Coverage Commands 📊

```bash
# Generate coverage
flutter test --coverage

# View coverage report (macOS/Linux)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# View coverage report (Windows)
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html
```

---

## CI/CD Testing 🚀

Tests run automatically on:
- Every push to `main`, `master`, `develop`
- Every pull request
- Manual workflow dispatch

View results in GitHub Actions tab.

---

## Debugging Tests 🐛

```bash
# Run with verbose output
flutter test --reporter expanded

# Run single test with verbose
flutter test test/unit/models/user_model_test.dart --reporter expanded

# Print debug output
print('Debug: $value');  // Shows in test output

# Use debugger
debugger();  // Add breakpoint in test
```

---

## Test Organization 📋

```dart
void main() {
  // Group related tests
  group('Feature Name', () {
    // Setup before each test
    setUp(() {
      // Initialize
    });
    
    // Cleanup after each test
    tearDown(() {
      // Clean up
    });
    
    test('test 1', () {});
    test('test 2', () {});
    
    // Nested groups
    group('Sub-feature', () {
      test('test 3', () {});
    });
  });
}
```

---

## Best Practices ✨

### ✅ DO
- Use descriptive test names
- Follow Arrange-Act-Assert pattern
- Test one thing per test
- Mock external dependencies
- Use test helpers for common data
- Clean up resources in tearDown
- Test edge cases and errors

### ❌ DON'T
- Share state between tests
- Use real network/database
- Test implementation details
- Skip tests without reason
- Write tests that depend on order
- Use sleep() for timing
- Commit commented-out tests

---

## Useful Resources 📚

- **Full Guide**: [TESTING_GUIDE.md](TESTING_GUIDE.md)
- **Test Summary**: [TEST_SUMMARY.md](TEST_SUMMARY.md)
- **Flutter Docs**: https://docs.flutter.dev/testing
- **Mockito**: https://pub.dev/packages/mockito

---

## Common Issues & Solutions 🔧

### Test times out
```dart
// Increase timeout
test('long test', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

### Widget not found
```dart
// Wait for widget to appear
await tester.pumpAndSettle();
```

### Async test fails
```dart
// Make test async and await
test('test', () async {
  await asyncMethod();
});
```

### Mock not working
```dart
// Use thenAnswer for async methods
when(mock.method()).thenAnswer((_) async => result);
```

---

## Test Checklist ✓

Before committing:
- [ ] All tests pass locally
- [ ] New code has tests
- [ ] Edge cases covered
- [ ] No skipped tests
- [ ] Coverage maintained
- [ ] Tests are independent
- [ ] Descriptive test names

---

**Quick Tip**: Keep this file handy while writing tests!

**Version**: 1.0.0
