# Testing Guide for D&D Sales App

## Overview

This guide covers all types of tests implemented in the D&D Sales App, following industry standards for mobile application testing.

## Table of Contents

- [Test Structure](#test-structure)
- [Running Tests](#running-tests)
- [Test Types](#test-types)
- [Writing Tests](#writing-tests)
- [Code Coverage](#code-coverage)
- [Best Practices](#best-practices)
- [Continuous Integration](#continuous-integration)

---

## Test Structure

```
DandDSalesApp/
├── test/                           # Unit and Widget Tests
│   ├── unit/                       # Unit tests
│   │   ├── models/                 # Model tests
│   │   ├── repositories/           # Repository tests
│   │   ├── services/               # Service tests
│   │   └── providers/              # Provider/State management tests
│   ├── widget/                     # Widget tests
│   │   ├── pages/                  # Page widget tests
│   │   └── common/                 # Common widget tests
│   ├── integration/                # Integration tests
│   ├── mocks/                      # Mock objects
│   └── helpers/                    # Test helpers and utilities
└── integration_test/               # End-to-end tests
    └── app_test.dart               # E2E test scenarios
```

---

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/models/user_model_test.dart
```

### Run Tests in a Directory
```bash
flutter test test/unit/
```

### Run Integration Tests
```bash
flutter test integration_test/app_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### View Coverage Report (macOS/Linux)
```bash
# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

### View Coverage Report (Windows)
```bash
# Install lcov tools
choco install lcov

# Generate and open report
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html
```

---

## Test Types

### 1. Unit Tests

Unit tests verify individual components in isolation.

**Location**: `test/unit/`

**What we test**:
- Models (serialization, deserialization, copyWith)
- Repositories (business logic, data operations)
- Services (storage, network)
- Providers (state management)

**Example**:
```dart
test('should create UserModel from valid JSON', () {
  final json = {'id': 'user-123', 'name': 'John', 'email': 'john@example.com'};
  final user = UserModel.fromJson(json);
  
  expect(user.id, 'user-123');
  expect(user.name, 'John');
});
```

**Run Unit Tests**:
```bash
flutter test test/unit/
```

---

### 2. Widget Tests

Widget tests verify UI components and their interactions.

**Location**: `test/widget/`

**What we test**:
- Widget rendering
- User interactions
- State changes
- Navigation
- Accessibility

**Example**:
```dart
testWidgets('should render login page', (WidgetTester tester) async {
  await tester.pumpWidget(createLoginPage());
  
  expect(find.byType(LoginPage), findsOneWidget);
  expect(find.byType(TextFormField), findsOneWidget);
});
```

**Run Widget Tests**:
```bash
flutter test test/widget/
```

---

### 3. Integration Tests

Integration tests verify how multiple components work together.

**Location**: `test/integration/`

**What we test**:
- Complete workflows
- Multi-step processes
- Component interactions
- Data flow

**Example**:
```dart
test('Complete authentication flow', () async {
  // Send OTP
  final otpResponse = await authNotifier.sendOtp('1234567890');
  expect(otpResponse?.success, true);
  
  // Verify OTP
  final success = await authNotifier.verifyOtp('1234567890', '123456', requestId);
  expect(success, true);
  expect(authNotifier.state.isAuthenticated, true);
});
```

**Run Integration Tests**:
```bash
flutter test test/integration/
```

---

### 4. End-to-End (E2E) Tests

E2E tests simulate real user scenarios from start to finish.

**Location**: `integration_test/`

**What we test**:
- Complete user journeys
- Real device/emulator interactions
- Performance
- Accessibility

**Example**:
```dart
testWidgets('Complete login flow', (WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();
  
  // Enter phone number
  await tester.enterText(find.byType(TextFormField).first, '1234567890');
  
  // Tap send OTP
  await tester.tap(find.text('Send OTP'));
  await tester.pumpAndSettle();
});
```

**Run E2E Tests**:
```bash
flutter test integration_test/app_test.dart
```

**Run E2E Tests on Device**:
```bash
# On Android
flutter test integration_test/app_test.dart -d android

# On iOS
flutter test integration_test/app_test.dart -d ios
```

---

## Writing Tests

### Test Structure

Follow the **Arrange-Act-Assert** pattern:

```dart
test('description of what is being tested', () {
  // Arrange - Set up test data and mocks
  final user = TestHelpers.createTestUser();
  when(mockRepository.getUser()).thenReturn(user);
  
  // Act - Execute the code being tested
  final result = await service.fetchUser();
  
  // Assert - Verify the results
  expect(result.id, user.id);
  verify(mockRepository.getUser()).called(1);
});
```

### Using Mocks

We use `mockito` for creating mock objects:

```dart
import 'package:mockito/mockito.dart';
import '../mocks/mock_auth_repository.dart';

// Create mock
final mockRepo = MockAuthRepository();

// Stub method
when(mockRepo.sendOtp('1234567890'))
  .thenAnswer((_) async => OtpResponse(success: true));

// Verify method was called
verify(mockRepo.sendOtp('1234567890')).called(1);
```

### Test Helpers

Use test helpers for consistent test data:

```dart
import '../helpers/test_helpers.dart';

final user = TestHelpers.createTestUser();
final authResponse = TestHelpers.createTestAuthResponse();
final otpResponse = TestHelpers.createTestOtpResponse();
```

### Widget Testing Tips

1. **Pump and Settle**: Wait for animations and async operations
```dart
await tester.pumpAndSettle();
```

2. **Find Widgets**: Use various finders
```dart
find.byType(LoginPage)
find.text('Login')
find.byKey(Key('submit-button'))
find.byIcon(Icons.login)
```

3. **Interact with Widgets**:
```dart
await tester.enterText(find.byType(TextField), 'text');
await tester.tap(find.byType(ElevatedButton));
await tester.drag(find.byType(ListView), Offset(0, -200));
```

---

## Code Coverage

### Generate Coverage Report

```bash
flutter test --coverage
```

This generates `coverage/lcov.info`.

### Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 70%+ coverage
- **Integration Tests**: Cover critical user flows
- **Overall**: 75%+ coverage

### Check Coverage

```bash
# Install lcov (macOS)
brew install lcov

# Install lcov (Ubuntu)
sudo apt-get install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# View report
open coverage/html/index.html
```

### Exclude Files from Coverage

Edit `.coveragerc` (if needed):
```
[run]
omit =
  **/*.g.dart
  **/*.freezed.dart
  **/main.dart
```

---

## Best Practices

### 1. Test Naming

Use descriptive names that explain what is being tested:

```dart
✅ test('should return user when credentials are valid', () {});
❌ test('test1', () {});
```

### 2. One Assertion Per Test

Keep tests focused:

```dart
✅ 
test('should set isLoading to true when sending OTP', () {
  expect(state.isLoading, true);
});

test('should clear error when sending OTP', () {
  expect(state.error, isNull);
});

❌
test('should handle sendOtp correctly', () {
  expect(state.isLoading, true);
  expect(state.error, isNull);
  expect(state.user, isNotNull);
});
```

### 3. Test Edge Cases

Don't just test the happy path:

```dart
test('should return null when user data is corrupted', () {});
test('should handle network timeout gracefully', () {});
test('should return false when token is empty string', () {});
```

### 4. Use setUp and tearDown

```dart
late MockRepository mockRepo;

setUp(() {
  mockRepo = MockRepository();
});

tearDown(() {
  // Clean up
});
```

### 5. Avoid Test Interdependence

Each test should be independent:

```dart
❌ // Bad - tests depend on each other
test('test1', () { globalState = 'value'; });
test('test2', () { expect(globalState, 'value'); });

✅ // Good - each test is independent
test('test1', () { 
  final state = 'value';
  expect(state, 'value');
});
```

### 6. Mock External Dependencies

Always mock:
- Network calls
- Database operations
- File system operations
- Platform-specific code

```dart
when(mockDioClient.post('/api/endpoint'))
  .thenAnswer((_) async => MockResponse(data));
```

---

## Test Categories

### Critical Tests (Must Have)

1. **Authentication Flow**
   - Login with valid credentials
   - Login with invalid credentials
   - Logout
   - Token refresh

2. **Data Persistence**
   - Saving data
   - Loading data
   - Clearing data

3. **Error Handling**
   - Network errors
   - Invalid data
   - Timeout scenarios

### Important Tests (Should Have)

1. **UI Interactions**
   - Button clicks
   - Form validation
   - Navigation

2. **State Management**
   - State updates
   - Provider interactions

### Nice to Have Tests

1. **Performance Tests**
   - Loading times
   - Memory usage

2. **Accessibility Tests**
   - Screen reader support
   - Keyboard navigation

---

## Continuous Integration

### GitHub Actions Integration

Tests run automatically on every push. See `.github/workflows/build-and-deploy.yml`:

```yaml
- name: Run tests
  run: flutter test
  
- name: Check code coverage
  run: |
    flutter test --coverage
    # Fail if coverage below threshold
```

### Local Pre-Commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
flutter test
if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi
```

---

## Common Issues and Solutions

### Issue: Tests timeout

**Solution**: Increase timeout or use `pumpAndSettle` with timeout:
```dart
await tester.pumpAndSettle(const Duration(seconds: 5));
```

### Issue: Widget not found

**Solution**: Ensure widget is rendered and use correct finder:
```dart
await tester.pumpAndSettle(); // Wait for widget to render
expect(find.byType(MyWidget), findsOneWidget);
```

### Issue: Async test fails

**Solution**: Make test async and await all futures:
```dart
test('async test', () async {
  await futureMethod();
  expect(result, expected);
});
```

### Issue: Mock not working

**Solution**: Ensure mock is properly configured:
```dart
when(mock.method(any)).thenAnswer((_) async => result);
// not .thenReturn() for async methods
```

---

## Testing Checklist

Before pushing code, ensure:

- [ ] All tests pass locally
- [ ] New features have tests
- [ ] Edge cases are covered
- [ ] Mocks are used for external dependencies
- [ ] Tests are independent
- [ ] Test names are descriptive
- [ ] Code coverage is maintained or improved
- [ ] No commented-out tests
- [ ] No `skip` flags on tests (unless documented)

---

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Test-Driven Development (TDD)](https://en.wikipedia.org/wiki/Test-driven_development)

---

## Support

For questions or issues with tests:
1. Check this guide
2. Review existing test examples
3. Check Flutter testing documentation
4. Open an issue in the repository

---

**Last Updated**: October 2025  
**Version**: 1.0.0
