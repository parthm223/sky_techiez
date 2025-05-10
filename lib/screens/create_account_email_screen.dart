import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sky_techiez/controllers/registration_controller.dart';
import 'package:sky_techiez/screens/create_account_mobile_screen.dart';
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
  String _otp = "";

  // Get the registration controller
  final RegistrationController _registrationController =
      Get.find<RegistrationController>();

  bool _otpSent = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  String firstName = "";
  String lastName = "";
  String dob = "";

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      firstName = Get.arguments["first_name"] ?? "";
      lastName = Get.arguments["last_name"] ?? "";
      dob = Get.arguments["dob"] ?? "";
      setState(() {});
      print("firstName => $firstName");
      print("lastName => $lastName");
      print("dob => $dob");
    }
    // Initialize email controller with existing value if any
    _emailController.text = _registrationController.email.value;
    print("Initialized email: ${_emailController.text}");
  }

  @override
  void dispose() {
    _emailController.dispose();
    print("Email controller disposed");
    super.dispose();
  }

  // Function to send OTP via API
  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSendingOtp = true;
      });

      final email = _emailController.text.trim();
      final url = Uri.parse('https://tech.skytechiez.co/api/send-otp');

      print("Sending OTP to email: $email");

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
          body: jsonEncode({'email': email}),
        );

        print("Response status code: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          setState(() {
            _otpSent = true;
            _isSendingOtp = false;
          });
          print("OTP successfully sent!");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sent to your email'),
              backgroundColor: Colors.blue,
            ),
          );
        } else {
          setState(() {
            _isSendingOtp = false;
          });
          print("Failed to send OTP. Server responded with ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send OTP. Try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        setState(() {
          _isSendingOtp = false;
        });
        print("Error sending OTP: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to verify OTP via API
  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isVerifyingOtp = true;
      });

      final email = _emailController.text.trim();
      final otp = _otp;
      final url = Uri.parse('https://tech.skytechiez.co/api/verify-otp');

      print("Verifying OTP: $otp for email: $email");

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
          body: jsonEncode({'email': email, 'otp': otp}),
        );

        print("Response status code: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          setState(() {
            _isVerifyingOtp = false;
          });
          print("OTP Verified Successfully!");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP verified successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to the next screen
          Get.to(() => const CreateAccountMobileScreen(), arguments: {
            "first_name": firstName,
            "last_name": lastName,
            "dob": dob,
            "email": email,
          });
        } else {
          setState(() {
            _isVerifyingOtp = false;
          });
          print("Invalid OTP. Server responded with: ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid OTP. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        setState(() {
          _isVerifyingOtp = false;
        });
        print("Error verifying OTP: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
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
                    print("Validating email: ${value ?? ''}");
                    if (value == null || value.isEmpty) {
                      print("Validation failed: Email is empty");
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      print("Validation failed: Invalid email format");
                      return 'Please enter a valid email';
                    }
                    print("Validation successful");
                    return null;
                  },
                ),
                if (_otpSent) ...[
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OTP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: OtpTextField(
                          numberOfFields: 6,
                          borderColor: Colors.blue,
                          showFieldAsBox: true,
                          fieldHeight: 70,
                          fieldWidth: 45, // Reduced width to fit all fields
                          margin: EdgeInsets.symmetric(
                              horizontal: 4), // Reduced margin
                          textStyle: TextStyle(
                            fontSize: 20, // Slightly reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                          onCodeChanged: (String code) {
                            // Handle each digit change
                          },
                          onSubmit: (String verificationCode) {
                            setState(() {
                              _otp = verificationCode;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                if (_otpSent) ...[
                  CustomButton(
                    text: 'Verify OTP',
                    onPressed: _verifyOtp,
                    width: double.infinity,
                    isLoading: _isVerifyingOtp,
                  ),
                  const SizedBox(height: 16),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'Back',
                      onPressed: () {
                        print("Back button pressed");
                        Get.back();
                      },
                      isOutlined: true,
                      width: 120,
                    ),
                    CustomButton(
                      text: _otpSent ? 'Resend OTP' : 'Send OTP',
                      onPressed: _otpSent
                          ? _sendOtp
                          : () {
                              print("Next button pressed");
                              if (_formKey.currentState!.validate()) {
                                print("Form validated successfully");
                                // Save email to controller
                                _registrationController.email.value =
                                    _emailController.text.trim();
                                print(
                                    "Saved email: ${_registrationController.email.value}");

                                // Send OTP instead of directly navigating
                                _sendOtp();
                              } else {
                                print("Form validation failed");
                              }
                            },
                      width: 120,
                      isLoading: _isSendingOtp,
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
