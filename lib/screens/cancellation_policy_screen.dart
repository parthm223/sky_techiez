import 'package:flutter/material.dart';

class CancellationPolicyScreen extends StatelessWidget {
  const CancellationPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Cancellation Policy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF0A0E21)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/SkyLogo.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cancellation Policy',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Last Updated: May 2024',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.blueGrey, thickness: 1),
              const SizedBox(height: 24),
              _buildPolicySection(
                'No Refund Policy',
                'Sky Techiez does not offer refunds for any services, including one-time services or subscription-based plans. Once a service is activated or delivered, the payment is considered final and non-refundable.',
                [],
              ),
              _buildPolicySection(
                'Subscription Cancellation',
                'Customers may cancel their active subscription at any time.',
                [
                  'Cancellations will stop future billing starting from the next cycle.',
                  'Services will continue until the end of the current paid term.',
                ],
              ),
              _buildPolicySection(
                'Non-Refundable Circumstances',
                'The following are not eligible for refunds:',
                [
                  'Services that have been delivered or completed.',
                  'Subscription plans after activation.',
                  'Issues caused by pre-existing device problems or third-party interference.',
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade700),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(Icons.email, 'info@skytechiez.co'),
                    _buildContactItem(Icons.phone, '+1 (888) 785-8705'),
                    const SizedBox(height: 8),
                    const Text(
                      'For cancellation requests or account-related queries, contact Sky Techiez Support.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String intro, List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade300,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            intro,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6, right: 8),
                      child: Icon(
                        Icons.circle,
                        size: 6,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade200),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
