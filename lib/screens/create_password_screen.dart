import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/registration_controller.dart';
import 'package:sky_techiez/screens/login_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/custom_text_field.dart';
import "package:http/http.dart" as http;

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final RegistrationController _registrationController =
      Get.find<RegistrationController>();
  String firstName = "";
  String lastName = "";
  String dob = "";
  String email = "";
  String mobile = "";
  String selfieImage = "";

  @override
  void initState() {
    super.initState();
    try {
      firstName = Get.arguments["first_name"];
      lastName = Get.arguments["last_name"];
      dob = Get.arguments["dob"];
      email = Get.arguments["email"];
      mobile = Get.arguments["mobile_number"];
      selfieImage = Get.arguments["selfie_image"];
    } catch (e) {
      print("Error retrieving arguments: $e");
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _registrationController.isLoading.value = true;
    _registrationController.password.value = _passwordController.text;

    try {
      // Check if the selfie image file exists
      File selfieFile = File(selfieImage);
      if (!selfieFile.existsSync()) {
        Get.snackbar('Error', 'Selfie image file not found!',
            backgroundColor: Colors.red, colorText: Colors.white);
        _registrationController.isLoading.value = false;
        return;
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse('https://tech.skytechiez.co/api/register'));

      request.fields.addAll({
        'first_name': firstName,
        'last_name': lastName,
        'dob': dob,
        'phone': mobile,
        'password': _passwordController.text,
        'email': email,
      });

      request.files
          .add(await http.MultipartFile.fromPath('profile_image', selfieImage));

      request.headers.addAll({
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'multipart/form-data',
      });

      var response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("API Response: $responseBody");

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Account created successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAll(() => const LoginScreen());
      } else {
        Get.snackbar('Error', 'Registration failed: $responseBody',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on SocketException {
      Get.snackbar(
          'Network Error', 'No internet connection! Please check your network.',
          backgroundColor: Colors.red, colorText: Colors.white);
    } on HttpException {
      Get.snackbar('Server Error', 'Could not connect to the server!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } on FormatException {
      Get.snackbar('Invalid Response', 'Unexpected server response format!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      _registrationController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create Password'),
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
                  label: 'Password',
                  hint: 'Create a password',
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
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                Obx(() => CustomButton(
                      text: _registrationController.isLoading.value
                          ? 'Creating Account...'
                          : 'Create Account',
                      onPressed: _registrationController.isLoading.value
                          ? null
                          : _register,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
