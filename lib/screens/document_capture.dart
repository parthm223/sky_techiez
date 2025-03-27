import 'package:flutter/material.dart';
import 'dart:io';

class DocumentCaptureScreen extends StatefulWidget {
  final String idType;

  const DocumentCaptureScreen({
    Key? key,
    required this.idType,
  }) : super(key: key);

  @override
  State<DocumentCaptureScreen> createState() => _DocumentCaptureScreenState();
}

class _DocumentCaptureScreenState extends State<DocumentCaptureScreen> {
  int currentStep = 1;
  File? frontImage;
  File? backImage;
  bool isPassportOrGovernmentId = false;

  @override
  void initState() {
    super.initState();
    isPassportOrGovernmentId =
        widget.idType == 'passport' || widget.idType == 'government_id';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Document Verification',
          style: TextStyle(color: Colors.black),
        ),
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
                        color: Color(0xFF2E4053),
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
                    if (!isPassportOrGovernmentId ||
                        widget.idType == 'drivers_license')
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

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final stepNumber = index + 1;
          final isCurrentStep = stepNumber == currentStep;

          return Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentStep ? Colors.blue : Colors.grey.shade200,
                  border: Border.all(
                    color: isCurrentStep ? Colors.blue : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: TextStyle(
                      color: isCurrentStep ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (index < 4)
                Container(
                  width: 24,
                  height: 1,
                  color: Colors.grey.shade300,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDocumentUploadSection({
    required bool isActive,
    required bool isFront,
    File? image,
  }) {
    final borderColor = isActive ? Colors.blue : Colors.grey.shade300;
    final borderStyle = isActive ? BorderStyle.solid : BorderStyle.solid;
    final textColor = isActive ? Colors.blue : Colors.grey;

    String idTypeText = '';
    if (widget.idType == 'passport') {
      idTypeText = 'passport';
    } else if (widget.idType == 'drivers_license') {
      idTypeText = 'driver\'s license or state ID';
    } else {
      idTypeText = 'government-issued ID';
    }

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 2,
          style: borderStyle,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Center(
                    child: isFront
                        ? const Icon(Icons.person_outline,
                            color: Colors.blue, size: 32)
                        : const Icon(Icons.horizontal_rule_outlined,
                            color: Colors.blue, size: 32),
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
                Text(
                  'Choose photo of your $idTypeText',
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
    bool canContinue = frontImage != null;
    if (!isPassportOrGovernmentId && widget.idType == 'drivers_license') {
      canContinue = frontImage != null && backImage != null;
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: canContinue ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade600,
          disabledBackgroundColor: Colors.grey.shade400,
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
                color: Color(0xFF2E4053),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture(bool isFront) async {
    // In a real app, you would use the camera plugin to take a picture
    // For this example, we'll simulate taking a picture

    // Simulating camera capture delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulating a captured image
    setState(() {
      if (isFront) {
        frontImage = File('dummy_front_image.jpg');
      } else {
        backImage = File('dummy_back_image.jpg');
      }
    });
  }

  void _onContinue() {
    // Navigate to the next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentReviewScreen(
          idType: widget.idType,
          frontImage: frontImage!,
          backImage: backImage,
        ),
      ),
    );
  }
}

class DocumentReviewScreen extends StatelessWidget {
  final String idType;
  final File frontImage;
  final File? backImage;

  const DocumentReviewScreen({
    Key? key,
    required this.idType,
    required this.frontImage,
    this.backImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Document'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Document Review Screen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('This is a placeholder for the review screen'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next step or complete the process
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Complete Verification'),
            ),
          ],
        ),
      ),
    );
  }
}
