import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Privacy Policy',
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
              const Center(
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Last Updated: May 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.blueGrey, thickness: 1),
              const SizedBox(height: 24),
              _buildPolicySection(
                '1. Information We Collect',
                'We collect the following types of information:',
                [
                  'Personal details: Name, contact information, and payment details',
                  'Technical data: Device specifications, system logs, and error reports',
                  'Usage data: Website analytics including IP addresses and cookies',
                ],
              ),
              _buildPolicySection(
                '2. How We Use Your Information',
                'Your data helps us to:',
                [
                  'Deliver and improve our technical support services',
                  'Process transactions and manage your account',
                  'Communicate important service updates and offers',
                ],
              ),
              _buildPolicySection(
                '3. Data Security & Protection',
                'We implement robust security measures:',
                [
                  'Enterprise-grade encryption for all stored data',
                  'Secure payment processing through PCI-compliant gateways',
                  'Regular security audits and vulnerability testing',
                ],
              ),
              _buildPolicySection(
                '4. Third-Party Sharing',
                'We value your privacy:',
                [
                  'We never sell or rent your personal information',
                  'Limited sharing only with essential service providers',
                  'Strict contracts ensure third-party compliance with our standards',
                ],
              ),
              _buildPolicySection(
                '5. Your Rights',
                'You have control over your data:',
                [
                  'Access and review your personal information',
                  'Request corrections or deletion of your data',
                  'Opt-out of marketing communications at any time',
                ],
              ),
              _buildPolicySection(
                '6. Policy Updates',
                'About changes to this policy:',
                [
                  'We may update this policy periodically',
                  'Continued service use constitutes acceptance of changes',
                  'Major changes will be communicated to users',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Privacy Questions?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                        Icons.email,
                        'Email our Data Protection Officer',
                        'privacy@skytechiez.co'),
                    _buildContactItem(Icons.phone, 'Call our Support Team',
                        '+1 (307) 217-8790'),
                    const SizedBox(height: 8),
                    const Text(
                      'We take your privacy seriously and are committed to protecting your personal information.',
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
          const SizedBox(height: 8),
          Text(
            intro,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 8),
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.blue.shade300,
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

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.blue.shade200,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade200,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
