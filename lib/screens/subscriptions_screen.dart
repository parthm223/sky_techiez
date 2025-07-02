import 'package:flutter/material.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/subscription_history_screen.dart';
import 'package:sky_techiez/services/subscription_service.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _subscriptionData;
  List<Map<String, dynamic>> _plans = [];
  String _errorMessage = '';
  bool _hasActiveSubscription = false;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Load subscription data and plans concurrently
      final results = await Future.wait([
        SubscriptionService.hasActiveSubscription(),
        SubscriptionService.getActiveSubscription(),
        SubscriptionService.getAvailablePlans(),
      ]);

      if (mounted) {
        setState(() {
          _hasActiveSubscription = results[0] as bool;
          _subscriptionData = results[1] as Map<String, dynamic>?;
          _plans = results[2] as List<Map<String, dynamic>>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading data: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionHistoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: 'Subscription History',
          ),
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                        _buildCurrentSubscriptionCard(),
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
                ),
    );
  }

  Widget _buildCurrentSubscriptionCard() {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    color: _hasActiveSubscription
                        ? AppColors.primaryBlue
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _hasActiveSubscription
                        ? "Active Subscription"
                        : "No Active Subscription",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _hasActiveSubscription
                          ? AppColors.white
                          : AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_hasActiveSubscription && _subscriptionData != null) ...[
              _buildSubscriptionDetails(),
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
                            builder: (context) => const CreateTicketScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'View History',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SubscriptionHistoryScreen(),
                          ),
                        );
                      },
                      isOutlined: true,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Text(
                'No active subscription found',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'View History',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionHistoryScreen(),
                    ),
                  );
                },
                isOutlined: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionDetails() {
    if (!_hasActiveSubscription || _subscriptionData == null) {
      return const SizedBox.shrink();
    }

    final subscription = _subscriptionData!['subscriptions'];
    final plan = subscription['plan'];

    // Use subscription price first, then fall back to plan price
    final actualPrice = subscription['price'] ?? plan['price'] ?? '0';
    final planName = subscription['plan_name'] ?? plan['name'] ?? 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Plan Name:', planName),
        _buildDetailRow(
            'Transaction ID:', subscription['transaction_id'] ?? 'N/A'),
        _buildDetailRow('Start Date:', _formatDate(subscription['start_date'])),
        _buildDetailRow('End Date:', _formatDate(subscription['end_date'])),
        _buildDetailRow('Actual Price Paid:', '\$$actualPrice'),
        _buildDetailRow('Plan Duration:', '${plan['duration'] ?? 0} months'),
        const SizedBox(height: 8),
        const Text(
          'Description:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          plan['description'] ?? 'No description available',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Subscription Status:',
            subscription['status'] == 1 ? 'Active' : 'Inactive'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans() {
    if (_plans.isEmpty) {
      return const Center(
        child: Text(
          'No plans available',
          style: TextStyle(color: AppColors.grey),
        ),
      );
    }

    return Column(
      children: _plans.map<Widget>((plan) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSubscriptionPlan(plan),
        );
      }).toList(),
    );
  }

  Widget _buildSubscriptionPlan(Map<String, dynamic> plan) {
    final planId = plan['id'] ?? 0;
    final name = plan['name'] ?? 'Unknown Plan';
    final price = plan['price'] ?? '0';
    final description = plan['description'] ?? 'No description available';
    final duration = plan['duration'] ?? 0;
    final status = plan['status'] ?? 0;

    // Check if this is the current active plan
    bool isCurrentPlan = _hasActiveSubscription &&
        _subscriptionData != null &&
        _subscriptionData!['subscriptions']['plan_id'] == planId;

    // Check if plan is active
    bool isPlanActive = status == 1;

    return Card(
      elevation: 2,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isCurrentPlan
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
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                if (!isPlanActive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Inactive',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$$price',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '/ $duration Month${duration > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: isCurrentPlan
                  ? 'Current Plan'
                  : !isPlanActive
                      ? 'Plan Unavailable'
                      : 'Subscribe Now',
              onPressed: (isCurrentPlan || !isPlanActive)
                  ? null
                  : () {
                      _handleSubscription(name, planId.toString());
                    },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _handleSubscription(String planTitle, String planId) {
    print('Subscribing to plan: $planTitle (ID: $planId)');

    // You might want to navigate to a payment screen or show a dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Initiating subscription to $planTitle...'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }
}
