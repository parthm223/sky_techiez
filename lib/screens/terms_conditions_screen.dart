import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Terms & Conditions',
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
                'Terms and Conditions',
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
              _buildTermsSection(
                '1. Services Provided',
                'Skytechiez offers professional technical support services, including but not limited to:',
                [
                  'Remote IT support',
                  'Computer and software troubleshooting',
                  'Network security solutions',
                  'Virus and malware removal',
                  'Data recovery and backup services',
                ],
              ),
              _buildTermsSection(
                '2. User Responsibilities',
                'By using our services, you agree to:',
                [
                  'Provide accurate and truthful information regarding your technical concerns',
                  'Ensure you have the legal authority to seek support for any device or software',
                  'Use our services only for lawful purposes and in compliance with IT security regulations',
                ],
              ),
              _buildTermsSection(
                '3. Payments & Billing',
                'Services are billed according to the selected plan or one-time service fee:',
                [
                  'Full payment must be made before service delivery unless otherwise agreed upon',
                  'Late payments may result in the suspension of services',
                  'All prices are in USD and subject to applicable taxes',
                ],
              ),
              _buildTermsSection(
                '4. Refund Policy',
                'Our refund policy includes:',
                [
                  'Refund requests must be made within 14 days of service',
                  'Certain services may be non-refundable once work has begun',
                  'See full Refund Policy section for detailed information',
                ],
              ),
              _buildTermsSection(
                '5. Limitation of Liability',
                'Important limitations:',
                [
                  'Skytechiez is not responsible for any data loss or system downtime',
                  'Customers are responsible for maintaining backups',
                  'Indirect damages are not covered by our liability',
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade700),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'For any questions regarding these Terms, please contact us at:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'support@skytechiez.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.w500,
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

  Widget _buildTermsSection(String title, String intro, List<String> points) {
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
}
