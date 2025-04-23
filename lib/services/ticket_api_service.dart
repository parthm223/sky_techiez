import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sky_techiez/widgets/session_string.dart';

class TicketApiService {
  static const String _baseUrl = 'https://tech.skytechiez.co/api';

  // Get authorization headers
  static Map<String, String> _getAuthHeaders({bool isFormData = false}) {
    final headers = {
      'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
    };

    if (isFormData) {
      headers['X-Requested-With'] = 'XMLHttpRequest';
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
    }

    return headers;
  }

  // Fetch comments for a ticket
  static Future<List<dynamic>> getComments(String ticketId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get-comments/$ticketId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['comments'] ?? [];
      } else {
        print(
            'Error fetching comments: ${response.statusCode} - ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Exception fetching comments: $e');
      return [];
    }
  }

  // Add a comment to a ticket
  // In TicketApiService.dart
  static Future<Map<String, dynamic>> addComment(
      String ticketId, String comment) async {
    try {
      final uri = Uri.parse('$_baseUrl/add-comment/$ticketId');
      final request = http.Request('POST', uri);
      request.headers.addAll(_getAuthHeaders(isFormData: true));
      request.bodyFields = {'comment': comment};

      // This will follow redirects automatically
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return {
          'success': true,
          'data': jsonData,
          'message': 'Comment added successfully'
        };
      } else {
        return {
          'success': false,
          'message':
              'Failed to add comment: ${response.reasonPhrase ?? "Error ${response.statusCode}"}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error adding comment: $e'};
    }
  }

  // Fetch ticket progress
  static Future<List<dynamic>> getTicketProgress(String ticketId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/ticket-progress/$ticketId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['ticket_progress'] ?? [];
      } else {
        print(
            'Error fetching progress: ${response.statusCode} - ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Exception fetching ticket progress: $e');
      return [];
    }
  }
}
