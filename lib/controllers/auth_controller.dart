import 'package:get/get.dart';
import 'package:sky_techiez/models/user_data.dart';

import 'package:sky_techiez/servies/auth_service.dart';

class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final currentUser = Rx<User?>(null); // Using User model
  final token = ''.obs;

  Future<Map<String, dynamic>> login(
      String emailOrPhone, String password) async {
    isLoading.value = true;
    try {
      final result = await AuthService.login(emailOrPhone, password);

      if (result['success'] == true) {
        currentUser.value = User.fromMap(result['data']);
        token.value = result['token'] ?? '';
        isLoggedIn.value = true;
      }
      return result;
    } catch (e) {
      return {'success': false, 'message': 'Login failed: $e'};
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    currentUser.value = null;
    token.value = '';
  }
}
