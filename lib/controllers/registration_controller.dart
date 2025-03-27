import 'dart:io';
import 'package:get/get.dart';
import 'package:sky_techiez/servies/auth_service.dart';

class RegistrationController extends GetxController {
  // User data
  final firstName = ''.obs;
  final lastName = ''.obs;
  final dob = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final password = ''.obs;
  final Rx<File?> profileImage = Rx<File?>(null);

  // Loading states
  final isLoading = false.obs;

  // OTP functionality is commented out
  // final isOtpSent = false.obs;

  void reset() {
    firstName.value = '';
    lastName.value = '';
    dob.value = '';
    email.value = '';
    phone.value = '';
    password.value = '';
    profileImage.value = null;
    isLoading.value = false;
    // isOtpSent.value = false;
  }

  // OTP functionality is commented out
  /*
  // Send OTP to email
  Future<bool> sendOtp() async {
    isLoading.value = true;
    try {
      final success = await AuthService.sendOtp(email.value);
      if (success) {
        isOtpSent.value = true;
      }
      return success;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String otp) async {
    isLoading.value = true;
    try {
      final success = await AuthService.verifyOtp(email.value, otp);
      return success;
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  */

  // Register user
  Future<Map<String, dynamic>> register() async {
    isLoading.value = true;
    try {
      if (profileImage.value == null) {
        return {'success': false, 'message': 'Profile image is required'};
      }

      final result = await AuthService.register(
        firstName: firstName.value,
        lastName: lastName.value,
        dob: dob.value,
        phone: phone.value,
        email: email.value,
        password: password.value,
        profileImage: profileImage.value!,
      );

      return result;
    } catch (e) {
      print('Error registering user: $e');
      return {'success': false, 'message': 'Registration failed: $e'};
    } finally {
      isLoading.value = false;
    }
  }
}
