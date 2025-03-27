import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/registration_controller.dart';
import 'package:sky_techiez/screens/upload_selfie_screen.dart';
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

  // Get the registration controller
  final RegistrationController _registrationController =
      Get.find<RegistrationController>();

  String firstName = "";
  String lastName = "";
  String dob = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    print("Initializing CreateAccountMobileScreen");
    // Initialize mobile controller with existing value if any
    _mobileController.text = _registrationController.phone.value;
    print("Initial phone value: \${_mobileController.text}");

    if (_mobileController.text.isNotEmpty &&
        !_mobileController.text.contains('-')) {
      // Format the phone number if it's not already formatted
      final text = _mobileController.text;
      final buffer = StringBuffer();
      for (int i = 0; i < text.length; i++) {
        buffer.write(text[i]);
        if ((i == 2 || i == 5) && i != text.length - 1) {
          buffer.write('-');
        }
      }
      _mobileController.text = buffer.toString();
      print("Formatted phone value: \${_mobileController.text}");
    }
    firstName = Get.arguments["first_name"];
    lastName = Get.arguments["last_name"];
    dob = Get.arguments["dob"];
    email = Get.arguments["email"];
  }

  @override
  void dispose() {
    print("Disposing CreateAccountMobileScreen");
    _mobileController.dispose();
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
                    print("Validating phone input: \$value");
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
                      text: 'Next',
                      onPressed: () {
                        print("Next button pressed");
                        if (_formKey.currentState!.validate()) {
                          // Save phone to controller
                          _registrationController.phone.value =
                              _mobileController.text.replaceAll('-', '');
                          print(
                              "Phone saved: \${_registrationController.phone.value}");

                          // Navigate to next screen
                          Get.to(() => const UploadSelfieScreen(), arguments: {
                            "first_name": firstName,
                            "last_name": lastName,
                            "dob": dob,
                            "email": email,
                            "mobile_number": _mobileController.text
                          });
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
    print("Formatting input: Old: \${oldValue.text}, New: \${newValue.text}");
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

    print("Formatted text: \${buffer.toString()}");
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
