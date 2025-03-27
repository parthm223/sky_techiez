import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions – Skytechiez',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/images/SkyLogo.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white38, thickness: 1),
            const SizedBox(height: 16),
            _buildTermsSection(
              '1. Services Provided',
              'Skytechiez offers professional technical support services, including but not limited to:\n'
                  '- Remote IT support\n'
                  '- Computer and software troubleshooting\n'
                  '- Network security solutions\n'
                  '- Virus and malware removal\n'
                  '- Data recovery and backup services',
            ),
            _buildTermsSection(
              '2. User Responsibilities',
              'By using our services, you agree to:\n'
                  '- Provide accurate and truthful information regarding your technical concerns.\n'
                  '- Ensure you have the legal authority to seek support for any device or software.\n'
                  '- Use our services only for lawful purposes and in compliance with IT security regulations.',
            ),
            _buildTermsSection(
              '3. Payments & Billing',
              'Services are billed according to the selected plan or one-time service fee. Unless otherwise agreed upon, full payment must be made before service delivery. Late payments may result in the suspension of services.',
            ),
            _buildTermsSection(
              '4. Refund Policy',
              'See the Refund Policy section for details regarding cancellations and refunds.',
            ),
            _buildTermsSection(
              '5. Limitation of Liability',
              'Skytechiez is not responsible for any data loss, system downtime, or indirect damages resulting from the use of our services. Customers are responsible for maintaining backups before seeking technical support.',
            ),
            _buildTermsSection(
              '6. Privacy Policy',
              'All customer information is handled according to our Privacy Policy.',
            ),
            _buildTermsSection(
              '7. Governing Law',
              'These Terms and Conditions are governed by the laws of Wyoming, USA.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
