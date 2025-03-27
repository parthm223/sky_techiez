import 'package:flutter/material.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class TicketStatusScreen extends StatelessWidget {
  const TicketStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Status'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/SkyLogo.png',
                height: 120,
              ),
            ),
            const SizedBox(height: 24),
            _buildTicketCard(
              context,
              'TKT-2023-001',
              'Technical Issue with Login',
              'In Progress',
              'Mar 15, 2023',
              'High',
              'Your ticket is being reviewed by our technical team.',
              true,
            ),
            const SizedBox(height: 16),
            _buildTicketCard(
              context,
              'TKT-2023-002',
              'Billing Inquiry',
              'Pending',
              'Mar 18, 2023',
              'Medium',
              'Waiting for additional information from you.',
              false,
            ),
            const SizedBox(height: 16),
            _buildTicketCard(
              context,
              'TKT-2023-003',
              'Feature Request',
              'Completed',
              'Mar 10, 2023',
              'Low',
              'Your request has been implemented in the latest update.',
              false,
              isCompleted: true,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Create New Ticket',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTicketScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    String ticketId,
    String subject,
    String status,
    String date,
    String priority,
    String lastUpdate,
    bool isActive, {
    bool isCompleted = false,
  }) {
    Color statusColor;
    if (status == 'In Progress') {
      statusColor = Colors.blue;
    } else if (status == 'Pending') {
      statusColor = Colors.orange;
    } else if (status == 'Completed') {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isActive
            ? const BorderSide(color: AppColors.primaryBlue, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticketId,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subject,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTicketInfo('Date', date),
                const SizedBox(width: 24),
                _buildTicketInfo('Priority', priority),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.lightGrey),
            const SizedBox(height: 8),
            const Text(
              'Last Update',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lastUpdate,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 16),
            if (!isCompleted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh),
                      label: const Text('Update'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Adds spacing between buttons
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                      label: const Text('Close Ticket'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              )
            else
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
