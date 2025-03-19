import 'package:flutter/material.dart';
import 'package:sky_techiez/theme/app_theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 200,
                width: double.infinity,
                color: AppColors.primaryBlue,
                child: const Center(
                  child: Icon(
                    Icons.business,
                    size: 64,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Story',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sky Techiez was founded in 2020 with a mission to provide innovative technology solutions to businesses and individuals. Our team of experts is dedicated to delivering high-quality services and products that meet the evolving needs of our clients.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To empower businesses and individuals with cutting-edge technology solutions that drive growth, efficiency, and innovation.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Vision',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To be the leading provider of technology solutions, recognized for our excellence, innovation, and customer-centric approach.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Team',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              'John Doe',
              'CEO & Founder',
              'John has over 15 years of experience in the technology industry and is passionate about innovation.',
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              'Jane Smith',
              'CTO',
              'Jane leads our technical team and ensures that we stay at the forefront of technological advancements.',
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              'Mike Johnson',
              'Head of Customer Support',
              'Mike is dedicated to providing exceptional customer service and ensuring client satisfaction.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildContactItem(Icons.email, 'Email', 'info@skytechiez.com'),
            _buildContactItem(Icons.phone, 'Phone', '+1 123-456-7890'),
            _buildContactItem(Icons.location_on, 'Address',
                '123 Tech Street, Silicon Valley, CA'),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String position, String bio) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 30,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    position,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
