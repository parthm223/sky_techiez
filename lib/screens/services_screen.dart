import 'package:flutter/material.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/subscriptions_screen.dart';
import 'package:sky_techiez/services/subscription_service.dart';

import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool _hasSubscription = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    setState(() {
      _isLoading = true;
    });

    final hasSubscription = await SubscriptionService.hasActiveSubscription();

    if (mounted) {
      setState(() {
        _hasSubscription = hasSubscription;
        _isLoading = false;
      });
    }
  }

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
            Center(
              child: Image.asset(
                'assets/images/SkyLogo.png',
                height: 120,
              ),
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Desktop Support',
              'Troubleshooting and resolving issues related to desktop computers',
              Icons.computer,
              [
                'Hardware repair and replacement',
                'Software installation and updates',
                'Troubleshooting system errors',
                'Virus and malware removal',
                'Performance optimization',
                'Support for peripheral devices',
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Wireless Printer Setup',
              'Configuring printers to connect to your network via Wi-Fi',
              Icons.print,
              [
                'Installation and configuration of wireless printers',
                'Connecting the printer to Wi-Fi networks',
                'Ensuring seamless communication between printers and devices',
                'Troubleshooting printer connection issues',
                'Setting up printer sharing within a network',
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Quicken Support',
              'Help with installation, setup, and troubleshooting of Quicken',
              Icons.account_balance_wallet,
              [
                'Installation and initial setup of Quicken software',
                'Troubleshooting syncing issues with bank accounts',
                'Error resolution and bug fixes',
                'Assistance with budgeting tools and reports',
                'Help with software upgrades and updates',
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'QuickBooks Support',
              'Assistance with QuickBooks accounting software',
              Icons.book,
              [
                'QuickBooks installation and setup for businesses',
                'Troubleshooting and error resolution',
                'Assistance with invoice creation and payroll management',
                'Help with data imports, exports, and integrations',
                'Support for both Desktop and Online versions',
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Antivirus Support',
              'Protection from viruses, malware, and cyber threats',
              Icons.security,
              [
                'Installation and configuration of antivirus software',
                'Regular updates to protect against latest threats',
                'Malware and virus removal from infected systems',
                'Setting up real-time protection and scheduled scans',
                'Troubleshooting conflicts with antivirus software',
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Printer Support',
              'Installation, maintenance, and troubleshooting of all printer types',
              Icons.print,
              [
                'Printer installation and setup (wired and wireless)',
                'Troubleshooting common printing issues',
                'Replacing printer cartridges and toner',
                'Configuring print settings and options',
                'Ongoing maintenance and cleaning tips',
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Office 365 Support',
              'Assistance with Microsoft Office suite services',
              Icons.article,
              [
                'Office 365 account setup and management',
                'Troubleshooting issues with applications',
                'Resolving syncing problems with OneDrive',
                'Assistance with collaboration tools',
                'Managing user permissions and licenses',
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Outlook Support',
              'Configuring, troubleshooting, and managing Microsoft Outlook',
              Icons.email,
              [
                'Setting up Outlook with various email accounts',
                'Troubleshooting email synchronization issues',
                'Managing inbox organization and spam filtering',
                'Assisting with calendar setup and integration',
                'Providing tips for effective Outlook use',
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
                            child: Card(
                                color: AppColors.cardBackground,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        _isLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : _hasSubscription
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: CustomButton(
                                                          text: 'Create Ticket',
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const CreateTicketScreen(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      const Icon(
                                                        Icons.subscriptions,
                                                        color: Colors.amber,
                                                        size: 48,
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      const Text(
                                                        'Subscription Required',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      const Text(
                                                        'You need an active subscription to create support tickets.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: AppColors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      CustomButton(
                                                        text:
                                                            'View Subscription Plans',
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
                                      ]),
                                )))
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
                        // Expanded(
                        //   child: CustomButton(
                        //     text: 'Book Appointment',
                        //     onPressed: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) =>
                        //               const BookAppointmentScreen(),
                        //         ),
                        //       );
                        //     },
                        //     isOutlined: true,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'New Technologies',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The company specializes in delivering exceptional technology services and solutions for businesses of all sizes. It has over 1 million satisfied users across various industries.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'SkyTechiez outlines its service terms and conditions, emphasizing its commitment to delivering exceptional technology services and solutions for businesses of all sizes. Overall, SkyTechiez positions itself as a comprehensive tech support provider, addressing various technological needs to ensure smooth and efficient operations for its clients.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(color: AppColors.white),
                        ),
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
