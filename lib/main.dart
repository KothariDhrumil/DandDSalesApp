import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/config/router_config.dart';
import 'core/logging/app_logger.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger
  AppLogger.info('Application starting...');
  
  // Initialize local storage
  try {
    await LocalStorageService().init();
    AppLogger.info('Local storage initialized');
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize local storage', e, stackTrace);
  }
  
  // Run app
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: RouterConfig.router,
    );
  }
}
