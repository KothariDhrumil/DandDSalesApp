# Setup Guide for D&D Sales App

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.0.0 or higher)
   - Download from: https://docs.flutter.dev/get-started/install
   - Follow installation instructions for your operating system

2. **Development IDE** (Choose one):
   - **Android Studio** (Recommended): https://developer.android.com/studio
   - **VS Code**: https://code.visualstudio.com/ with Flutter extension

3. **Platform-specific requirements**:
   - **For Android**: Android SDK, Android Emulator
   - **For iOS** (Mac only): Xcode, iOS Simulator

## Step-by-Step Setup

### 1. Verify Flutter Installation

Open terminal/command prompt and run:

```bash
flutter doctor
```

This will check your Flutter installation and show what's missing. Fix any issues before proceeding.

### 2. Clone the Repository

```bash
git clone https://github.com/KothariDhrumil/DandDSalesApp.git
cd DandDSalesApp
```

### 3. Install Dependencies

```bash
flutter pub get
```

This will download all the packages defined in `pubspec.yaml`.

### 4. Generate Code

Run the following command to generate JSON serialization code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Note**: Run this command whenever you modify model classes with `@JsonSerializable()` annotation.

### 5. Configure Backend API

Update the API base URL in `lib/core/config/app_config.dart`:

```dart
static const String baseUrl = 'https://your-backend-api.com/v1';
```

Or use environment variables:

```bash
flutter run --dart-define=BASE_URL=https://your-api.com/v1
```

### 6. Run the App

#### On an Emulator/Simulator:

1. Start Android Emulator or iOS Simulator
2. Run:
   ```bash
   flutter run
   ```

#### On a Physical Device:

1. Enable Developer Mode on your device
2. Connect device via USB
3. Run:
   ```bash
   flutter run
   ```

## Project Structure Overview

```
DandDSalesApp/
├── lib/                      # Main application code
│   ├── core/                # Core functionality
│   │   ├── config/          # App configuration
│   │   ├── constants/       # Constants
│   │   ├── logging/         # Logging system
│   │   ├── network/         # HTTP client & interceptors
│   │   ├── storage/         # Local & secure storage
│   │   └── theme/           # Theme configuration
│   ├── features/            # Feature modules
│   │   ├── auth/           # Authentication feature
│   │   ├── dashboard/      # Dashboard feature
│   │   └── profile/        # User profile feature
│   └── main.dart           # App entry point
├── test/                    # Unit & widget tests
├── assets/                  # Images, icons, fonts
├── android/                 # Android-specific code
├── ios/                     # iOS-specific code
└── pubspec.yaml            # Dependencies & assets
```

## Common Commands

### Development

```bash
# Run in debug mode
flutter run

# Run with hot reload (automatic)
# Just save your files (Ctrl+S or Cmd+S)

# Hot restart
# Press 'R' in terminal or Ctrl+Shift+\ in IDE

# Build for specific platform
flutter run -d android
flutter run -d ios
```

### Code Generation

```bash
# Watch mode (auto-generates on file changes)
flutter pub run build_runner watch

# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Building

```bash
# Android APK (debug)
flutter build apk

