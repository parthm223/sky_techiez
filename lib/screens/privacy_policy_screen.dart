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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Privacy Policy – Skytechiez'),
            Center(
              child: Image.asset(
                'assets/images/SkyLogo.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white38, thickness: 1),
            const SizedBox(height: 16),
            _buildPolicySection(
              '1. Information We Collect',
              [
                'Name, contact details, and payment information.',
                'Device details, system logs, and troubleshooting reports.',
                'Website analytics (IP address, cookies, etc.).',
              ],
            ),
            _buildPolicySection(
              '2. How We Use Your Information',
              [
                'Provide and improve our technical support services.',
                'Process payments and manage service subscriptions.',
                'Respond to customer inquiries and provide updates.',
              ],
            ),
            _buildPolicySection(
              '3. Data Security & Protection',
              [
                'We protect personal data with secure encryption and access controls.',
                'Payment details are processed securely through third-party gateways.',
              ],
            ),
            _buildPolicySection(
              '4. Third-Party Sharing',
              [
                'We do not sell or rent personal data.',
                'We may share information with trusted service providers as necessary for operations.',
              ],
            ),
            _buildPolicySection(
              '5. Your Rights',
              [
                '✔ Request access to your data.',
                '✔ Request correction or deletion of personal data.',
                '✔ Opt-out of marketing communications.',
              ],
            ),
            _buildPolicySection(
              '6. Updates to Privacy Policy',
              [
                'Skytechiez may update this policy periodically.',
                'Continued use of our services after updates signifies acceptance of the revised policy.',
              ],
            ),
            _buildPolicySection(
              '7. Contact Us',
              [
                'For privacy-related inquiries, please contact us at info@skytechiez.co',
                'Call us at +1 (307) 217-8790.',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlue,
      ),
    );
  }

  // Widget _buildSubtitle(String subtitle) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8),
  //     child: Text(
  //       subtitle,
  //       style: const TextStyle(
  //         fontSize: 14,
  //         color: Colors.grey,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPolicySection(String title, List<String> content) {
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
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          ...content.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(color: AppColors.primaryBlue)),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
