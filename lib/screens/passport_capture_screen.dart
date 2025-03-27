import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PassportCaptureScreen extends StatefulWidget {
  const PassportCaptureScreen({Key? key}) : super(key: key);

  @override
  State<PassportCaptureScreen> createState() => _PassportCaptureScreenState();
}

class _PassportCaptureScreenState extends State<PassportCaptureScreen> {
  int currentStep = 2;
  File? frontImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passport Verification'),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
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
                      image: frontImage,
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

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final stepNumber = index + 1;
          final isCurrentStep = stepNumber == currentStep;
          final isPastStep = stepNumber < currentStep;
          
          return Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentStep 
                      ? Colors.blue 
                      : (isPastStep ? Colors.blue.withOpacity(0.5) : Colors.grey.shade800),
                  border: Border.all(
                    color: isCurrentStep 
                        ? Colors.blue 
                        : (isPastStep ? Colors.blue.withOpacity(0.5) : Colors.grey.shade700),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: TextStyle(
                      color: isCurrentStep || isPastStep ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (index < 4)
                Container(
                  width: 24,
                  height: 1,
                  color: isPastStep ? Colors.blue.withOpacity(0.5) : Colors.grey.shade700,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDocumentUploadSection({
    required bool isActive,
    File? image,
  }) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: Colors.blue,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActive ? _takePicture : null,
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
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.article_outlined, color: Colors.blue, size: 32),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CD964),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose photo of your passport',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  '(PHOTO PAGE)',
                  style: TextStyle(
                    color: Colors.blue,
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
                  onPressed: _takePicture,
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
    bool canContinue = frontImage != null;

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

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          frontImage = File(image.path);
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
      const SnackBar(content: Text('Passport photo captured successfully!')),
    );
    
    // In a real app, you would navigate to the next screen
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}

