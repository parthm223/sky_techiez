import 'package:flutter/material.dart';
import 'package:sky_techiez/models/payment_model.dart';
import 'package:sky_techiez/screens/payment/payment_success_screen.dart';

import 'package:sky_techiez/services/paymant_service.dart';

import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class PaymentReviewScreen extends StatefulWidget {
  final PaymentData paymentData;
  final Map<String, dynamic> selectedPlan;

  const PaymentReviewScreen({
    super.key,
    required this.paymentData,
    required this.selectedPlan,
  });

  @override
  State<PaymentReviewScreen> createState() => _PaymentReviewScreenState();
}

class _PaymentReviewScreenState extends State<PaymentReviewScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Payment'),
        backgroundColor: AppColors.cardBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Your Order',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Plan Details
            _buildReviewCard(
              'Plan Details',
              Icons.subscriptions,
              [
                _buildReviewRow('Plan Name', widget.selectedPlan['name']),
                _buildReviewRow(
                    'Duration', '${widget.selectedPlan['duration']} month(s)'),
                _buildReviewRow(
                    'Description', widget.selectedPlan['description'] ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 16),

            // Payment Method
            _buildReviewCard(
              'Payment Method',
              Icons.credit_card,
              [
                _buildReviewRow('Card Number',
                    '**** **** **** ${widget.paymentData.cardNumber.replaceAll(' ', '').substring(widget.paymentData.cardNumber.replaceAll(' ', '').length - 4)}'),
                _buildReviewRow('Card Type',
                    PaymentService.getCardType(widget.paymentData.cardNumber)),
                _buildReviewRow('Expires',
                    '${widget.paymentData.expMonth}/${widget.paymentData.expYear}'),
              ],
            ),

            const SizedBox(height: 16),

            // Personal Information
            _buildReviewCard(
              'Personal Information',
              Icons.person,
              [
                _buildReviewRow('Name',
                    '${widget.paymentData.firstName} ${widget.paymentData.lastName}'),
                _buildReviewRow('Email', widget.paymentData.email),
                if (widget.paymentData.phone != null)
                  _buildReviewRow('Phone', widget.paymentData.phone!),
              ],
            ),

            const SizedBox(height: 16),

            // Billing Address
            _buildReviewCard(
              'Billing Address',
              Icons.home,
              [
                _buildReviewRow('Address', widget.paymentData.address),
                _buildReviewRow('City', widget.paymentData.city),
                _buildReviewRow('State', widget.paymentData.state),
                _buildReviewRow('ZIP Code', widget.paymentData.zip),
                if (widget.paymentData.country != null)
                  _buildReviewRow('Country', widget.paymentData.country!),
              ],
            ),

            const SizedBox(height: 24),

            // Total Amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBlue.withOpacity(0.1),
                    AppColors.primaryBlue.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryBlue, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.selectedPlan['price']}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'for ${widget.selectedPlan['duration']} month(s)',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Security Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: AppColors.primaryBlue, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Secure Payment',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'Your payment information is encrypted and secure',
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

            const SizedBox(height: 32),

            // Payment Button
            if (_isProcessing)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: const Column(
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryBlue),
                    SizedBox(height: 16),
                    Text(
                      'Processing your payment...',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grey,
                      ),
                    ),
                    Text(
                      'Please do not close this screen',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              )
            else
              CustomButton(
                text: 'Complete Payment - \$${widget.selectedPlan['price']}',
                onPressed: _processPayment,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String title, IconData icon, List<Widget> children) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await PaymentService.processPayment(
        cardNumber: widget.paymentData.cardNumber,
        expMonth: widget.paymentData.expMonth,
        expYear: widget.paymentData.expYear,
        cvv: widget.paymentData.cvv,
        planId: widget.paymentData.planId,
        firstName: widget.paymentData.firstName,
        lastName: widget.paymentData.lastName,
        email: widget.paymentData.email,
        address: widget.paymentData.address,
        city: widget.paymentData.city,
        state: widget.paymentData.state,
        zip: widget.paymentData.zip,
        country: widget.paymentData.country,
        phone: widget.paymentData.phone,
      );

      if (mounted) {
        if (result['success']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(
                paymentResult: result,
                selectedPlan: widget.selectedPlan,
              ),
            ),
          );
        } else {
          _showErrorDialog(result['message'] ?? 'Payment failed');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('An unexpected error occurred');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text(
              'Payment Failed',
              style: TextStyle(color: AppColors.white),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Try Again',
              style: TextStyle(color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }
}
