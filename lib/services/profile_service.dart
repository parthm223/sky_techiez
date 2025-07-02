import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/models/profile_model.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class ProfileService {
  static const String baseUrl = 'https://tech.skytechiez.co/api';

  static Future<ProfileModel?> getProfile() async {
    try {
      final token = GetStorage().read(tokenKey) ?? '';
      if (token.isEmpty) {
        print('Authentication token not found');
        return null;
      }

      print('Fetching profile from API...');
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': token,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Profile API Response Status: ${response.statusCode}');
      print('Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final profileModel = ProfileModel.fromJson(responseData);

        // Store user data in local storage for offline access
        if (profileModel.user != null) {
          GetStorage().write(userCollectionName, profileModel.user!.toJson());
          print('Profile data saved to local storage');
        }

        return profileModel;
      } else {
        print('Failed to fetch profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error in ProfileService.getProfile: $e');
      return null;
    }
  }

  static User? getUserFromStorage() {
    try {
      final storedData = GetStorage().read(userCollectionName);
      if (storedData != null) {
        return User.fromJson(storedData);
      }
    } catch (e) {
      print('Error loading user from storage: $e');
    }
    return null;
  }
}
