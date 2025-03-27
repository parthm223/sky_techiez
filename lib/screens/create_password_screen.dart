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

  // Get the registration controller
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
    firstName = Get.arguments["first_name"];
    lastName = Get.arguments["last_name"];
    dob = Get.arguments["dob"];
    email = Get.arguments["email"];
    mobile = Get.arguments["mobile_number"];
    selfieImage = Get.arguments["selfie_image"];
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    print('Register button pressed');
    if (_formKey.currentState!.validate()) {
      print('Form validation passed');
      print('Password entered: ${_passwordController.text}');

      // Save password to controller
      _registrationController.password.value = _passwordController.text;

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
      var headers = {'X-Requested-With': 'XMLHttpRequest'};
      request.headers.addAll(headers);
      print("====> ${request.fields}");
      request.files
          .add(await http.MultipartFile.fromPath('profile_image', selfieImage));
      print("files =>${request.files.first.filename}");
      var response = await request.send();

      if (response.statusCode == 200) {
        Get.offAll(() => const LoginScreen());
        print(
            "=============================> ${await response.stream.bytesToString()}");
      } else {
        print(await response.stream.bytesToString());
      }

      // try {
      //   print('Calling register function in controller');
      //   final result = await _registrationController.register();

      //   print('Registration result: $result');
      //   if (result['success']) {
      //     print('Registration successful');
      //     Get.snackbar(
      //       'Success',
      //       'Account created successfully',
      //       backgroundColor: AppColors.primaryBlue,
      //       colorText: Colors.white,
      //     );

      //     // Navigate to login screen
      //     Get.offAll(() => const LoginScreen());
      //   } else {
      //     print('Registration failed: ${result['message']}');
      //     Get.snackbar(
      //       'Error',
      //       result['message'] ?? 'Registration failed',
      //       backgroundColor: Colors.red,
      //       colorText: Colors.white,
      //     );
      //   }
      // } catch (e) {
      //   print('Error during registration: $e');
      //   Get.snackbar(
      //     'Error',
      //     'Error: $e',
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white,
      //   );
      // }
    } else {
      print('Form validation failed');
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
                      print('Password visibility toggled: $_obscurePassword');
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      print('Password validation failed: empty field');
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      print(
                          'Password validation failed: less than 6 characters');
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
                      print(
                          'Confirm Password visibility toggled: $_obscureConfirmPassword');
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      print('Confirm Password validation failed: empty field');
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      print(
                          'Confirm Password validation failed: passwords do not match');
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
