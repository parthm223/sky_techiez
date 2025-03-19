import 'package:flutter/material.dart';
import 'package:sky_techiez/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: March 20, 2023',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildPolicySection(
              'Introduction',
              'Sky Techiez ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.',
            ),
            _buildPolicySection(
              'Information We Collect',
              'We may collect information about you in various ways, including:\n\n'
                  '• Personal Data: Name, email address, phone number, date of birth, and other identifiers.\n'
                  '• Usage Data: Information about how you use our application and services.\n'
                  '• Device Data: Information about your mobile device, including device type, operating system, and unique device identifiers.\n'
                  '• Location Data: With your consent, we may collect precise location information from your device.',
            ),
            _buildPolicySection(
              'How We Use Your Information',
              'We may use the information we collect for various purposes, including:\n\n'
                  '• To provide and maintain our services\n'
                  '• To notify you about changes to our services\n'
                  '• To allow you to participate in interactive features\n'
                  '• To provide customer support\n'
                  '• To gather analysis or valuable information to improve our services\n'
                  '• To monitor the usage of our services\n'
                  '• To detect, prevent, and address technical issues\n'
                  '• To fulfill any other purpose for which you provide it',
            ),
            _buildPolicySection(
              'Disclosure of Your Information',
              'We may share your information with:\n\n'
                  '• Service Providers: Third parties that help us provide and maintain our services.\n'
                  '• Business Partners: Companies we partner with to offer products or services.\n'
                  '• Affiliates: Our parent company, subsidiaries, and affiliates.\n'
                  '• Legal Requirements: To comply with legal obligations, protect our rights, or respond to legal process.',
            ),
            _buildPolicySection(
              'Security of Your Information',
              'We use administrative, technical, and physical security measures to protect your personal information. However, no method of transmission over the Internet or electronic storage is 100% secure, so we cannot guarantee absolute security.',
            ),
            _buildPolicySection(
              'Your Rights',
              'Depending on your location, you may have certain rights regarding your personal information, including:\n\n'
                  '• The right to access your personal information\n'
                  '• The right to correct inaccurate or incomplete information\n'
                  '• The right to delete your personal information\n'
                  '• The right to restrict or object to processing of your information\n'
                  '• The right to data portability\n'
                  '• The right to withdraw consent',
            ),
            _buildPolicySection(
              'Children\'s Privacy',
              'Our services are not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.',
            ),
            _buildPolicySection(
              'Changes to This Privacy Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.',
            ),
            _buildPolicySection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at privacy@skytechiez.com.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
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
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
