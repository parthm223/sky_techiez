import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class ProfileService {
  static const String baseUrl = 'https://tech.skytechiez.co/api';

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      var headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };

      var request = http.MultipartRequest('GET', Uri.parse('$baseUrl/profile'));
      request.headers
          .addAll(headers.cast<String, String>()); // Explicit casting

      http.StreamedResponse response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseData);

        // Update stored user data if successful
        if (data['success'] == true && data['data'] != null) {
          GetStorage().write(userCollectionName, data['data']);
        }

        return {
          'success': data['success'] ?? false,
          'message': data['message'] ?? 'Profile fetched successfully',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch profile: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
