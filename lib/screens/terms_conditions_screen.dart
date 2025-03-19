import 'package:flutter/material.dart';
import 'package:sky_techiez/theme/app_theme.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms & Conditions',
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
            _buildTermsSection(
              'Agreement to Terms',
              'By accessing or using the Sky Techiez mobile application and services, you agree to be bound by these Terms and Conditions. If you disagree with any part of the terms, you may not access the service.',
            ),
            _buildTermsSection(
              'Use of Services',
              'Our services are provided "as is" and "as available." We make no warranties, expressed or implied, regarding the reliability, availability, or accuracy of our services.\n\n'
                  'You agree to use our services only for lawful purposes and in accordance with these Terms. You agree not to use our services:\n\n'
                  '• In any way that violates any applicable law or regulation\n'
                  '• To harass, abuse, or harm another person\n'
                  '• To impersonate any person or entity\n'
                  '• To infringe upon the rights of others\n'
                  '• To upload or transmit viruses or malicious code',
            ),
            _buildTermsSection(
              'User Accounts',
              'When you create an account with us, you must provide accurate, complete, and up-to-date information. You are responsible for safeguarding the password that you use to access our services and for any activities or actions under your password.\n\n'
                  'You agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.',
            ),
            _buildTermsSection(
              'Intellectual Property',
              'The service and its original content, features, and functionality are and will remain the exclusive property of Sky Techiez and its licensors. The service is protected by copyright, trademark, and other laws.\n\n'
                  'Our trademarks and trade dress may not be used in connection with any product or service without the prior written consent of Sky Techiez.',
            ),
            _buildTermsSection(
              'User Content',
              'You retain all rights to any content you submit, post, or display on or through our services. By submitting, posting, or displaying content on or through our services, you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, adapt, publish, translate, and distribute such content.',
            ),
            _buildTermsSection(
              'Termination',
              'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.\n\n'
                  'Upon termination, your right to use the service will immediately cease. If you wish to terminate your account, you may simply discontinue using the service.',
            ),
            _buildTermsSection(
              'Limitation of Liability',
              'In no event shall Sky Techiez, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the service.',
            ),
            _buildTermsSection(
              'Changes to Terms',
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days\' notice prior to any new terms taking effect.',
            ),
            _buildTermsSection(
              'Contact Us',
              'If you have any questions about these Terms, please contact us at terms@skytechiez.com.',
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
