import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../widgets/session_string.dart';

class NotificationService {
  static Future<Map<String, dynamic>> getNotifications() async {
    try {
      print('Fetching notifications...');
      final token = GetStorage().read(tokenKey);
      print('Token retrieved: ${token != null ? "****" : "null"}');

      var headers = {'Authorization': 'Bearer $token'};
      print('Headers: $headers');

      var request = http.Request('GET',
          Uri.parse('https://tech.skytechiez.co/api/user-notifications'));
      request.headers.addAll(headers);
      print('Request prepared: ${request.method} ${request.url}');

      http.StreamedResponse response = await request.send();
      print('Response received. Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        final decodedResponse = jsonDecode(responseBody);
        print('Notifications fetched successfully');
        return decodedResponse;
      } else {
        print(
            'Failed to fetch notifications. Reason: ${response.reasonPhrase}');
        return {
          'notifications': [],
          'message': 'Failed to fetch notifications: ${response.reasonPhrase}'
        };
      }
    } catch (e) {
      print('Error in getNotifications: $e');
      return {'notifications': [], 'message': 'Error: $e'};
    }
  }

  static Future<bool> markAsRead(int notificationId) async {
    try {
      print('Marking notification $notificationId as read...');
      final token = GetStorage().read(tokenKey);
      print('Token retrieved: ${token != null ? "****" : "null"}');

      var headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer $token'
      };
      print('Headers: $headers');

      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://tech.skytechiez.co/api/mark-notification/$notificationId'));

      request.headers.addAll(headers);
      print('Request prepared: ${request.method} ${request.url}');

      http.StreamedResponse response = await request.send();
      print('Response received. Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Notification $notificationId marked as read successfully');
      } else {
        print(
            'Failed to mark notification as read. Reason: ${response.reasonPhrase}');
      }

      return response.statusCode == 200;
    } catch (e) {
      print('Error in markAsRead: $e');
      return false;
    }
  }
}
