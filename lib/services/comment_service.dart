import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class CommentService {
  static final _storage = GetStorage();
  static const String _baseUrl = 'https://tech.skytechiez.co/api';

  // Get comments for a ticket
  static Future<List<Map<String, dynamic>>> getComments(String id) async {
    print("comment page ticket main Id => ${id}");
    final token = _storage.read(tokenKey)?.toString() ?? '';
    print('\n=== GET COMMENTS REQUEST ===');
    print('Ticket ID: $id');
    print(
        'Token: ${token.isNotEmpty ? '*****${token.substring(token.length - 5)}' : 'EMPTY'}');

    if (token.isEmpty) {
      print('❌ Error: Authentication token not found');
      throw Exception('Authentication token not found');
    }

    try {
      // Create request with proper headers
      var request = http.Request(
        'GET',
        Uri.parse('$_baseUrl/get-comments/${id}'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      print('\nRequest Headers:');
      request.headers.forEach((key, value) => print('$key: $value'));

      print('\nSending GET comments request...');
      final stopwatch = Stopwatch()..start();
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      stopwatch.stop();

      print('\n=== GET COMMENTS RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Time: ${stopwatch.elapsedMilliseconds}ms');
      print(
          'Response Body: ${responseBody.length > 200 ? '${responseBody.substring(0, 200)}...' : responseBody}');

      // Handle response
      if (response.statusCode == 200) {
        final data = json.decode(responseBody);

        print('\nParsing response data...');

        // Parse different possible response formats
        if (data is Map && data.containsKey('data') && data['data'] is List) {
          print('Found comments in "data" field');
          return List<Map<String, dynamic>>.from(data['data']);
        } else if (data is Map &&
            data.containsKey('comments') &&
            data['comments'] is List) {
          print('Found comments in "comments" field');
          return List<Map<String, dynamic>>.from(data['comments']);
        } else if (data is List) {
          print('Found direct comments list');
          return List<Map<String, dynamic>>.from(data);
        }
        print('⚠️ Unexpected response format');
        throw Exception('Invalid comments data format');
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - clearing token');
        _storage.remove(tokenKey); // Clear invalid token
        throw Exception('Session expired. Please login again.');
      } else {
        print('❌ Failed to load comments: ${response.statusCode}');
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Network error: ${e.toString()}');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Add a comment to a ticket
  static Future<bool> addComment(String ticketId, String comment) async {
    final token = _storage.read(tokenKey)?.toString() ?? '';
    print('\n=== ADD COMMENT REQUEST ===');
    print('Ticket ID: $ticketId');
    print(
        'Comment: ${comment.length > 50 ? '${comment.substring(0, 50)}...' : comment}');
    print(
        'Token: ${token.isNotEmpty ? '*****${token.substring(token.length - 5)}' : 'EMPTY'}');

    if (token.isEmpty) {
      print('❌ Error: Authentication token not found');
      throw Exception('Authentication token not found');
    }

    if (comment.isEmpty) {
      print('❌ Error: Empty comment');
      throw Exception('Comment cannot be empty');
    }

    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/add-comment/${ticketId}'),
      );

      // Add headers and fields
      request.headers.addAll({
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer $token',
      });

      request.fields.addAll({
        'comment': comment,
      });

      print('\nRequest Headers:');
      request.headers.forEach((key, value) => print('$key: $value'));
      print('\nRequest Body:');
      request.fields.forEach((key, value) => print(
          '$key: ${value.length > 50 ? '${value.substring(0, 50)}...' : value}'));

      print('\nSending POST comment request...');
      final stopwatch = Stopwatch()..start();
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      stopwatch.stop();

      print('\n=== ADD COMMENT RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Time: ${stopwatch.elapsedMilliseconds}ms');
      print('Response Body: $responseBody');

      // Handle response
      if (response.statusCode == 200) {
        try {
          final data = json.decode(responseBody);
          final success =
              data['message']?.toString().toLowerCase().contains('success') ??
                  false;
          print(success
              ? '✅ Comment added successfully'
              : '⚠️ Comment added but no success message');
          return success;
        } catch (e) {
          print('⚠️ Could not parse response but status is 200');
          return true;
        }
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - clearing token');
        _storage.remove(tokenKey); // Clear invalid token
        throw Exception('Session expired. Please login again.');
      } else {
        print('❌ Failed to add comment: ${response.statusCode}');
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Network error: ${e.toString()}');
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
