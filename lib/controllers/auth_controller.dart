import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sky_techiez/servies/auth_service.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final user = Rx<Map<String, dynamic>>({});
  final token = ''.obs;

  // Login user
  Future<Map<String, dynamic>> login(
      String emailOrPhone, String password) async {
    isLoading.value = true;
    try {
      final result = await AuthService.login(emailOrPhone, password);

      if (result['success']) {
        // Save user data and token
        user.value = result['data'] ?? {};
        token.value = result['token'] ?? '';
        isLoggedIn.value = true;
      }

      return result;
    } catch (e) {
      print('Error logging in: $e');
      return {'success': false, 'message': 'Login failed: $e'};
    } finally {
      isLoading.value = false;
    }
  }

  // Logout user
  void logout() {
    isLoggedIn.value = false;
    user.value = {};
    token.value = '';
  }
}
