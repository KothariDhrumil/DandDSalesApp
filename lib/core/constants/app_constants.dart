/// Application constants
class AppConstants {
  // Route names
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String otpRoute = '/otp';
  static const String dashboardRoute = '/dashboard';
  static const String profileRoute = '/profile';
  static const String productsRoute = '/products';
  static const String productDetailRoute = '/products/:id';
  
  // Storage keys
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String isFirstLaunch = 'is_first_launch';
  
  // Error messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Unauthorized. Please login again.';
  static const String unknownError = 'An unknown error occurred.';
  
  // Validation
  static const String phonePattern = r'^[0-9]{10}$';
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // Date formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm:ss';
  static const String timeFormat = 'HH:mm:ss';
}
