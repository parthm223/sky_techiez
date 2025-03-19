import 'package:flutter/material.dart';
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

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would send an OTP to the email
      setState(() {
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent to your email'),
          backgroundColor: AppColors.primaryBlue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onPressed: _sendOtp,
                      child: const Text('Resend OTP'),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Verify',
                    onPressed: _sendOtp,
                  ),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'Back',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      isOutlined: true,
                      width: 120,
                    ),
                    if (_otpSent)
                      CustomButton(
                        text: 'Next',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateAccountMobileScreen(),
                              ),
                            );
                          }
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
