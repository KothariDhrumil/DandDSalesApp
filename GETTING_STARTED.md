# Getting Started - Quick Guide

Welcome! This is your enterprise-level Flutter Sales and Distribution application. This guide will help you get started quickly.

## 🎯 What You Have

A complete, production-ready Flutter application with:

✅ **OTP-based Authentication** - Phone number login with refresh tokens  
✅ **API Management** - Complete HTTP client with interceptors  
✅ **Routing** - GoRouter for navigation  
✅ **Theming** - Light & Dark themes with Material Design 3  
✅ **State Management** - Riverpod for reactive state  
✅ **Logging** - Comprehensive logging system  
✅ **User Profile** - Profile management  
✅ **Dashboard** - Business overview with statistics  

## 📚 Documentation Index

We've created comprehensive documentation for you:

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **[README.md](README.md)** | Project overview & features | Start here! |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | Architecture explained for .NET developers | Understanding structure |
| **[SETUP_GUIDE.md](SETUP_GUIDE.md)** | Step-by-step setup instructions | First time setup |
| **[API_INTEGRATION.md](API_INTEGRATION.md)** | How to connect your .NET backend | Backend integration |
| **[CODE_EXAMPLES.md](CODE_EXAMPLES.md)** | Code examples for common tasks | When coding |
| **[FEATURES_ROADMAP.md](FEATURES_ROADMAP.md)** | Current & planned features | Planning development |

## 🚀 Quick Start (5 Minutes)

### 1. Install Flutter

```bash
# Visit https://docs.flutter.dev/get-started/install
# Follow instructions for your OS
```

### 2. Verify Installation

```bash
flutter doctor
```

### 3. Get Dependencies

```bash
cd DandDSalesApp
flutter pub get
```

### 4. Generate Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the App

```bash
flutter run
```

That's it! The app should now be running.

## 🔧 Configure Your Backend

Update the API URL in `lib/core/config/app_config.dart`:

```dart
static const String baseUrl = 'https://your-api.com/v1';
```

Or use environment variable:

```bash
flutter run --dart-define=BASE_URL=https://your-api.com/v1
```

## 📁 Project Structure

```
lib/
├── core/                  # Core functionality (config, network, storage, theme)
├── features/              # Feature modules
│   ├── auth/             # Authentication (login, OTP)
│   ├── dashboard/        # Dashboard
│   └── profile/          # User profile
└── main.dart             # App entry point
```

## 🎨 Key Features Overview

### 1. Authentication Flow

```
User enters phone → Send OTP → Verify OTP → Get tokens → Dashboard
```

The app handles:
- Token storage (secure)
- Auto token refresh
- Session management
- Logout

### 2. API Client

- Automatic token injection
- Request/Response logging
- Error handling
- Retry logic

### 3. State Management

Using Riverpod (similar to .NET Dependency Injection):

```dart
// Define provider
final myProvider = Provider((ref) => MyService());

// Use in widget
final service = ref.watch(myProvider);
```

### 4. Routing

Using GoRouter for declarative routing:

```dart
// Navigate to page
context.push('/products');

// With parameters
context.push('/products/123');
```

## 🔑 Key Concepts for .NET Developers

| Flutter | .NET Equivalent |
|---------|----------------|
| `Future<T>` | `Task<T>` |
| `async/await` | `async/await` |
| `Widget` | View/Component |
| `Provider` | DI Container |
| `Riverpod` | Service Provider |
| `GoRouter` | Routing |
| `Dio` | HttpClient |
| `SharedPreferences` | IMemoryCache |
| `SecureStorage` | IDataProtection |

## 📝 Your First Task: Add Products Feature

Follow these steps:

### 1. Create Model

```dart
// lib/features/products/domain/models/product_model.dart
@JsonSerializable()
class Product {
  final String id;
  final String name;
  final double price;
  // ... other fields
}
```

### 2. Create Repository Interface

```dart
// lib/features/products/domain/repositories/product_repository.dart
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
```

### 3. Implement Repository

```dart
// lib/features/products/data/repositories/product_repository_impl.dart
class ProductRepositoryImpl implements ProductRepository {
  final DioClient _client;
  
  @override
  Future<List<Product>> getProducts() async {
    final response = await _client.get('/products');
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
}
```

### 4. Create Provider

```dart
// lib/features/products/presentation/providers/product_provider.dart
final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});
```

### 5. Create UI

```dart
// lib/features/products/presentation/pages/product_list_page.dart
class ProductListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    
    return productsAsync.when(
      data: (products) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

See [CODE_EXAMPLES.md](CODE_EXAMPLES.md) for complete code.

## 🐛 Common Issues & Solutions

### Issue: "Flutter command not found"
**Solution**: Add Flutter to PATH and restart terminal

### Issue: "CocoaPods not installed" (iOS)
**Solution**: `sudo gem install cocoapods`

### Issue: "Build failed"
**Solution**: Run `flutter clean && flutter pub get`

### Issue: "Code generation failed"
**Solution**: Run `flutter pub run build_runner build --delete-conflicting-outputs`

## 📱 Development Workflow

1. **Make changes** to Dart files
2. **Save** (Ctrl+S / Cmd+S)
3. **Hot reload** happens automatically ⚡
4. **See changes** instantly in app

For major changes:
- Press `R` in terminal for hot restart
- Or press `Ctrl+Shift+\` in IDE

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Building for Production

### Android

```bash
flutter build apk --release
# APK at: build/app/outputs/flutter-apk/app-release.apk
```

### iOS (Mac only)

```bash
flutter build ios --release
```

## 🎓 Learning Resources

### For .NET Developers
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Compares Flutter to .NET concepts
- **Dart for C# Developers**: https://dart.dev/guides/language/coming-from/csharp

### Flutter Specific
- **Flutter Documentation**: https://docs.flutter.dev/
- **Dart Language Tour**: https://dart.dev/guides/language/language-tour
- **Widget Catalog**: https://docs.flutter.dev/ui/widgets

### Packages Used
- **Riverpod**: https://riverpod.dev/
- **GoRouter**: https://pub.dev/packages/go_router
- **Dio**: https://pub.dev/packages/dio

## 💡 Tips for Success

1. **Hot Reload is Your Friend**: Save often to see changes instantly
2. **Use DevTools**: Run `flutter pub global activate devtools` for debugging
3. **Check Logs**: Use `AppLogger` throughout the app
4. **Read Documentation**: We've documented everything for you
5. **Start Small**: Begin with one feature at a time
6. **Use Examples**: Check [CODE_EXAMPLES.md](CODE_EXAMPLES.md) when stuck

## 🤝 Need Help?

1. **Check documentation** in this repository
2. **Search existing issues** on GitHub
3. **Create new issue** with details
4. **Ask in discussions** for questions

## ✅ Next Steps

Now that you're set up:

1. ✅ Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand the structure
2. ✅ Review [API_INTEGRATION.md](API_INTEGRATION.md) for backend setup
3. ✅ Try running the app with `flutter run`
4. ✅ Make a small change and see hot reload in action
5. ✅ Start building your first feature using [CODE_EXAMPLES.md](CODE_EXAMPLES.md)

## 🎉 You're Ready!

You now have a solid foundation for your enterprise sales application. The architecture is clean, the code is organized, and everything is documented.

**Happy coding!** 🚀

---

**Questions?** Check the documentation or create an issue!  
**Found a bug?** Please report it!  
**Have a suggestion?** We'd love to hear it!