import 'package:flutter/material.dart';
import 'package:sky_techiez/models/ticket.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/subscriptions_screen.dart';
import 'package:sky_techiez/screens/ticket_details_screen.dart';
import 'package:sky_techiez/services/appointment_service.dart';
import 'package:sky_techiez/services/comment_service.dart';
import 'package:sky_techiez/services/subscription_service.dart';
import 'package:sky_techiez/services/ticket_service.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/widgets/session_string.dart';
import 'package:http/http.dart' as http;

class TicketStatusScreen extends StatefulWidget {
  const TicketStatusScreen({super.key});

  @override
  State<TicketStatusScreen> createState() => _TicketStatusScreenState();
}

class _TicketStatusScreenState extends State<TicketStatusScreen> {
  Map<String, dynamic>? _latestAppointment;
  List<Ticket> _userTickets = [];
  bool _isLoading = true;
  bool _hasSubscription = false;
  bool _isCheckingSubscription = true;

  @override
  void initState() {
    super.initState();
    _loadAppointmentDetails();
    _loadUserTickets();
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    setState(() {
      _isCheckingSubscription = true;
    });

    try {
      final hasSubscription = await SubscriptionService.hasActiveSubscription();

      if (mounted) {
        setState(() {
          _hasSubscription = hasSubscription;
          _isCheckingSubscription = false;
        });
      }
    } catch (e) {
      print('Error checking subscription: $e');
      if (mounted) {
        setState(() {
          _hasSubscription = false;
          _isCheckingSubscription = false;
        });
      }
    }
  }

  void _loadAppointmentDetails() {
    final appointmentData = AppointmentService.getAppointment();
    if (appointmentData != null && mounted) {
      setState(() {
        _latestAppointment = appointmentData;
        print("_latestAppointment ====================> $_latestAppointment");
      });
    }
  }

  void _loadUserTickets() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // First try to fetch from API
      final apiTickets = await TicketService.fetchTicketsFromApi();

      if (!mounted) return;

      // This check is already here, which is good
      setState(() {
        _userTickets = apiTickets;
        // If no tickets from API, fall back to local tickets
        if (_userTickets.isEmpty) {
          _userTickets = TicketService.getAllTickets();
        }
        _isLoading = false;
      });

      // Debug logging for subcategories
      if (mounted) {
        // Add this check here
        for (var ticket in _userTickets) {
          if (ticket.subcategoryName != null) {
            print(
                'Ticket ${ticket.id} has subcategory: ${ticket.subcategoryName}');
          } else {
            print('Ticket ${ticket.id} has no subcategory name');
          }
        }
      }

