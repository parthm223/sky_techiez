import 'package:flutter/material.dart';
import 'package:sky_techiez/models/ticket.dart';
import 'package:sky_techiez/screens/book_appointment_screen.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/services_screen.dart';
import 'package:sky_techiez/screens/subscriptions_screen.dart';
import 'package:sky_techiez/screens/ticket_details_screen.dart';
import 'package:sky_techiez/services/appointment_service.dart';
import 'package:sky_techiez/services/ticket_service.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Map<String, dynamic>? _latestAppointment;
  Ticket? _latestTicket;
  bool _isLoadingTicket = true;

  @override
  void initState() {
    super.initState();
    _loadAppointmentDetails();
    _loadLatestTicket();
  }

  void _loadAppointmentDetails() {
    final appointmentData = AppointmentService.getAppointment();
    if (appointmentData != null) {
      setState(() {
        _latestAppointment = appointmentData;
      });
    }
  }

  void _loadLatestTicket() async {
    setState(() {
      _isLoadingTicket = true;
    });

    try {
      // First try to fetch from API
      final apiTickets = await TicketService.fetchTicketsFromApi();

      // Get local tickets as fallback
      final localTickets = TicketService.getAllTickets();

      setState(() {
        // Use API tickets if available, otherwise use local tickets
        final allTickets = apiTickets.isNotEmpty ? apiTickets : localTickets;

        // Get the most recent ticket (assuming the first one is the latest)
        _latestTicket = allTickets.isNotEmpty ? allTickets.first : null;
        _isLoadingTicket = false;
      });
    } catch (e) {
      print('Error loading latest ticket: $e');
      // Fall back to local tickets if API fails
      final localTickets = TicketService.getAllTickets();
      setState(() {
        _latestTicket = localTickets.isNotEmpty ? localTickets.first : null;
        _isLoadingTicket = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Welcome To',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/SkyLogo.png',
                  height: 100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(),
          const SizedBox(height: 16),

          // Display appointment details if available
          if (_latestAppointment != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryBlue, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Upcoming Appointment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            size: 18, color: AppColors.grey),
                        onPressed: () {
                          setState(() {
                            _latestAppointment = null;
                            AppointmentService.clearAppointment();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildAppointmentDetailRow(
                    'Issue Type:',
                    _latestAppointment!['issue_type'] ?? 'N/A',
                  ),
                  _buildAppointmentDetailRow(
                    'Issue:',
                    _latestAppointment!['issue'] ?? 'N/A',
                  ),
                  _buildAppointmentDetailRow(
                    'Date & Time:',
                    '${_latestAppointment!['date'] ?? 'N/A'} at ${_latestAppointment!['time'] ?? 'N/A'}',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.hourglass_top,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _latestAppointment!['status'] ?? 'Status',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Display latest ticket if available
          if (_latestTicket != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Latest Ticket',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.visibility,
                      //       size: 18, color: AppColors.grey),
                      //   onPressed: () {
                      //     // Navigate to ticket details
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => TicketDetailsScreen(
                      //           ticketData: _latestTicket!.toJson(),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                  _buildAppointmentDetailRow(
                    'Subject:',
                    _latestTicket!.subject,
                  ),
                  _buildAppointmentDetailRow(
                    'Category:',
                    _latestTicket!.category,
                  ),
                  _buildAppointmentDetailRow(
                    'Priority:',
                    _latestTicket!.priority,
                  ),
                  _buildAppointmentDetailRow(
                    'Date:',
                    _latestTicket!.date,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _getStatusIcon(_latestTicket!.status),
                        color: _getStatusColor(_latestTicket!.status),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _latestTicket!.status,
                        style: TextStyle(
                          color: _getStatusColor(_latestTicket!.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailsScreen(
                            ticketData: _latestTicket!.toJson(),
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple,
                    ),
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ] else if (_isLoadingTicket) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(2, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      [Icons.computer, Icons.cloud][index],
                      size: 42,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ['IT Services', 'Cloud Solutions'][index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const Text(
            'WHAT WE\'RE OFFERING',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: AppColors.cardBackground,
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      [
                        Icons.design_services,
                        Icons.support_agent,
                        Icons.subscriptions
                      ][index],
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  title: Text(
                    [
                      'Design Service',
                      'Support Service',
                      'Premium Subscription'
                    ][index],
                    style: const TextStyle(color: AppColors.white),
                  ),
                  subtitle: Text(
                    [
                      'Get custom designs',
                      'Get 24/7 support',
                      'Unlock premium features'
                    ][index],
                    style: const TextStyle(color: AppColors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppColors.grey),
                  onTap: () {
                    // Navigation logic based on index
                    if (index == 1) {
                      // Second item (index 1 is "Support Service")
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServicesScreen()),
                      );
                    } else if (index == 2) {
                      // Last item (index 2 is "Premium Subscription")
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionsScreen()),
                      );
                    }
                    // Index 0 ("Design Service") doesn't navigate anywhere in this example
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            color: AppColors.cardBackground,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a support ticket and our team will assist you',
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Create Ticket',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateTicketScreen(),
                        ),
                      ).then((_) {
                        // Refresh ticket data when returning from create ticket screen
                        _loadLatestTicket();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: AppColors.cardBackground,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Toll Free Number',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Call us for free at',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1-800-123-4567',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.blue;
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'New':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'In Progress':
        return Icons.pending_actions;
      case 'Pending':
        return Icons.hourglass_empty;
      case 'Completed':
        return Icons.check_circle;
      case 'New':
        return Icons.fiber_new;
      default:
        return Icons.info;
    }
  }
}
