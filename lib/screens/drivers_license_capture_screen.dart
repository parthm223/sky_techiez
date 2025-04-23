import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DriversLicenseCaptureScreen extends StatefulWidget {
  const DriversLicenseCaptureScreen({super.key});

  @override
  State<DriversLicenseCaptureScreen> createState() =>
      _DriversLicenseCaptureScreenState();
}

class _DriversLicenseCaptureScreenState
    extends State<DriversLicenseCaptureScreen> {
  int currentStep = 2;
  File? frontImage;
  File? backImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver\'s License Verification'),
      ),
      body: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/SkyLogo.png',
              height: 120,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'TAKE PHOTOS WITH YOUR PHONE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildDocumentUploadSection(
                      isActive: true,
                      isFront: true,
                      image: frontImage,
                    ),
                    const SizedBox(height: 16),
                    _buildDocumentUploadSection(
                      isActive: frontImage != null,
                      isFront: false,
                      image: backImage,
                    ),
                    const SizedBox(height: 32),
                    _buildContinueButton(),
                    const SizedBox(height: 24),
                    _buildPhotoTips(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadSection({
    required bool isActive,
    required bool isFront,
    File? image,
  }) {
    final borderColor = isActive ? Colors.blue : Colors.grey.shade700;
    final textColor = isActive ? Colors.blue : Colors.grey;

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: borderColor,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActive ? () => _takePicture(isFront) : null,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image == null) ...[
                Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Center(
                    child: isFront
                        ? Icon(Icons.person_outline, color: textColor, size: 32)
                        : Icon(Icons.horizontal_rule_outlined,
                            color: textColor, size: 32),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF4CD964)
                        : Colors.grey.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: isActive ? Colors.white : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose photo of your driver\'s license or state ID',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  isFront ? '(FRONT)' : '(BACK)',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    image,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _takePicture(isFront),
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  label: const Text(
                    'Retake photo',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    bool canContinue = frontImage != null && backImage != null;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: canContinue ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          disabledBackgroundColor: Colors.blue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTipItem('Use landscape orientation'),
        _buildTipItem('Turn off the flash on your camera'),
        _buildTipItem('Use a dark background'),
        _buildTipItem('Take the photo on a flat surface'),
      ],
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF4CD964),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture(bool isFront) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          if (isFront) {
            frontImage = File(image.path);
          } else {
            backImage = File(image.path);
          }
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking picture: $e')),
      );
    }
  }

  void _onContinue() {
    // Navigate to the next screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Driver\'s license photos captured successfully!')),
    );

    // In a real app, you would navigate to the next screen
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
