import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/models/user_login.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final GetStorage _storage = GetStorage();

  // Text controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _selfieImagePath;
  File? _selfieImageFile;
  bool _isLoading = false;
  UserLogin _userDetail = UserLogin();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storedData = _storage.read(userCollectionName);
    if (storedData != null) {
      setState(() {
        _userDetail = UserLogin.fromJson(storedData);
        _firstNameController.text = _userDetail.firstName ?? '';
        _lastNameController.text = _userDetail.lastName ?? '';
        _emailController.text = _userDetail.email ?? '';
        _mobileController.text = _userDetail.phone ?? '';
        if (_userDetail.dob != null) {
          try {
            final parsedDate = DateFormat('yyyy-MM-dd').parse(_userDetail.dob!);
            _dobController.text = DateFormat('MM-dd-yyyy').format(parsedDate);
          } catch (e) {
            _dobController.text = _userDetail.dob ?? '';
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selfieImagePath = pickedFile.path;
          _selfieImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error picking image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dobController.text.isNotEmpty
          ? DateFormat('MM-dd-yyyy').parse(_dobController.text)
          : DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              surface: AppColors.darkBackground,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.darkBackground,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('MM-dd-yyyy').format(picked);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = _storage.read(tokenKey) ?? '';
      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      // Corrected headers declaration
      Map<String, String> headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': token.toString(),
        'Accept': 'application/json',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://tech.skytechiez.co/api/update-profile'),
      );

      // Add form fields
      request.fields.addAll({
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'dob': _dobController.text.trim(),
        'phone': _mobileController.text.trim(),
        'email': _emailController.text.trim(),
      });

      // Attach profile image if available
      if (_selfieImageFile != null) {
        final file = await http.MultipartFile.fromPath(
          'profile_image',
          _selfieImageFile!.path,
        );
        request.files.add(file);
      }

      request.headers.addAll(headers);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        // Update user details in local storage
        _storage.write(userCollectionName, responseData['data']);
        await _loadUserData();

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMessage = responseData['message'] ??
            response.reasonPhrase ??
            'Failed to update profile';
        throw Exception(errorMessage);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image Section
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(
                                color: AppColors.primaryBlue, width: 2),
                          ),
                          child: _selfieImagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.file(
                                    File(_selfieImagePath!),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : _userDetail.profileUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.network(
                                        _userDetail.profileUrl!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: AppColors.grey,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.grey,
                                    ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Change Photo'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Personal Information
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // First Name
                _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),

                // Last Name
                _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),

                // Date of Birth
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: _buildTextField(
                      controller: _dobController,
                      label: 'Date of Birth',
                      suffixIcon: Icons.calendar_today,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Email
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                // Mobile
                _buildTextField(
                  controller: _mobileController,
                  label: 'Mobile Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (!GetUtils.isPhoneNumber(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),
                // Update Button
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryBlue))
                    : CustomButton(
                        text: 'Update Profile',
                        onPressed: _updateProfile,
                      ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryBlue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          filled: true,
          fillColor: AppColors.darkBackground.withOpacity(0.5),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon, color: AppColors.grey),
                  onPressed: onSuffixIconPressed,
                )
              : null,
        ),
        validator: validator,
      ),
    );
  }
}
