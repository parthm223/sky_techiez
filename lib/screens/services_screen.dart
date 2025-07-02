import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/models/service_model.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/subscriptions_screen.dart';
import 'package:sky_techiez/services/service_api.dart';
import 'package:sky_techiez/services/subscription_service.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/session_string.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool _hasSubscription = false;
  bool _isLoading = true;
  List<Service> _services = [];
  bool _loadingServices = true;
  String _errorMessage = '';
  bool _isLoadingTollFree = false;
  String? _tollFreeNumber;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
    _fetchServices();
    _fetchTollFreeNumber();
  }

  Future<void> _fetchTollFreeNumber() async {
    setState(() {
      _isLoadingTollFree = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://tech.skytechiez.co/api/settings'),
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['settings'] is List) {
          for (var item in data['settings']) {
            if (item['key'] == 'toll_free_number') {
              _tollFreeNumber = item['value'];
              break;
            }
          }
        }
      } else {
        print('Failed to load toll-free number');
      }
    } catch (e) {
      print('Error: $e');
    }

    if (mounted) {
      setState(() {
        _isLoadingTollFree = false;
      });
    }
  }

  void _launchDialer(String number) async {
    final Uri telUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open dialer')),
      );
    }
  }

  Future<void> _checkSubscriptionStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final hasSubscription = await SubscriptionService.hasActiveSubscription();

      if (mounted) {
        setState(() {
          _hasSubscription = hasSubscription;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error checking subscription: $e');
      if (mounted) {
        setState(() {
          _hasSubscription = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchServices() async {
    setState(() {
      _loadingServices = true;
      _errorMessage = '';
    });

    try {
      final services = await ServiceApi.getServices();

      if (mounted) {
        setState(() {
          _services = services;
          _loadingServices = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load services. Please try again later.';
          _loadingServices = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: () async {
              await _fetchServices();
              await _checkSubscriptionStatus();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
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

                      // Services List
                      _loadingServices
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _errorMessage.isNotEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.error_outline,
                                            size: 48, color: Colors.red),
                                        const SizedBox(height: 16),
                                        Text(
                                          _errorMessage,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: _fetchServices,
                                          child: const Text('Try Again'),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : _services.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(32.0),
                                        child: Text(
                                          'No services available at the moment.',
                                          style:
                                              TextStyle(color: AppColors.grey),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: _services
                                          .map((service) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16),
                                                child: _buildServiceCard(
                                                  context,
                                                  service,
                                                ),
                                              ))
                                          .toList(),
                                    ),

                      const SizedBox(height: 24),
                      Expanded(
                        child: Card(
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
                                _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
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
                                                        builder: (context) =>
                                                            const CreateTicketScreen(),
                                                      ),
                                                    ).then((_) {
                                                      // Refresh subscription status when returning
                                                      _checkSubscriptionStatus();
                                                    });
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
                                              const SizedBox(height: 16),
                                              const Text(
                                                'Subscription Required',
                                                style: TextStyle(
                                                  fontSize: 16,
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
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        text: 'Call Now',
                                        onPressed: _isLoadingTollFree ||
                                                _tollFreeNumber == null
                                            ? null
                                            : () =>
                                                _launchDialer(_tollFreeNumber!),
                                        isOutlined: true,
                                      ),
                                    ),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    final IconData icon = ServiceApi.getServiceIcon(service.name);

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
                // Icon or image
                service.serviceIcon.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          service.serviceIcon,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
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
                            );
                          },
                        ),
                      )
                    : Container(
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
                        service.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 4, top: 12), // Match icon width + spacing
              child: HtmlWidget(
                service.description,
                onLoadingBuilder: (context, element, loadingProgress) =>
                    const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.lightGrey),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Learn More',
              onPressed: () async {
                const url = 'https://skytechiez.co/';
                try {
                  final uri = Uri.parse(url);
                  if (!await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                    webViewConfiguration: const WebViewConfiguration(
                      enableJavaScript: true,
                      enableDomStorage: true,
                    ),
                  )) {
                    throw 'Failed to launch URL: $url';
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
