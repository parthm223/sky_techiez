import 'package:flutter/material.dart';
import 'package:sky_techiez/screens/payment/subscriptions_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> paymentResult;
  final Map<String, dynamic> selectedPlan;

  const PaymentSuccessScreen({
    super.key,
    required this.paymentResult,
    required this.selectedPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Added SingleChildScrollView to fix overflow
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  48, // Account for padding
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(
                      height: 40), // Replace first Spacer with fixed height

                  // Success Animation Container
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryBlue,
                          AppColors.primaryBlue.withOpacity(0.7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 80,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Your subscription to ${selectedPlan['name']} has been activated successfully.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Payment Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Payment Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow('Plan', selectedPlan['name']),
                        _buildSummaryRow(
                            'Duration', '${selectedPlan['duration']} month(s)'),
                        _buildSummaryRow(
                            'Amount Paid', '\$${selectedPlan['price']}'),
                        if (paymentResult['data'] != null &&
                            paymentResult['data']['transaction_id'] != null)
                          _buildSummaryRow('Transaction ID',
                              paymentResult['data']['transaction_id']),
                        const Divider(color: AppColors.grey, height: 24),
                        _buildSummaryRow('Status', 'Active',
                            isHighlighted: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Confirmation Email Notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: AppColors.primaryBlue,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Confirmation Email Sent',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                'Check your email for payment confirmation and subscription details.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 40), // Replace second Spacer with fixed height

                  // Action Buttons
                  Column(
                    children: [
                      CustomButton(
                        text: 'View My Subscriptions',
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubscriptionsScreen(),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Back to Home',
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        isOutlined: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? AppColors.primaryBlue : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
