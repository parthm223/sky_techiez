import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/models/ticket.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/services_screen.dart';
import 'package:sky_techiez/screens/subscriptions_screen.dart';
import 'package:sky_techiez/screens/ticket_details_screen.dart';

import 'package:sky_techiez/services/subscription_service.dart';
import 'package:sky_techiez/services/ticket_service.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Ticket? _latestTicket;
  bool _isLoadingTicket = true;
  bool _hasSubscription = false;
  bool _isCheckingSubscription = true;
  String? _tollFreeNumber;
  bool _isLoadingTollFreeNumber = false;

  @override
  void initState() {
    super.initState();
    _loadLatestTicket();
    _checkSubscriptionStatus();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    print('Starting to fetch settings...');
    setState(() {
      _isLoadingTollFreeNumber = true;
    });

    try {
      var headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };

      print('Headers: $headers');
      print('Making request to: https://tech.skytechiez.co/api/settings');

      var request = http.MultipartRequest(
          'GET', Uri.parse('https://tech.skytechiez.co/api/settings'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Raw API response: $responseBody');

        Map<String, dynamic> data = json.decode(responseBody);
        print('Parsed response data: $data');

        // Extract toll-free number from the nested structure
        String extractedNumber = '1-800-123-4567'; // Default fallback
        if (data['settings'] != null && data['settings'] is List) {
          for (var setting in data['settings']) {
            if (setting['key'] == 'toll_free_number') {
              extractedNumber = setting['value'] ?? extractedNumber;
              break;
            }
          }
        }

        print('Extracted toll-free number: $extractedNumber');

        if (mounted) {
          setState(() {
            _tollFreeNumber = extractedNumber;
            print('Toll-free number set to: $_tollFreeNumber');
          });
        }
      } else {
        print('API request failed with status: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');

        if (mounted) {
          setState(() {
            _tollFreeNumber = '1-800-123-4567';
            print('Using default toll-free number');
          });
        }
      }
    } catch (e) {
      print('Error in _fetchSettings: $e');
      if (mounted) {
        setState(() {
          _tollFreeNumber = '1-800-123-4567';
          print('Using default toll-free number due to error');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTollFreeNumber = false;
          print('Finished loading toll-free number');
        });
      }
    }
  }

  String _formatPhoneNumber(String number) {
    if (number.length == 10) {
      return '${number.substring(0, 3)}-${number.substring(3, 6)}-${number.substring(6)}';
    }
    return number;
  }

  Future<void> _checkSubscriptionStatus() async {
    setState(() {
      _isCheckingSubscription = true;
    });

    final hasSubscription = await SubscriptionService.hasActiveSubscription();

    if (mounted) {
      setState(() {
        _hasSubscription = hasSubscription;
        _isCheckingSubscription = false;
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

      if (mounted) {
        setState(() {
          // Use API tickets if available, otherwise use local tickets
          final allTickets = apiTickets.isNotEmpty ? apiTickets : localTickets;

          // Get the most recent ticket (assuming the first one is the latest)
          _latestTicket = allTickets.isNotEmpty ? allTickets.first : null;
          _isLoadingTicket = false;
        });

        // Debug logging for subcategory name
        if (_latestTicket != null && _latestTicket!.subcategoryName != null) {
          print(
              'Latest ticket has subcategory: ${_latestTicket!.subcategoryName}');
        } else if (_latestTicket != null) {
          print('Latest ticket has no subcategory name');
        }
      }
    } catch (e) {
      print('Error loading latest ticket: $e');
      // Fall back to local tickets if API fails
      final localTickets = TicketService.getAllTickets();
      if (mounted) {
        setState(() {
          _latestTicket = localTickets.isNotEmpty ? localTickets.first : null;
          _isLoadingTicket = false;
        });
      }
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
                      )
                    ],
                  ),
                  _buildTicketDetailRow(
                    'Subject:',
                    _latestTicket!.subject,
                  ),
                  _buildTicketDetailRow(
                    'Category:',
                    _latestTicket!.categoryName,
                  ),
                  // Add this code to display subcategory if available
                  if (_latestTicket!.subcategoryName != null)
                    _buildTicketDetailRow(
                      'Sub Category:',
                      _latestTicket!.subcategoryName,
                    ),
                  _buildTicketDetailRow(
                    'Priority:',
                    _latestTicket!.priority,
                  ),
                  _buildTicketDetailRow(
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
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
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
                      ),
                      const SizedBox(width: 10),
                      // Only show Close Ticket button if ticket status is Resolved
                      if (_latestTicket!.status == 'Resolved')
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _handleCloseTicket,
                            icon: const Icon(Icons.close),
                            label: const Text('Close Ticket'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ),
                    ],
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
                          _isCheckingSubscription
                              ? const Center(child: CircularProgressIndicator())
                              : _hasSubscription
                                  ? CustomButton(
                                      text: 'Create Ticket',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateTicketScreen(),
                                          ),
                                        ).then((_) {
                                          // Refresh ticket data when returning from create ticket screen
                                          _loadLatestTicket();
                                        });
                                      },
                                    )
                                  : Column(
                                      children: [
                                        const Icon(
                                          Icons.subscriptions,
                                          color: Colors.amber,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Subscription Required',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'You need an active subscription to create support tickets.',
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        CustomButton(
                                          text: 'View Subscription Plans',
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const SubscriptionsScreen(),
                                              ),
                                            ).then((_) {
                                              // Refresh subscription status when returning
                                              _checkSubscriptionStatus();
                                            });
                                          },
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
          ),
          const SizedBox(height: 16),
          // Replace the existing toll-free number Card widget with this:
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
                  _isLoadingTollFreeNumber
                      ? const CircularProgressIndicator()
                      : Text(
                          _isLoadingTollFreeNumber
                              ? 'Loading...'
                              : _formatPhoneNumber(
                                  _tollFreeNumber ?? '1-800-123-4567'),
                          style: const TextStyle(
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

  Widget _buildTicketDetailRow(String label, String? value) {
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
              value ?? 'Not specified',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCloseTicket() async {
    if (_latestTicket == null) return;

    setState(() {
      _isLoadingTicket = true;
    });

    try {
      var headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://tech.skytechiez.co/api/close-ticket/${_latestTicket!.id}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket closed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload the latest ticket to reflect the status change
        _loadLatestTicket();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to close ticket: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoadingTicket = false;
        });
      }
    } catch (e) {
      print('Error closing ticket: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error closing ticket: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoadingTicket = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.blue;
      case 'Pending':
        return Colors.orange;
      case 'Resolved':
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
      case 'Resolved':
        return Icons.check_circle;
      case 'New':
        return Icons.fiber_new;
      default:
        return Icons.info;
    }
  }
}
