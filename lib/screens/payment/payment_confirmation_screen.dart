import 'package:flutter/material.dart';
import 'package:sky_techiez/models/payment_model.dart';
import 'package:sky_techiez/screens/payment/payment_success_screen.dart';

import 'package:sky_techiez/services/paymant_service.dart';

import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final PaymentData paymentData;
  final Map<String, dynamic> selectedPlan;

  const PaymentConfirmationScreen({
    super.key,
    required this.paymentData,
    required this.selectedPlan,
  });

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment'),
        backgroundColor: AppColors.cardBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Your Order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Plan Summary
            _buildSummaryCard(
              'Plan Details',
              [
                _buildSummaryRow('Plan Name', widget.selectedPlan['name']),
                _buildSummaryRow(
                    'Duration', '${widget.selectedPlan['duration']} month(s)'),
                _buildSummaryRow('Price', '\$${widget.selectedPlan['price']}'),
              ],
            ),

            const SizedBox(height: 16),

            // Payment Method
            _buildSummaryCard(
              'Payment Method',
              [
                _buildSummaryRow('Card Number',
                    '**** **** **** ${widget.paymentData.cardNumber.replaceAll(' ', '').substring(widget.paymentData.cardNumber.replaceAll(' ', '').length - 4)}'),
                _buildSummaryRow('Card Type',
                    PaymentService.getCardType(widget.paymentData.cardNumber)),
                _buildSummaryRow('Expires',
                    '${widget.paymentData.expMonth}/${widget.paymentData.expYear}'),
              ],
            ),

            const SizedBox(height: 16),

            // Billing Information
            _buildSummaryCard(
              'Billing Information',
              [
                _buildSummaryRow('Name',
                    '${widget.paymentData.firstName} ${widget.paymentData.lastName}'),
                _buildSummaryRow('Email', widget.paymentData.email),
                _buildSummaryRow('Address', widget.paymentData.address),
                _buildSummaryRow('City, State',
                    '${widget.paymentData.city}, ${widget.paymentData.state}'),
                _buildSummaryRow('ZIP Code', widget.paymentData.zip),
                if (widget.paymentData.country != null)
                  _buildSummaryRow('Country', widget.paymentData.country!),
              ],
            ),

            const SizedBox(height: 24),

            // Total
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryBlue),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    '\$${widget.selectedPlan['price']}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            if (_isProcessing)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryBlue),
                    SizedBox(height: 16),
                    Text(
                      'Processing your payment...',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
              )
            else
              CustomButton(
                text: 'Complete Payment',
                onPressed: _processPayment,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, List<Widget> children) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Payment Failed',
          style: TextStyle(color: AppColors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }
}
