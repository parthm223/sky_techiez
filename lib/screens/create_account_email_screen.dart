import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // Get the registration controller
  final RegistrationController _registrationController =
      Get.find<RegistrationController>();

  String firstName = "";
  String lastName = "";
  String dob = "";

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      firstName = Get.arguments["first_name"];
      lastName = Get.arguments["last_name"];
      dob = Get.arguments["dob"];
      setState(() {});
      print("firstName => ${firstName}");
      print("lastName => ${lastName}");
      print("dob => ${dob}");
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
                const SizedBox(height: 16),
                const SizedBox(height: 16), // Instead of Spacer()
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
                      text: 'Next',
                      onPressed: () {
                        print("Next button pressed");
                        if (_formKey.currentState!.validate()) {
                          print("Form validated successfully");
                          // Save email to controller
                          _registrationController.email.value =
                              _emailController.text.trim();
                          print(
                              "Saved email: ${_registrationController.email.value}");

                          // Navigate to next screen without OTP verification
                          Get.to(() => const CreateAccountMobileScreen(),
                              arguments: {
                                "first_name": firstName,
                                "last_name": lastName,
                                "dob": dob,
                                "email": _emailController.text,
                              });
                        } else {
                          print("Form validation failed");
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
