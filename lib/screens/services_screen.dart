import 'package:flutter/material.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/book_appointment_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Services',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Technical Support',
              'Get help with technical issues',
              Icons.support_agent,
              [
                'Remote troubleshooting',
                'Software installation',
                'Hardware diagnostics',
                'Network setup',
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Consultation',
              'Expert advice for your tech needs',
              Icons.people,
              [
                'IT strategy planning',
                'System architecture',
                'Security assessment',
                'Performance optimization',
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Installation & Setup',
              'Professional installation services',
              Icons.settings_suggest,
              [
                'Hardware installation',
                'Software configuration',
                'Network setup',
                'System integration',
              ],
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need Assistance?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Create Ticket',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateTicketScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Call Now',
                            onPressed: () {},
                            isOutlined: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Book Appointment',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BookAppointmentScreen(),
                                ),
                              );
                            },
                            isOutlined: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    List<String> features,
  ) {
    return Card(
      elevation: 2,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
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
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.lightGrey),
            const SizedBox(height: 8),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        feature,
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Learn More',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
