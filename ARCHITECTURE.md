# Architecture Guide for .NET Developers

## Overview

This Flutter application follows **Clean Architecture** principles, similar to the architecture patterns you're familiar with in .NET (like Onion Architecture or Hexagonal Architecture).

## Architecture Layers

### 1. Presentation Layer (UI)
**Flutter equivalent to**: ASP.NET MVC Controllers/Views or Razor Pages

Located in: `lib/features/*/presentation/`

- **Pages**: Similar to Views/Pages in .NET - the visual screens
- **Widgets**: Reusable UI components (like Partial Views or View Components)
- **Providers**: Similar to ViewModels or Controllers - manages state and business logic for UI

```dart
// Example: AuthProvider is like a ViewModel in .NET
class AuthNotifier extends StateNotifier<AuthState> {
  // Business logic for UI
  Future<void> login() { ... }
}
```

### 2. Domain Layer (Business Logic)
**Flutter equivalent to**: Domain/Core layer in .NET

Located in: `lib/features/*/domain/`

- **Models**: POCOs/DTOs in .NET - data transfer objects
- **Repositories (Interfaces)**: Like IRepository interfaces in .NET
- **UseCases**: Business logic encapsulation (optional, can be in providers)

```dart
// Example: Repository interface (like IUserRepository in .NET)
abstract class AuthRepository {
  Future<User> login(String email, String password);
}
```

### 3. Data Layer (Infrastructure)
**Flutter equivalent to**: Infrastructure/Data Access Layer in .NET

Located in: `lib/features/*/data/`

- **Repositories (Implementation)**: Like Repository implementations in Entity Framework
- **DataSources**: API clients, Database access (like DbContext in .NET)
- **Models**: Database/API models (similar to Entity models)

```dart
// Example: Repository implementation (like UserRepository : IUserRepository)
class AuthRepositoryImpl implements AuthRepository {
  final DioClient _client;
  
  @override
  Future<User> login(String email, String password) {
    // API call implementation
  }
}
```

### 4. Core Layer
**Flutter equivalent to**: Common/Shared/Cross-cutting concerns in .NET

Located in: `lib/core/`

Contains:
- **Configuration**: App settings (like appsettings.json)
- **Constants**: Static values (like Constants class in .NET)
- **Network**: HTTP client setup (like HttpClient configuration)
- **Storage**: Data persistence (like IMemoryCache, IDistributedCache)
- **Theme**: UI styling (like CSS/SCSS)
- **Logging**: Logging infrastructure (like ILogger in .NET)

## Key Concepts Comparison

### State Management (Riverpod) ≈ Dependency Injection in .NET

**In .NET:**
```csharp
// Startup.cs
services.AddScoped<IAuthRepository, AuthRepository>();
services.AddSingleton<ILogger, Logger>();

// Controller
public class AuthController {
    private readonly IAuthRepository _authRepo;
    
    public AuthController(IAuthRepository authRepo) {
        _authRepo = authRepo;
    }
}
```

**In Flutter (Riverpod):**
```dart
// Provider definition
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    dioClient: DioClient(),
    storage: SecureStorageService(),
  );
});

// Usage in widget
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    // Use authRepo
  }
}
```

### Routing (GoRouter) ≈ ASP.NET Routing

**In .NET:**
```csharp
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

**In Flutter (GoRouter):**
```dart
GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => DashboardPage(),
    ),
  ],
);
```

### HTTP Client (Dio) ≈ HttpClient in .NET

**In .NET:**
```csharp
var client = new HttpClient();
client.DefaultRequestHeaders.Authorization = 
    new AuthenticationHeaderValue("Bearer", token);
