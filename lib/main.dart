import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dandd_sales_app/core/config/app_config.dart';
import 'package:dandd_sales_app/core/config/router_config.dart' as app_router;
import 'package:dandd_sales_app/core/logging/app_logger.dart';
import 'package:dandd_sales_app/core/storage/local_storage_service.dart';
import 'package:dandd_sales_app/core/theme/app_theme.dart';

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
      routerConfig:app_router.RouterConfig.router,
    );
  }
}
