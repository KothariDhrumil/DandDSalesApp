# D&D Sales App

![Build Status](https://github.com/KothariDhrumil/DandDSalesApp/actions/workflows/build-and-deploy.yml/badge.svg)

Enterprise-level Flutter application for Sales and Distribution management, designed for Traders and Manufacturing businesses.

## 🎯 Features

### 1. **Authentication & Authorization**
- ✅ OTP-based login via phone number
- ✅ JWT access token and refresh token management
- ✅ Automatic token refresh on expiry
- ✅ Secure token storage using Flutter Secure Storage
- ✅ Session management

### 2. **API Management**
- ✅ Centralized HTTP client using Dio
- ✅ Request/Response interceptors
- ✅ Authentication interceptor for automatic token injection
- ✅ Logging interceptor for debugging
- ✅ Error handling and retry logic
- ✅ Configurable timeout and base URL

### 3. **Routing**
- ✅ Declarative routing using GoRouter
- ✅ Named routes with type-safe navigation
- ✅ Deep linking support
- ✅ Route guards for authentication
- ✅ Error handling and 404 pages

### 4. **Theming**
- ✅ Material Design 3 implementation
- ✅ Light and Dark theme support
- ✅ Consistent color scheme across the app
- ✅ Custom theme configuration
- ✅ Responsive UI components

### 5. **State Management**
- ✅ Riverpod for reactive state management
- ✅ Provider architecture
- ✅ Separation of concerns
- ✅ Testable and maintainable code structure

### 6. **Logging System**
- ✅ Comprehensive logging using Logger package
- ✅ Different log levels (debug, info, warning, error, fatal)
- ✅ Request/Response logging
- ✅ Authentication event logging
- ✅ Navigation logging
- ✅ Configurable logging in production

### 7. **User Profile**
- ✅ User profile display
- ✅ Profile information management
- ✅ Settings and preferences
- ✅ Theme switching
- ✅ Logout functionality

### 8. **Additional Features**
- ✅ Dashboard with business statistics
- ✅ Navigation drawer
- ✅ Secure local storage for non-sensitive data
- ✅ Input validation
- ✅ Error handling and user feedback
- ✅ Loading states and progress indicators

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart          # Application configuration
│   │   └── router_config.dart       # Routing configuration
│   ├── constants/
│   │   └── app_constants.dart       # App-wide constants
│   ├── logging/
│   │   └── app_logger.dart          # Centralized logging
│   ├── network/
│   │   ├── dio_client.dart          # HTTP client setup
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart    # Auth token management
│   │       └── logging_interceptor.dart # Request/response logging
│   ├── storage/
│   │   ├── secure_storage_service.dart  # Secure storage for tokens
│   │   └── local_storage_service.dart   # Local preferences storage
│   └── theme/
│       └── app_theme.dart           # Theme configuration
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── auth_response.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── otp_page.dart
│   │       └── providers/
│   │           └── auth_provider.dart
│   ├── dashboard/
│   │   └── presentation/
│   │       └── pages/
│   │           └── dashboard_page.dart
│   └── profile/
│       └── presentation/
│           └── pages/
│               └── profile_page.dart
└── main.dart                        # Application entry point
```

## 🛠️ Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Riverpod
- **Routing**: GoRouter
- **HTTP Client**: Dio
- **Storage**: Flutter Secure Storage, Shared Preferences
- **Logging**: Logger
- **UI**: Material Design 3
- **OTP Input**: Pinput

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- iOS development tools (for Mac users)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/KothariDhrumil/DandDSalesApp.git
   cd DandDSalesApp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (for JSON serialization)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **API Base URL**: Update the base URL in `lib/core/config/app_config.dart`
   ```dart
   static const String baseUrl = 'https://your-api-url.com/v1';
   ```

2. **Environment Variables**: You can also use environment variables
   ```bash
   flutter run --dart-define=BASE_URL=https://your-api-url.com/v1
   ```

## 🔒 Security

- **Token Management**: Access tokens and refresh tokens are stored securely using Flutter Secure Storage
- **API Security**: All API requests include authentication headers
- **Auto Refresh**: Tokens are automatically refreshed when expired
- **Logout**: Complete session cleanup on logout

## 📱 Features in Detail

### Authentication Flow

1. User enters phone number
2. System sends OTP to the phone number
3. User enters OTP
4. System verifies OTP and returns access token and refresh token
5. Tokens are stored securely
6. User is redirected to dashboard

### API Integration

The app uses Dio HTTP client with interceptors for:
- Adding authentication headers automatically
- Logging all requests and responses
- Handling token refresh automatically
- Error handling and retry logic

### State Management

Riverpod providers are used throughout the app:
- `authProvider`: Manages authentication state
- `authRepositoryProvider`: Provides auth repository instance

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🚀 CI/CD Pipeline

This project includes automated CI/CD pipeline using GitHub Actions.

### Automatic Builds
- ✅ Automated APK builds on every push to `main`/`master`
- ✅ Code analysis and testing
- ✅ Artifact generation for easy download
- ✅ Build retention for 30 days

### Download APK
After each successful build:
1. Go to [Actions tab](../../actions)
2. Select the latest workflow run
3. Download the APK from artifacts section

### Manual Deployments
Ready-to-use manual deployment workflows for:
- 📱 Google Play Store (requires setup)
- 🍎 Apple App Store (requires setup)

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed deployment instructions.

## 📖 API Documentation

### Authentication Endpoints

#### Send OTP
```
POST /auth/send-otp
Body: { "phoneNumber": "1234567890" }
Response: { "success": true, "message": "OTP sent", "requestId": "xxx", "expiresIn": 300 }
```

#### Verify OTP
```
POST /auth/verify-otp
Body: { "phoneNumber": "1234567890", "otp": "123456", "requestId": "xxx" }
Response: { "accessToken": "xxx", "refreshToken": "xxx", "user": {...}, "expiresIn": 3600 }
```

#### Refresh Token
```
POST /auth/refresh
Body: { "refreshToken": "xxx" }
Response: { "accessToken": "xxx", "refreshToken": "xxx", "user": {...}, "expiresIn": 3600 }
```

#### Logout
```
POST /auth/logout
Headers: { "Authorization": "Bearer xxx" }
```

## 🎨 Customization

### Theme
Modify colors and styles in `lib/core/theme/app_theme.dart`

### Routing
Add new routes in `lib/core/config/router_config.dart`

### API Configuration
Update configurations in `lib/core/config/app_config.dart`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License.

## 👥 Support

For support, email support@dandd.com or create an issue in the repository.

## 🗺️ Roadmap

- [ ] Product catalog management
- [ ] Order management
- [ ] Customer management
- [ ] Inventory tracking
- [ ] Reports and analytics
- [ ] Push notifications
- [ ] Offline support
- [ ] Multi-language support
- [ ] Biometric authentication
- [ ] Invoice generation

## 📸 Screenshots

(Add screenshots of your app here)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All package maintainers
- Contributors to this project
