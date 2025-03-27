import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/registration_controller.dart';
import 'package:sky_techiez/screens/create_account_email_screen.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/custom_text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();

  final RegistrationController _registrationController =
      Get.put(RegistrationController());

  @override
  void initState() {
    super.initState();
    print("Initializing CreateAccountScreen");
    _firstNameController.text = _registrationController.firstName.value;
    _lastNameController.text = _registrationController.lastName.value;
    _dobController.text = _registrationController.dob.value;
    print(
        "Loaded existing values: FirstName: ${_firstNameController.text}, LastName: ${_lastNameController.text}, DOB: ${_dobController.text}");
  }

  @override
  void dispose() {
    print("Disposing controllers");
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
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
                  label: 'First Name',
                  hint: 'Enter your first name',
                  controller: _firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      print("First Name validation failed");
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Last Name',
                  hint: 'Enter your last name',
                  controller: _lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      print("Last Name validation failed");
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'DOB',
                  hint: 'DD/MM/YYYY',
                  controller: _dobController,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                    _DateInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      print("DOB validation failed");
                      return 'Please enter your date of birth';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'Back',
                      onPressed: () {
                        print("Back button pressed");
                        Navigator.pop(context);
                      },
                      isOutlined: true,
                      width: 120,
                    ),
                    CustomButton(
                      text: 'Next',
                      onPressed: () {
                        print("Next button pressed");
                        if (_formKey.currentState!.validate()) {
                          print("Form validation passed");
                          _registrationController.firstName.value =
                              _firstNameController.text;
                          _registrationController.lastName.value =
                              _lastNameController.text;
                          _registrationController.dob.value =
                              _dobController.text;
                          print(
                              "Saved data: FirstName: ${_firstNameController.text}, LastName: ${_lastNameController.text}, DOB: ${_dobController.text}");
                          Get.to(() => const CreateAccountEmailScreen(),
                              arguments: {
                                "first_name": _firstNameController.text,
                                "last_name": _lastNameController.text,
                                "dob": _dobController.text,
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

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 1 || i == 3) && i != text.length - 1) {
        buffer.write('/');
      }
    }
    print("Formatted DOB input: ${buffer.toString()}");
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
