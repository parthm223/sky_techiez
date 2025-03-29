import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/auth_controller.dart';
import 'package:sky_techiez/screens/create_account_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Get the auth controller
  final AuthController _authController = Get.put(AuthController());

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final String emailOrPhone = _emailOrPhoneController.text;
    final String password = _passwordController.text;

    print("Attempting login with: $emailOrPhone and password: $password");

    try {
      final result = await _authController.login(emailOrPhone, password);

      if (result['success']) {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Login failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        // Navigate to home screen
        // Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar(
          'Success',
          result['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/SkyLogo.png',
                          height: 120,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'WELCOME TO SKY TECHIEZ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Email or Number',
                    hint: 'Enter your email or mobile number',
                    controller: _emailOrPhoneController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email or mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password functionality
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppColors.primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => _authController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: 'Login',
                            onPressed: _login,
                          ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Create New Account',
                    onPressed: () {
                      Get.to(() => const CreateAccountScreen());
                    },
                    isOutlined: true,
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
