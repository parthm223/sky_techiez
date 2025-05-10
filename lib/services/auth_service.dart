import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:sky_techiez/widgets/session_string.dart';
import 'package:flutter/material.dart';

class AuthService {
  static const String baseUrl = 'https://tech.skytechiez.co/api';

  // Register user
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String dob,
    required String phone,
    required String email,
    required String password,
    required File profileImage,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/register'),
      );

      // Add text fields
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['dob'] = dob;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      request.fields['password'] = password;

      print('Registering user:');
      print('First Name: $firstName, Last Name: $lastName, DOB: $dob');
      print('Phone: $phone, Email: $email');

      // Add profile image
      var fileExtension = profileImage.path.split('.').last;
      var contentType = 'image/jpeg';
      if (fileExtension == 'png') {
        contentType = 'image/png';
      }

      print('Profile Image: ${profileImage.path}, Content-Type: $contentType');

      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
          contentType: MediaType.parse(contentType),
        ),
      );

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': data['success'] ?? false,
          'message': data['message'] ?? 'Registration successful',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message':
              'Registration failed with status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error registering user: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login(
      String emailOrPhone, String password) async {
    try {
      print('Attempting login for: $emailOrPhone');
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'email': emailOrPhone, // API might accept either email or phone
          'password': password,
        },
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Store user data and token
        GetStorage().write(isLoginSession, true);
        GetStorage().write(tokenKey, "Bearer ${data["token"]}");
        GetStorage().write(userCollectionName, data["user"]);

        // Show success message before navigation
        Get.snackbar(
          'Success',
          data['message'] ?? 'Login successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
        );

        // Navigate after showing the message
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed('/home'); // Using named route
        });

        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'data': data['data'] ?? {},
          'token': data['token'] ?? '',
        };
      } else {
        // Show error message here instead of returning it
        Get.snackbar(
          'Error',
          data['message'] ?? 'Invalid credentials or user not found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
        );

        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('Error logging in: $e');

      // Show error message here for exceptions
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );

      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Send OTP to email
  static Future<bool> sendOtp(String email) async {
    try {
      print('Sending OTP to: $email');
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        body: {
          'email': email,
        },
      );

      print('Send OTP response status: ${response.statusCode}');
      print('Send OTP response body: ${response.body}');

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Verify OTP
  static Future<bool> verifyOtp(String email, String otp) async {
    try {
      print('Verifying OTP for: $email with OTP: $otp');
      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        body: {
          'email': email,
          'otp': otp,
        },
      );

      print('Verify OTP response status: ${response.statusCode}');
      print('Verify OTP response body: ${response.body}');

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }
}
