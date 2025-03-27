import 'package:flutter/material.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Refund Policy'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Refund Policy – Skytechiez',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
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
              '1. Eligibility for Refunds',
              'Refunds may be issued in the following cases:\n\n'
                  '- **Service Non-Delivery:** If Skytechiez cannot deliver the requested service.\n'
                  '- **Service Dissatisfaction:** If unsatisfied with the service, report it within 7 days of completion.',
            ),
            _buildPolicySection(
              '2. Non-Refundable Services',
              '• Fully completed services are non-refundable.\n'
                  '• Subscription-based plans after the first 7 days.\n'
                  '• Issues caused by pre-existing device conditions beyond our control.',
            ),
            _buildPolicySection(
              '3. Cancellation Policy',
              '• One-time services can be canceled before they start for a full refund.\n'
                  '• Subscription cancellations must be made before the next billing cycle.',
            ),
            _buildPolicySection(
              '4. Refund Processing',
              '• Refunds are processed within **7-10 business days**.\n'
                  '• Processing time depends on the bank or payment provider.',
            ),
            _buildPolicySection(
              '5. Contact for Refunds',
              '📧 **Email:** info@skytechiez.co\n'
                  '📞 **Phone:** +1 (307) 217-8790\n\n'
                  'For any refund-related queries, feel free to contact our support team.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
