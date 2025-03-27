import 'package:flutter/material.dart';
import 'package:sky_techiez/screens/home_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/custom_text_field.dart';

class VerifyOtp2 extends StatefulWidget {
  const VerifyOtp2({super.key});

  @override
  State<VerifyOtp2> createState() => _VerifyOtp2State();
}

class _VerifyOtp2State extends State<VerifyOtp2> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isKeyboardOpen = mediaQuery.viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow layout to adjust for keyboard
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isKeyboardOpen ? 20 : screenHeight * 0.05),
              if (!isKeyboardOpen) // Hide logo when keyboard is open
                Center(
                  child: Image.asset(
                    'assets/images/SkyLogo.png',
                    height: screenHeight * 0.25, // Responsive image size
                  ),
                ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Verify OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Enter the OTP sent to your Email',
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              CustomTextField(
                label: 'OTP',
                hint: 'Enter OTP',
                controller: _otpController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Verify',
                onPressed: () {
                  if (_otpController.text.length == 6) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid 6-digit OTP'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Resend OTP',
                    style: TextStyle(color: AppColors.primaryBlue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
