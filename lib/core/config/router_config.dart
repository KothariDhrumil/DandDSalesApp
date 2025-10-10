import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../constants/app_constants.dart';
import '../logging/app_logger.dart';

/// Application router configuration using GoRouter
class RouterConfig {
  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.loginRoute,
    debugLogDiagnostics: true,
    routes: [
      // Login route
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) {
          AppLogger.logNavigation('', 'login');
          return const LoginPage();
        },
      ),
      
      // OTP verification route
      GoRoute(
        path: AppConstants.otpRoute,
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final phoneNumber = extra?['phoneNumber'] as String? ?? '';
          final requestId = extra?['requestId'] as String? ?? '';
          
          AppLogger.logNavigation('login', 'otp');
          return OtpPage(
            phoneNumber: phoneNumber,
            requestId: requestId,
          );
        },
      ),
      
      // Dashboard route
      GoRoute(
        path: AppConstants.dashboardRoute,
        name: 'dashboard',
        builder: (context, state) {
          AppLogger.logNavigation('', 'dashboard');
          return const DashboardPage();
        },
      ),
      
      // Profile route
      GoRoute(
        path: AppConstants.profileRoute,
        name: 'profile',
        builder: (context, state) {
          AppLogger.logNavigation('dashboard', 'profile');
          return const ProfilePage();
        },
      ),
      
      // Products route (placeholder for now)
      GoRoute(
        path: AppConstants.productsRoute,
        name: 'products',
        builder: (context, state) {
          AppLogger.logNavigation('', 'products');
          return const _ProductsPlaceholder();
        },
      ),
    ],
    errorBuilder: (context, state) {
      AppLogger.error('Route error: ${state.error}');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                state.error?.toString() ?? 'Unknown error',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.go(AppConstants.dashboardRoute);
                },
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Placeholder widget for products page
class _ProductsPlaceholder extends StatelessWidget {
  const _ProductsPlaceholder();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory, size: 64),
            SizedBox(height: 16),
            Text('Products Feature'),
            SizedBox(height: 8),
            Text('Coming soon...'),
          ],
        ),
      ),
    );
  }
}