# Android APK (release)
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (Mac only)
flutter build ios --release
```

### Linting & Analysis

```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format lib/
```

## Backend API Requirements

Your backend API should implement the following endpoints:

### Authentication

1. **Send OTP**
   - **POST** `/auth/send-otp`
   - Body: `{ "phoneNumber": "1234567890" }`
   - Response: 
     ```json
     {
       "success": true,
       "message": "OTP sent successfully",
       "requestId": "unique-request-id",
       "expiresIn": 300
     }
     ```

2. **Verify OTP**
   - **POST** `/auth/verify-otp`
   - Body: 
     ```json
     {
       "phoneNumber": "1234567890",
       "otp": "123456",
       "requestId": "unique-request-id"
     }
     ```
   - Response:
     ```json
     {
       "accessToken": "jwt-access-token",
       "refreshToken": "jwt-refresh-token",
       "expiresIn": 3600,
       "user": {
         "id": "user-id",
         "name": "John Doe",
         "email": "john@example.com",
         "phone": "1234567890",
         "role": "admin",
         "company": "Company Name",
         "profileImage": "https://...",
         "createdAt": "2024-01-01T00:00:00Z",
         "updatedAt": "2024-01-01T00:00:00Z"
       }
     }
     ```

3. **Refresh Token**
   - **POST** `/auth/refresh`
   - Body: `{ "refreshToken": "jwt-refresh-token" }`
   - Response: Same as Verify OTP response

4. **Logout**
   - **POST** `/auth/logout`
   - Headers: `Authorization: Bearer {accessToken}`
   - Response: `{ "success": true }`

## Troubleshooting

### Common Issues

#### 1. "Flutter command not found"
- Ensure Flutter is added to PATH
- Restart terminal after installation
- Run `export PATH="$PATH:[flutter-directory]/bin"` (Linux/Mac)

#### 2. "CocoaPods not installed" (iOS)
```bash
sudo gem install cocoapods
cd ios
pod install
```

#### 3. "Gradle build failed" (Android)
- The project now uses Gradle 8.5 and Android Gradle Plugin 8.3.0
- Ensure Android SDK 34 is installed via Android Studio SDK Manager
- Update Android SDK
- Check `android/app/build.gradle` for minimum SDK version (minSdk 21, targetSdk 34)
- Clear cache: `flutter clean`
- If Gradle daemon issues persist: `cd android && ./gradlew --stop && rm -rf .gradle`

#### 4. "Code generation failed"
- Ensure model classes are correctly annotated
- Delete conflicting files: `flutter pub run build_runner build --delete-conflicting-outputs`

#### 5. "Package conflicts"
```bash
flutter pub cache repair
flutter pub get
```

### Performance Issues

- Use `flutter run --profile` to profile the app
- Use `flutter run --release` for production-like performance
- Clear build cache: `flutter clean`

## IDE Setup

### Android Studio

1. Install Flutter plugin: File → Settings → Plugins → Search "Flutter"
2. Set Flutter SDK path: File → Settings → Languages & Frameworks → Flutter
3. Enable Dart support: File → Settings → Languages & Frameworks → Dart

### VS Code

1. Install extensions:
   - Flutter (by Dart Code)
   - Dart (by Dart Code)
2. Press F5 to run/debug

## Environment Variables

You can configure the app using environment variables:

```bash
flutter run --dart-define=BASE_URL=https://api.example.com \
           --dart-define=ENABLE_LOGGING=true
```

## Next Steps

1. **Backend Integration**: Update API endpoints in your backend
2. **Customize UI**: Modify theme colors in `lib/core/theme/app_theme.dart`
3. **Add Features**: Follow the architecture guide to add new features
4. **Testing**: Write tests for your new features
5. **Deploy**: Build and deploy to app stores

## Additional Resources

- **Flutter Documentation**: https://docs.flutter.dev/
- **Dart Language Tour**: https://dart.dev/guides/language/language-tour
- **Riverpod Documentation**: https://riverpod.dev/
- **GoRouter Documentation**: https://pub.dev/packages/go_router
- **Dio Documentation**: https://pub.dev/packages/dio

## Support

For questions or issues:
1. Check the documentation
2. Search existing GitHub issues
3. Create a new issue with detailed description
4. Contact the development team

## Development Tips

1. **Hot Reload**: Press 'r' or save your file - changes appear instantly
2. **Hot Restart**: Press 'R' - restarts app with changes
3. **DevTools**: Run `flutter pub global activate devtools` for debugging tools
4. **Widget Inspector**: Use in Android Studio/VS Code to inspect UI
5. **Logging**: Check console output for `AppLogger` messages

Happy Coding! 🚀