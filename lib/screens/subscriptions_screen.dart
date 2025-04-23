import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _subscriptionData;
  List<dynamic> _plans = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSubscriptions();
    _fetchPlans();
  }

  Future<void> _fetchSubscriptions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var headers = {
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };

      var request = http.Request(
          'GET', Uri.parse('https://tech.skytechiez.co/api/my-subscriptions'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        if (mounted) {
          setState(() {
            _subscriptionData = json.decode(responseBody);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage =
                response.reasonPhrase ?? 'Failed to load subscriptions';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchPlans() async {
    try {
      var headers = {
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };

      var request = http.Request(
          'GET', Uri.parse('https://tech.skytechiez.co/public/api/plans'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        if (mounted) {
          setState(() {
            final data = json.decode(responseBody);
            // Parse plans according to the specified payload format
            _plans = data['plans'] ?? [];
          });
        }
      } else {
        print('Failed to load plans: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching plans: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(_errorMessage,
                      style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
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
                      Card(
                        color: AppColors.cardBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Current Status',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _hasActiveSubscription()
                                          ? AppColors.primaryBlue
                                          : AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      _hasActiveSubscription()
                                          ? "Active Subscription"
                                          : "Don't Have Subscription",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _hasActiveSubscription()
                                            ? AppColors.white
                                            : AppColors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Exp - Date: ${_getExpiryDate()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Available Plans',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSubscriptionPlans(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSubscriptionPlans() {
    // Display plans according to the specified payload format
    if (_plans.isNotEmpty) {
      return Column(
        children: _plans.map<Widget>((plan) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSubscriptionPlan(
              context,
              plan['id'] ?? 0,
              plan['name'] ?? 'Unknown Plan',
              plan['price'] ?? '0.0',
              plan['description'] ?? 'No description available',
              plan['status'] ?? 0,
              plan['duration'] ?? 0,
              plan['created_at'] ?? '',
              plan['updated_at'] ?? '',
            ),
          );
        }).toList(),
      );
    } else {
      // Fallback to the default plan if no plans from API
      return _buildSubscriptionPlan(
        context,
        1,
        'Premium Plan',
        '30.0',
        'Access to all features',
        1,
        30,
        '2023-01-01',
        '2023-01-01',
      );
    }
  }

  bool _hasActiveSubscription() {
    if (_subscriptionData == null) return false;

    // Check if user has an active subscription based on your API response structure
    return _subscriptionData!.containsKey('active_subscription') &&
        _subscriptionData!['active_subscription'] != null;
  }

  String _getExpiryDate() {
    if (!_hasActiveSubscription()) return 'N/A';

    // Extract expiry date from your API response
    return _subscriptionData!['active_subscription']['expiry_date'] ?? 'N/A';
  }

  Widget _buildSubscriptionPlan(
    BuildContext context,
    int id,
    String name,
    String price,
    String description,
    int status,
    int duration,
    String createdAt,
    String updatedAt,
  ) {
    // Generate features based on description
    List<String> features = [
      '$duration Month subscription',
      description,
      'Created on: ${_formatDate(createdAt)}',
    ];

    bool isPremium = price.isNotEmpty &&
        double.tryParse(price) != null &&
        double.parse(price) > 20.0;

    return Card(
      elevation: 2,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isPremium
            ? const BorderSide(color: AppColors.primaryBlue, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                // ← Ensures the text takes available space
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  // ← Allows price to shrink if needed
                  child: Text(
                    '\$$price',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '/ $duration Month',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
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
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(color: AppColors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            CustomButton(
              text: _hasActiveSubscription() &&
                      _subscriptionData!['active_subscription']['plan_id'] ==
                          id.toString()
                  ? 'Current Plan'
                  : 'Subscribe Now',
              onPressed: () {
                _handleSubscription(name, id.toString());
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _handleSubscription(String planTitle, String planId) {
    // Implement your subscription logic here
    // This could navigate to a payment screen or call another API
    print('Subscribing to plan: $planTitle (ID: $planId)');
  }
}
