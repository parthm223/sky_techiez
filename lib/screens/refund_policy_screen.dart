import 'package:flutter/material.dart';
import 'package:sky_techiez/theme/app_theme.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refund Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Refund Policy',
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
              'Overview',
              'This Refund Policy outlines the terms and conditions for refunds on purchases made through Sky Techiez. By using our services, you agree to the terms of this policy.',
            ),
            _buildPolicySection(
              'Subscription Refunds',
              'We offer a 7-day money-back guarantee for all subscription plans. If you are not satisfied with our service, you can request a refund within 7 days of your purchase. After this period, no refunds will be provided for subscription fees.',
            ),
            _buildPolicySection(
              'Service Refunds',
              'For one-time services, refunds may be issued under the following conditions:\n\n'
                  '• The service was not delivered as described\n'
                  '• The service was not completed within the agreed timeframe\n'
                  '• Technical issues prevented the service from being delivered properly\n\n'
                  'Refund requests for services must be submitted within 14 days of the service delivery date.',
            ),
            _buildPolicySection(
              'Product Refunds',
              'For physical products, we offer a 30-day return policy. Products must be returned in their original condition and packaging. Shipping costs for returns are the responsibility of the customer unless the return is due to our error.',
            ),
            _buildPolicySection(
              'How to Request a Refund',
              'To request a refund, please contact our customer support team through one of the following methods:\n\n'
                  '• Email: refunds@skytechiez.com\n'
                  '• Phone: +1 123-456-7890\n'
                  '• Create a support ticket in your account\n\n'
                  'Please include your order number, purchase date, and reason for the refund request.',
            ),
            _buildPolicySection(
              'Refund Processing',
              'Refunds will be processed within 5-7 business days after approval. The refund will be issued to the original payment method used for the purchase. Processing times may vary depending on your payment provider.',
            ),
            _buildPolicySection(
              'Exceptions',
              'We reserve the right to deny refund requests that do not comply with this policy or are deemed to be fraudulent or abusive. Custom services and products that were created specifically for a customer are generally non-refundable.',
            ),
            _buildPolicySection(
              'Policy Changes',
              'We may update this Refund Policy from time to time. Any changes will be posted on this page with an updated "Last Updated" date.',
            ),
            _buildPolicySection(
              'Contact Us',
              'If you have any questions about our Refund Policy, please contact us at support@skytechiez.com.',
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
