import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/logging/app_logger.dart';
import '../providers/auth_provider.dart';

/// OTP verification page
class OtpPage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String requestId;
  
  const OtpPage({
    super.key,
    required this.phoneNumber,
    required this.requestId,
  });
  
  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _otpController = TextEditingController();
  int _remainingSeconds = AppConfig.otpResendSeconds;
  bool _canResend = false;
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
  
  void _startTimer() {
    setState(() {
      _remainingSeconds = AppConfig.otpResendSeconds;
      _canResend = false;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        _startTimer();
      } else if (mounted) {
        setState(() => _canResend = true);
      }
    });
  }
  
  Future<void> _verifyOtp() async {
    if (_otpController.text.length != AppConfig.otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    AppLogger.logAuth('Verifying OTP', details: {'phone': widget.phoneNumber});
    
    final success = await ref.read(authProvider.notifier).verifyOtp(
      widget.phoneNumber,
      _otpController.text,
      widget.requestId,
    );
    
    if (success && mounted) {
      // Navigate to dashboard
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppConstants.dashboardRoute,
        (route) => false,
      );
    } else if (mounted) {
      final error = ref.read(authProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Invalid OTP. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      _otpController.clear();
    }
  }
  
  Future<void> _resendOtp() async {
    if (!_canResend) return;
    
    AppLogger.logAuth('Resending OTP', details: {'phone': widget.phoneNumber});
    
    final response = await ref.read(authProvider.notifier).sendOtp(widget.phoneNumber);
    
    if (response != null && response.success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _startTimer();
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
    
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon
                Icon(
                  Icons.verified_user,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Verify OTP',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                // Phone number display
                Text(
                  'Enter the OTP sent to ${widget.phoneNumber}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // OTP input
                Center(
                  child: Pinput(
                    controller: _otpController,
                    length: AppConfig.otpLength,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    onCompleted: (pin) => _verifyOtp(),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Verify button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _verifyOtp,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Verify OTP'),
                ),
                const SizedBox(height: 16),
                
                // Resend OTP
                TextButton(
                  onPressed: _canResend ? _resendOtp : null,
                  child: Text(
                    _canResend
                        ? 'Resend OTP'
                        : 'Resend OTP in $_remainingSeconds seconds',
                  ),
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
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
