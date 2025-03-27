import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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

class _UploadSelfieScreenState extends State<UploadSelfieScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  File? _capturedImage;
  bool _isFrontCamera = true;

  // Get the registration controller
  final RegistrationController _registrationController =
      Get.find<RegistrationController>();
  String firstName = "";
  String lastName = "";
  String dob = "";
  String email = "";
  String mobile = "";
  @override
  void initState() {
    firstName = Get.arguments["first_name"];
    lastName = Get.arguments["last_name"];
    dob = Get.arguments["dob"];
    email = Get.arguments["email"];
    mobile = Get.arguments["mobile_number"];
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Check if we already have a profile image
    if (_registrationController.profileImage.value != null) {
      _capturedImage = _registrationController.profileImage.value;
    } else {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        return;
      }

      // Start with front camera
      final frontCameras = _cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.front)
          .toList();
      final cameraToUse =
          frontCameras.isNotEmpty ? frontCameras.first : _cameras.first;

      _cameraController = CameraController(
        cameraToUse,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    setState(() {
      _isCameraInitialized = false;
      _isFrontCamera = !_isFrontCamera;
    });

    await _cameraController?.dispose();

    final cameraToUse = _isFrontCamera
        ? _cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front)
        : _cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      cameraToUse,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _cameraController!.initialize();

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  var selphoto = "";

  Future<void> _takePicture() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isCapturing) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      final XFile photo = await _cameraController!.takePicture();
      selphoto = photo.path;

      setState(() {
        _capturedImage = File(photo.path);
        _isCapturing = false;
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
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
      body:
          _capturedImage != null ? _buildPreviewScreen() : _buildCameraScreen(),
    );
  }

  Widget _buildCameraScreen() {
    return Stack(
      children: [
        // Camera Preview
        if (_isCameraInitialized)
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_cameraController!),
          )
        else
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryBlue,
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

        // Face Outline
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryBlue, width: 3),
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        // Instructions
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text(
                'Position your face within the circle',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
                  'Make sure your face is well-lit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Controls
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Switch Camera Button
                  if (_cameras.length > 1)
                    Container(
                      margin: const EdgeInsets.only(right: 40),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _switchCamera,
                      ),
                    ),

                  // Capture Button
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

                  // Empty space to balance the layout
                  const SizedBox(width: 68),
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
            ],
          ),
        ),
      ],
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
