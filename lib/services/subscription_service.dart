import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/widgets/session_string.dart';

class SubscriptionService {
  static Future<bool> hasActiveSubscription() async {
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
        final subscriptionData = json.decode(responseBody);

        // Check if subscription exists and is active (status = 1)
        if (subscriptionData != null &&
            subscriptionData.containsKey('subscriptions') &&
            subscriptionData['subscriptions'] != null) {
          final subscription = subscriptionData['subscriptions'];
          final status = subscription['status'];

          // Check if status is 1 (active) and end date is in the future
          if (status == 1) {
            final endDateString = subscription['end_date'];
            if (endDateString != null) {
              try {
                final endDate = DateTime.parse(endDateString);
                final now = DateTime.now();
                return endDate.isAfter(now);
              } catch (e) {
                print('Error parsing end date: $e');
                return true; // If we can't parse date but status is 1, assume active
              }
            }
            return true; // Status is 1, assume active
          }
        }
        return false;
      } else {
        print('Failed to check subscription: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error checking subscription: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getActiveSubscription() async {
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
        final subscriptionData = json.decode(responseBody);

        if (subscriptionData != null &&
            subscriptionData.containsKey('subscriptions') &&
            subscriptionData['subscriptions'] != null) {
          final subscription = subscriptionData['subscriptions'];

          // Check if subscription is active and not expired
          if (subscription['status'] == 1) {
            final endDateString = subscription['end_date'];
            if (endDateString != null) {
              try {
                final endDate = DateTime.parse(endDateString);
                final now = DateTime.now();
                if (endDate.isAfter(now)) {
                  return subscriptionData;
                }
              } catch (e) {
                print('Error parsing end date: $e');
                return subscriptionData; // Return data if we can't parse date but status is 1
              }
            } else {
              return subscriptionData; // Return data if no end date but status is 1
            }
          }
        }
      } else {
        print('Failed to get subscription: ${response.reasonPhrase}');
      }
      return null;
    } catch (e) {
      print('Error getting subscription: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getSubscriptionHistory() async {
    try {
      var headers = {
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };

      var request = http.Request('GET',
          Uri.parse('https://tech.skytechiez.co/api/subscription-history'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final historyData = json.decode(responseBody);

        if (historyData != null && historyData.containsKey('subscriptions')) {
          return List<Map<String, dynamic>>.from(historyData['subscriptions']);
        }
      } else {
        print('Failed to load subscription history: ${response.reasonPhrase}');
      }
      return [];
    } catch (e) {
      print('Error getting subscription history: $e');
      return [];
    }
  }

  // Helper method to get available plans
  static Future<List<Map<String, dynamic>>> getAvailablePlans() async {
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
        final data = json.decode(responseBody);

        if (data != null && data.containsKey('plans')) {
          return List<Map<String, dynamic>>.from(data['plans']);
        }
      } else {
        print('Failed to load plans: ${response.reasonPhrase}');
      }
      return [];
    } catch (e) {
      print('Error getting plans: $e');
      return [];
    }
  }
}
