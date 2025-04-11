import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/widgets/session_string.dart';

class SubscriptionService {
  static const String _subscriptionStatusKey = 'subscription_status';
  static const String _subscriptionLastCheckedKey = 'subscription_last_checked';
  static const Duration _cacheValidDuration = Duration(minutes: 15);

  // Check if user has an active subscription
  static Future<bool> hasActiveSubscription() async {
    // Check if we have a cached result that's still valid
    final lastChecked = GetStorage().read(_subscriptionLastCheckedKey);
    if (lastChecked != null) {
      final lastCheckedTime = DateTime.fromMillisecondsSinceEpoch(lastChecked);
      if (DateTime.now().difference(lastCheckedTime) < _cacheValidDuration) {
        // Use cached result if it's recent enough
        return GetStorage().read(_subscriptionStatusKey) ?? false;
      }
    }

    // Otherwise, fetch fresh data from API
    try {
      var headers = {
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };
      
      var request = http.Request('GET', Uri.parse('https://tech.skytechiez.co/api/my-subscriptions'));
      request.headers.addAll(headers);
      
      http.StreamedResponse response = await request.send();
      
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        
        // Check if subscriptions is null
        final hasSubscription = !(data.containsKey('subscriptions') && data['subscriptions'] == null);
        
        // Cache the result
        GetStorage().write(_subscriptionStatusKey, hasSubscription);
        GetStorage().write(_subscriptionLastCheckedKey, DateTime.now().millisecondsSinceEpoch);
        
        return hasSubscription;
      } else {
        print('Failed to check subscription status: ${response.reasonPhrase}');
        return false; // Default to no subscription on error
      }
    } catch (e) {
      print('Error checking subscription status: $e');
      return false; // Default to no subscription on error
    }
  }

  // Clear cached subscription status (useful after purchasing a subscription)
  static void clearCache() {
    GetStorage().remove(_subscriptionStatusKey);
    GetStorage().remove(_subscriptionLastCheckedKey);
  }
}