var response = await client.GetAsync("api/users");
```

**In Flutter (Dio):**
```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
));
dio.interceptors.add(AuthInterceptor());
final response = await dio.get('/users');
```

### Dependency Injection Pattern

**Both use the same pattern:**

1. Define interface/abstract class
2. Create implementation
3. Register in DI container
4. Inject where needed

## Project Structure Comparison

### .NET Web API Structure
```
MyProject/
├── Controllers/          # API endpoints
├── Models/              # Domain models
├── Services/            # Business logic
├── Repositories/        # Data access
├── Data/                # DbContext
└── appsettings.json     # Configuration
```

### Flutter App Structure
```
lib/
├── features/
│   └── auth/
│       ├── presentation/    # Like Controllers + Views
│       ├── domain/          # Like Models + Interfaces
│       └── data/            # Like Repositories + Data
├── core/
│   ├── config/             # Like appsettings.json
│   ├── network/            # Like HttpClient setup
│   └── storage/            # Like IMemoryCache
└── main.dart               # Like Program.cs
```

## Key Differences from .NET

### 1. Asynchronous Programming
- **Dart**: Uses `Future<T>` and `async/await` (same as C#)
- **Example**: `Future<User> getUser()` ≈ `Task<User> GetUser()`

### 2. Null Safety
- **Dart**: Uses `?` for nullable types (like C# 8.0+)
- **Example**: `String?` ≈ `string?` in C#

### 3. JSON Serialization
- **Dart**: Uses code generation with `json_serializable`
- **C#**: Uses attributes like `[JsonProperty]`

**Dart:**
```dart
@JsonSerializable()
class User {
  final String name;
  User({required this.name});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**C#:**
```csharp
public class User {
    [JsonProperty("name")]
    public string Name { get; set; }
}
```

### 4. Widgets vs Components
- **Flutter**: Everything is a Widget (like React components)
- **.NET**: Uses MVC/MVVM patterns with Views

## Authentication & Authorization

### JWT Token Flow (Same as .NET)

1. User logs in with credentials
2. Server returns access token + refresh token
3. Store tokens securely
4. Add token to all API requests
5. Refresh token when expired
6. Logout clears tokens

**Implementation:**
- `SecureStorageService`: Stores tokens (like IDataProtection in .NET)
- `AuthInterceptor`: Adds Bearer token to requests (like DelegatingHandler)
- `AuthProvider`: Manages auth state (like ClaimsPrincipal)

## Common Tasks

### Adding a New Feature

1. **Create feature folder structure:**
   ```
   lib/features/my_feature/
   ├── presentation/
   ├── domain/
   └── data/
   ```

2. **Define domain models** (like DTOs in .NET)

3. **Create repository interface** (like IRepository)

4. **Implement repository** (like concrete Repository class)

5. **Create provider** (like Service/ViewModel)

6. **Build UI pages** (like Views/Pages)

### Adding an API Endpoint

1. Add method to repository interface
2. Implement in repository class
3. Use DioClient to make HTTP call
4. Handle response and errors

### Adding a Route

1. Define route constant in `app_constants.dart`
2. Add GoRoute in `router_config.dart`
3. Create corresponding page widget

## Best Practices

### 1. Separation of Concerns
- Keep UI logic in presentation layer
- Keep business logic in domain/providers
- Keep data access in data layer

### 2. Error Handling
```dart
try {
  await repository.login();
} catch (e) {
  AppLogger.error('Login failed', e);
  // Show error to user
}
```

### 3. Logging
```dart
AppLogger.info('User logged in');
AppLogger.error('Error occurred', error, stackTrace);
```

### 4. Constants
- Store magic strings in `app_constants.dart`
- Store configuration in `app_config.dart`

## Testing

Similar to .NET testing:

```dart
// Unit test (like NUnit/xUnit)
test('login should return user', () async {
  final result = await authRepository.login('test@test.com', 'pass');
  expect(result, isA<User>());
});

// Widget test (like UI tests)
testWidgets('should show login button', (tester) async {
  await tester.pumpWidget(LoginPage());
  expect(find.text('Login'), findsOneWidget);
});
```

## Development Workflow

1. **Run code generation** (after changing models):
   ```bash
   flutter pub run build_runner watch
   ```

2. **Hot reload** (Ctrl+S or Cmd+S):
   - Updates UI instantly without restarting app

3. **Hot restart** (Ctrl+Shift+\\ ):
   - Restarts app while keeping state

4. **Debug** (F5):
   - Full debugging with breakpoints (like Visual Studio)

## Resources for .NET Developers

- **Dart for C# Developers**: https://dart.dev/guides/language/coming-from/csharp
- **Flutter Architecture**: Similar to MVVM/Clean Architecture
- **Riverpod**: Think of it as DI Container + State Management
- **Dio**: Similar to HttpClient with interceptors

## Summary

If you're comfortable with:
- **Clean Architecture** → You'll understand the folder structure
- **Dependency Injection** → You'll understand Riverpod
- **async/await** → You'll understand Futures
- **MVVM/MVC** → You'll understand Providers and Widgets
- **Repository Pattern** → You'll understand Data layer
- **HttpClient** → You'll understand Dio

The concepts are the same, just with different syntax and tools!