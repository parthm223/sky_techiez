import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:sky_techiez/screens/home_screen.dart';
import 'package:sky_techiez/services/auth_service.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/custom_text_field.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    // Automatically send OTP when screen loads
    _sendOtp();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_formKey.currentState?.validate() ?? true) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Call the service to send OTP
        final success = await AuthService.sendOtp(_emailController.text.trim());

        setState(() {
          _isLoading = false;
        });

        if (success) {
          Get.snackbar(
            'Success',
            'OTP sent to your email',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(10),
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to send OTP. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(10),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Error',
          'An unexpected error occurred: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
        );
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Call the service to verify OTP
        final success = await AuthService.verifyOtp(
          _emailController.text.trim(),
          _otpController.text.trim(),
        );

        setState(() {
          _isLoading = false;
        });

        if (success) {
          Get.snackbar(
            'Success',
            'OTP verified successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(10),
          );

          // Navigate to home screen after successful verification
          Get.offAll(() => const HomeScreen());
        } else {
          Get.snackbar(
            'Error',
            'Invalid OTP. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(10),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Error',
          'An unexpected error occurred: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/SkyLogo.png',
                    height: 120,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Verify Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We have sent a verification code to ${_emailController.text}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'OTP Code',
                  hint: 'Enter the 6-digit code',
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP code';
                    }
                    if (value.length < 4) {
                      return 'OTP must be at least 4 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: _isLoading ? null : _sendOtp,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Resend OTP'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                    ),
                  ),
                ),
                const Spacer(),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Verify & Continue',
                        onPressed: _verifyOtp,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
