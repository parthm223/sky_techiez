import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sky_techiez/screens/upload_selfie_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/custom_text_field.dart';

class CreateAccountMobileScreen extends StatefulWidget {
  const CreateAccountMobileScreen({super.key});

  @override
  State<CreateAccountMobileScreen> createState() =>
      _CreateAccountMobileScreenState();
}

class _CreateAccountMobileScreenState extends State<CreateAccountMobileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would send an OTP to the mobile number
      setState(() {
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent to your mobile number'),
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
                  label: 'Mobile Number',
                  hint: 'Enter your mobile number',
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                    _PhoneNumberFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.replaceAll('-', '').length < 10) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (_otpSent) ...[
                  CustomTextField(
                    label: 'OTP',
                    hint: 'Enter OTP sent to your mobile',
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
                                    const UploadSelfieScreen(),
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

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll('-', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 2 || i == 5) && i != text.length - 1) {
        buffer.write('-');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
