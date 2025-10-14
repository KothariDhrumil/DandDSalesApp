import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dandd_sales_app/core/constants/app_constants.dart';
import 'package:dandd_sales_app/core/logging/app_logger.dart';
import 'package:dandd_sales_app/features/auth/presentation/providers/auth_provider.dart';

/// Login page with phone number input
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
  
  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    
    final phoneNumber = _phoneController.text.trim();
    AppLogger.logAuth('Requesting OTP', details: {'phone': phoneNumber});
    
    final response = await ref.read(authProvider.notifier).sendOtp(phoneNumber);
    
    if (response != null && response.success && mounted) {
      // Navigate to OTP verification page
      Navigator.of(context).pushNamed(
        AppConstants.otpRoute,
        arguments: {
          'phoneNumber': phoneNumber,
          'requestId': response.requestId ?? '',
        },
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?.message ?? 'Failed to send OTP'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App logo or title
                  Icon(
                    Icons.business,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'D&D Sales App',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sales and Distribution Management',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  // Phone number input
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter your 10-digit phone number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      final phoneRegex = RegExp(AppConstants.phonePattern);
                      if (!phoneRegex.hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Send OTP button
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _sendOtp,
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Send OTP'),
                  ),
                  
                  // Error message
                  if (authState.error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        authState.error!,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Info text
                  Text(
                    'You will receive a 6-digit OTP on your phone number',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
