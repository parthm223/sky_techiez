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
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSubscriptions();
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
          // Add this check
          setState(() {
            _subscriptionData = json.decode(responseBody);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          // Add this check
          setState(() {
            _errorMessage =
                response.reasonPhrase ?? 'Failed to load subscriptions';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        // Add this check
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
          _isLoading = false;
        });
      }
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
    // If we have subscription plans from the API, display them
    if (_subscriptionData != null &&
        _subscriptionData!.containsKey('plans') &&
        _subscriptionData!['plans'] is List) {
      List<dynamic> plans = _subscriptionData!['plans'];

      return Column(
        children: plans.map<Widget>((plan) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSubscriptionPlan(
              context,
              plan['name'] ?? 'Unknown Plan',
              plan['description'] ?? 'No description available',
              '\$${plan['price'] ?? '0.0'}',
              plan['period'] ?? 'Monthly',
              List<String>.from(plan['features'] ?? []),
              isPremium: plan['is_premium'] ?? false,
            ),
          );
        }).toList(),
      );
    } else {
      // Fallback to the default plan if no plans from API
      return _buildSubscriptionPlan(
        context,
        'Premium Plan',
        'Access to all features',
        '\$30.0',
        'Monthly',
        ['24/7 support', 'All features', 'Multiple users', 'Priority service'],
        isPremium: true,
      );
    }
  }

  bool _hasActiveSubscription() {
    if (_subscriptionData == null) return false;

    // Check if user has an active subscription based on your API response structure
    // This is an example - adjust according to your actual API response
    return _subscriptionData!.containsKey('active_subscription') &&
        _subscriptionData!['active_subscription'] != null;
  }

  String _getExpiryDate() {
    if (!_hasActiveSubscription()) return 'N/A';

    // Extract expiry date from your API response
    // This is an example - adjust according to your actual API response
    return _subscriptionData!['active_subscription']['expiry_date'] ?? 'N/A';
  }

  Widget _buildSubscriptionPlan(
    BuildContext context,
    String title,
    String description,
    String price,
    String period,
    List<String> features, {
    bool isPremium = false,
  }) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                if (isPremium)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'RECOMMENDED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '/ $period',
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
                      Text(
                        feature,
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            CustomButton(
              text: _hasActiveSubscription() &&
                      _subscriptionData!['active_subscription']['plan_id'] ==
                          title
                  ? 'Current Plan'
                  : 'Subscribe Now',
              onPressed: () {
                // Handle subscription process
                _handleSubscription(title);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubscription(String planTitle) {
    // Implement your subscription logic here
    // This could navigate to a payment screen or call another API
    print('Subscribing to plan: $planTitle');
  }
}
