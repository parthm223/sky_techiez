import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sky_techiez/screens/create_account_mobile_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/custom_text_field.dart';

class CreateAccountEmailScreen extends StatefulWidget {
  const CreateAccountEmailScreen({super.key});

  @override
  State<CreateAccountEmailScreen> createState() =>
      _CreateAccountEmailScreenState();
}

class _CreateAccountEmailScreenState extends State<CreateAccountEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Function to send OTP via API
  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final url = Uri.parse('https://tech.skytechiez.co/api/send-otp');

      print("Sending OTP to email: $email"); // Debugging print

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
          body: jsonEncode({'email': email}),
        );

        print(
            "Response status code: ${response.statusCode}"); // Debugging print
        print("Response body: ${response.body}"); // Debugging print

        if (response.statusCode == 200) {
          setState(() {
            _otpSent = true;
          });
          print("OTP successfully sent!"); // Debugging print
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sent to your email'),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
        } else {
          print("Failed to send OTP. Server responded with ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send OTP. Try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        print("Error sending OTP: $error"); // Debugging print
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to verify OTP via API
  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final otp = _otpController.text.trim();
      final url = Uri.parse('https://tech.skytechiez.co/api/verify-otp');

      print("Verifying OTP: $otp for email: $email"); // Debugging print

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
          body: jsonEncode({'email': email, 'otp': otp}),
        );

        print(
            "Response status code: ${response.statusCode}"); // Debugging print
        print("Response body: ${response.body}"); // Debugging print

        if (response.statusCode == 200) {
          print("OTP Verified Successfully!"); // Debugging print
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP verified successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAccountMobileScreen(),
            ),
          );
        } else {
          print("Invalid OTP. Server responded with: ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid OTP. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        print("Error verifying OTP: $error"); // Debugging print
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create New Account'),
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
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Email',
                  hint: 'Enter your email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (_otpSent) ...[
                  CustomTextField(
                    label: 'OTP',
                    hint: 'Enter OTP sent to your email',
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      if (value.length < 4) {
                        return 'OTP must be at least 4 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        print("Resend OTP button clicked"); // Debugging print
                        _sendOtp();
                      },
                      child: const Text('Resend OTP'),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Send OTP',
                    onPressed: () {
                      print("Send OTP button clicked"); // Debugging print
                      _sendOtp();
                    },
                  ),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'Back',
                      onPressed: () {
                        print("Back button clicked"); // Debugging print
                        Navigator.pop(context);
                      },
                      isOutlined: true,
                      width: 120,
                    ),
                    if (_otpSent)
                      CustomButton(
                        text: 'Verify OTP',
                        onPressed: () {
                          print("Verify OTP button clicked"); // Debugging print
                          _verifyOtp();
                        },
                        width: 120,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
