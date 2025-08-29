import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/widgets/session_string.dart';

class UserService {
  static const String baseUrl = 'https://tech.skytechiez.co/api';

  // Reads current user from local storage and returns the id
  static int? _getLoginUserId() {
    final user = GetStorage().read(userCollectionName);
    if (user == null) return null;

    // Common keys could be 'id' or 'user_id'
    if (user is Map) {
      if (user['id'] is int) return user['id'] as int;
      if (user['id'] is String) return int.tryParse(user['id']);
      if (user['user_id'] is int) return user['user_id'] as int;
      if (user['user_id'] is String) return int.tryParse(user['user_id']);
    }
    return null;
  }

  /// DELETE /api/user/{login_user_id}
  /// Returns a map: { success: bool, message: String, statusCode: int, body: dynamic }
  static Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final token = (GetStorage().read(tokenKey) ?? '').toString();
      final userId = _getLoginUserId();

      if (token.isEmpty) {
        return {
          'success': false,
          'message': 'Auth token missing. Please login again.',
          'statusCode': 401,
        };
      }
      if (userId == null) {
        return {
          'success': false,
          'message': 'User ID not found in storage.',
          'statusCode': 400,
        };
      }

      final headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': token, // token already has "Bearer ..."
      };

      final url = Uri.parse('$baseUrl/user/$userId');
      final request = http.MultipartRequest('DELETE', url);
      request.headers.addAll(headers);

      final streamed = await request.send();
      final status = streamed.statusCode;
      final responseBody = await streamed.stream.bytesToString();

      dynamic parsed;
      try {
        parsed = jsonDecode(responseBody);
      } catch (_) {
        parsed = responseBody;
      }

      final success = status == 200 || status == 204;

      return {
        'success': success,
        'message': success
            ? 'Account deleted successfully.'
            : 'Failed to delete account',
        'statusCode': status,
        'body': parsed,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'statusCode': 500,
      };
    }
  }

  /// Helper to clear session data after successful deletion/logout
  static Future<void> clearSession() async {
    final box = GetStorage();
    await box.remove(isLoginSession);
    await box.remove(tokenKey);
    await box.remove(userCollectionName);
  }
}