      print('Loaded ${_userTickets.length} tickets');
    } catch (e) {
      print('Error loading tickets: $e');
      // Fall back to local tickets if API fails
      if (!mounted) return;

      setState(() {
        _userTickets = TicketService.getAllTickets();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Status'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await _checkSubscriptionStatus();
              },
              child: SingleChildScrollView(
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

                    // Display appointment as a ticket if available
                    if (_latestAppointment != null)
                      _buildAppointmentCard(
                        context,
                        _latestAppointment!['id'] ?? 'APT-2023-001',
                        'Appointment: ${_latestAppointment!['issue_type']}',
                        _latestAppointment!['status'] ?? 'Scheduled',
                        _latestAppointment!['date'] ?? 'N/A',
                        'Medium',
                        _latestAppointment!['issue'] ?? 'N/A',
                        true,
                      ),

                    // Display user created tickets
                    if (_userTickets.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Your Tickets',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._userTickets.map((ticket) {
                        return Column(
                          children: [
                            _buildTicketCard(
                              context,
                              ticket.id ?? 0,
                              ticket.ticketId,
                              ticket.subject,
                              ticket.status,
                              ticket.date,
                              ticket.priority,
                              ticket.description,
                              _latestAppointment == null &&
                                  _userTickets.indexOf(ticket) == 0,
                              isCompleted: ticket.status == 'Completed',
                              ticketData: ticket.toJson(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                    ],

                    const SizedBox(height: 24),

                    // Create Ticket Section
                    _isCheckingSubscription
                        ? const Center(child: CircularProgressIndicator())
                        : _hasSubscription
                            ? CustomButton(
                                text: 'Create New Ticket',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateTicketScreen(),
                                    ),
                                  ).then((_) {
                                    // Refresh tickets when returning from create ticket screen
                                    _loadUserTickets();
                                  });
                                },
                              )
                            : Card(
                                color: AppColors.cardBackground,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'You need an active subscription to create support tickets.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.grey,
                                        ),
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
                                ),
                              ),
                  ],
                ),
              ),
            ),
    );
  }

  // ... rest of the widget methods remain the same as in your original code
  Widget _buildAppointmentCard(
    BuildContext context,
    String appointmentId,
    String subject,
    String status,
    String date,
    String priority,
    String details,
    bool isActive,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to appointment details screen when tapped
        if (_latestAppointment != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketDetailsScreen(
                ticketData: _latestAppointment!,
              ),
            ),
          );
        }
      },
      child: Card(
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
                    appointmentId,
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
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTicketInfo('Date', date),
                  const SizedBox(width: 24),
                  _buildTicketInfo(
                      'Time', _latestAppointment?['time'] ?? 'N/A'),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.lightGrey),
              const SizedBox(height: 8),
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                details,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Reschedule'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            _latestAppointment = null;
                            AppointmentService.clearAppointment();
                          });
                        }
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              // View Details Button
              const SizedBox(height: 10),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    if (_latestAppointment != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailsScreen(
                            ticketData: _latestAppointment!,
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Details'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    int id,
    String ticketId,
    String subject,
    String status,
    String date,
    String priority,
    String lastUpdate,
    bool isActive, {
    bool isCompleted = false,
    Map<String, dynamic>? ticketData,
  }) {
    Color statusColor;
    if (status == 'In Progress') {
      statusColor = Colors.blue;
    } else if (status == 'Pending') {
      statusColor = Colors.orange;
    } else if (status == 'Completed') {
      statusColor = Colors.green;
    } else if (status == 'New') {
      statusColor = Colors.purple;
    } else {
      statusColor = Colors.grey;
    }

    // Prepare ticket data for details screen
    final Map<String, dynamic> detailsData = ticketData ??
        {
          'subject': subject,
          'category': 'Support',
          'priority': priority,
          'description': lastUpdate,
          'id': ticketId,
          'status': status,
          'date': date,
        };

    return GestureDetector(
      onTap: () {
        // Navigate to ticket details screen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailsScreen(
              ticketData: detailsData,
            ),
          ),
        );
      },
      child: Card(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  if (ticketData != null &&
                      ticketData['subcategory_name'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Subcategory: ${ticketData['subcategory_name']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                ],
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketDetailsScreen(
                                ticketData: detailsData,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (status == 'Resolved')
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // Store a reference to the current context
                            final currentContext = context;

                            // Show comment dialog before closing ticket
                            final TextEditingController commentController =
                                TextEditingController();

                            // Check if widget is still mounted before showing dialog
                            if (!mounted) return;

                            await showDialog(
                              context: currentContext,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  backgroundColor: AppColors.cardBackground,
                                  title: const Text(
                                    'Add Closing Comment',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Please add a comment before closing this ticket:',
                                        style: TextStyle(color: AppColors.grey),
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: commentController,
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                          hintText:
                                              'Enter your comment here...',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.black12,
                                          hintStyle:
                                              TextStyle(color: AppColors.grey),
                                        ),
                                        style: const TextStyle(
                                            color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext)
                                            .pop(); // Close dialog
                                      },
                                      child: const Text('Cancel',
                                          style:
                                              TextStyle(color: AppColors.grey)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop(
                                            commentController
                                                .text); // Close dialog and return comment
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryBlue,
                                      ),
                                      child: const Text('Send'),
                                    ),
                                  ],
                                );
                              },
                            ).then((comment) async {
                              // Check if widget is still mounted and comment is not null
                              if (!mounted || comment == null) return;

                              // Show loading indicator
                              ScaffoldMessenger.of(currentContext).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );

                              try {
                                // First add the comment
                                if (comment.isNotEmpty) {
                                  await CommentService.addComment(
                                      id.toString(), comment);
                                }

                                // Check if widget is still mounted
                                if (!mounted) return;

                                // Then close the ticket
                                var headers = {
                                  'X-Requested-With': 'XMLHttpRequest',
                                  'Authorization':
                                      (GetStorage().read(tokenKey) ?? '')
                                          .toString(),
                                };
                                var request = http.MultipartRequest(
                                    'POST',
                                    Uri.parse(
                                        'https://tech.skytechiez.co/api/close-ticket/$id'));
                                request.headers.addAll(headers);
                                http.StreamedResponse response =
                                    await request.send();

                                // Check if widget is still mounted
                                if (!mounted) return;

                                if (response.statusCode == 200) {
                                  print(await response.stream.bytesToString());
                                  ScaffoldMessenger.of(currentContext)
                                      .showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Ticket closed successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // Reload tickets to reflect the status change
                                  _loadUserTickets();
                                } else {
                                  print(response.reasonPhrase);
                                  ScaffoldMessenger.of(currentContext)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to close ticket'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (e) {
                                // Check if widget is still mounted
                                if (!mounted) return;

                                print('Error processing ticket: $e');
                                ScaffoldMessenger.of(currentContext)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                          },
                          icon: const Icon(Icons.close),
                          label: const Text('Close Ticket'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      )
                  ],
                )
              else
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailsScreen(
                            ticketData: detailsData,
                          ),
                        ),
                      );
                    },
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
