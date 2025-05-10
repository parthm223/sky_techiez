import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/registration_controller.dart';
import 'package:sky_techiez/screens/create_password_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class UploadSelfieScreen extends StatefulWidget {
  const UploadSelfieScreen({super.key});

  @override
  State<UploadSelfieScreen> createState() => _UploadSelfieScreenState();
}

class _UploadSelfieScreenState extends State<UploadSelfieScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _capturedImage;
  bool _isCapturing = false;

  // Get the registration controller
  final RegistrationController _registrationController =
      Get.find<RegistrationController>();
  String firstName = "";
  String lastName = "";
  String dob = "";
  String email = "";
  String mobile = "";
  String selphoto = "";

  @override
  void initState() {
    firstName = Get.arguments["first_name"];
    lastName = Get.arguments["last_name"];
    dob = Get.arguments["dob"];
    email = Get.arguments["email"];
    mobile = Get.arguments["mobile_number"];
    super.initState();

    // Check if we already have a profile image
    if (_registrationController.profileImage.value != null) {
      _capturedImage = _registrationController.profileImage.value;
    }
  }

  Future<void> _takePicture() async {
    if (_isCapturing) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      // Use image_picker to capture image from camera
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (photo != null) {
        selphoto = photo.path;
        setState(() {
          _capturedImage = File(photo.path);
        });
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isCapturing) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      // Use image_picker to select image from gallery
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (photo != null) {
        selphoto = photo.path;
        setState(() {
          _capturedImage = File(photo.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  void _retakePicture() {
    setState(() {
      _capturedImage = null;
    });
  }

  void _confirmSelfie() {
    // Save profile image to controller
    _registrationController.profileImage.value = _capturedImage;

    // Navigate to password screen
    Get.to(() => const CreatePasswordScreen(), arguments: {
      "first_name": firstName,
      "last_name": lastName,
      "dob": dob,
      "email": email,
      "mobile_number": mobile,
      "selfie_image": selphoto,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Selfie'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: _capturedImage != null
          ? _buildPreviewScreen()
          : _buildCaptureScreen(),
    );
  }

  Widget _buildCaptureScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.5),
            Colors.black.withOpacity(0.5),
            Colors.black.withOpacity(0.7),
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          // Face Outline Placeholder
          // Container(
          //   width: 250,
          //   height: 250,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: AppColors.primaryBlue, width: 3),
          //     shape: BoxShape.circle,
          //   ),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       border:
          //           Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          //       shape: BoxShape.circle,
          //     ),
          //     child: const Center(
          //       child: Icon(
          //         Icons.face,
          //         size: 100,
          //         color: Colors.white54,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 30),
          // Instructions
          const Text(
            'Take a clear selfie',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Make sure your face is well-lit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          // Bottom Controls
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Camera Button
                  GestureDetector(
                    onTap: _isCapturing ? null : _takePicture,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          height: 65,
                          width: 65,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: _isCapturing
                              ? const CircularProgressIndicator(
                                  color: AppColors.primaryBlue,
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.primaryBlue,
                                  size: 32,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Tap to capture',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              // Gallery Option
              TextButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(
                  Icons.photo_library,
                  color: Colors.white,
                ),
                label: const Text(
                  'Select from Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewScreen() {
    return Stack(
      children: [
        // Image Preview
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.file(
            _capturedImage!,
            fit: BoxFit.cover,
          ),
        ),

        // Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.0, 0.2, 0.8, 1.0],
            ),
          ),
        ),

        // Preview Text
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text(
                'Preview',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Is this selfie clear?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Controls
        Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Retake Button
              CustomButton(
                text: 'Retake',
                onPressed: _retakePicture,
                isOutlined: true,
                width: 150,
              ),

              // Confirm Button
              CustomButton(
                text: 'Confirm',
                onPressed: _confirmSelfie,
                width: 150,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
