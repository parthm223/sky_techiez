import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/models/user_login.dart';
import 'package:sky_techiez/screens/edit_profile_screen.dart';
import 'package:sky_techiez/screens/id_selection_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserLogin? userDetail;

  @override
  void initState() {
    super.initState();
    final storedData = GetStorage().read(userCollectionName);
    if (storedData != null) {
      userDetail = UserLogin.fromJson(storedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/SkyLogo.png',
                height: 120,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileItem(
                          'Name:',
                          userDetail != null
                              ? "${userDetail!.firstName} ${userDetail!.lastName}"
                              : 'User Name'),
                      _buildProfileItem('Email:', userDetail?.email ?? 'N/A'),
                      _buildProfileItem('Phone:', userDetail?.phone ?? 'N/A'),
                      _buildProfileItem('DOB:', userDetail?.dob ?? 'N/A'),
                      _buildProfileItem(
                          'ID:', userDetail?.id?.toString() ?? 'N/A'),
                      _buildProfileItem(
                          'Account ID:', userDetail?.accountId ?? 'N/A'),
                      const SizedBox(height: 8),
                      const Divider(color: AppColors.grey),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const Text(
                        'Photo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.grey),
                        ),
                        child: userDetail?.profileUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  userDetail!.profileUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.grey,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.grey,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Edit Profile',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                    settings: RouteSettings(
                      arguments: {
                        "first_name": userDetail?.firstName ?? '',
                        "last_name": userDetail?.lastName ?? '',
                        "dob": userDetail?.dob ?? '',
                        "email": userDetail?.email ?? '',
                        "mobile_number": userDetail?.phone ?? '',
                        "selfie_image": userDetail?.profileUrl ?? '',
                      },
                    ),
                  ),
                );

                if (result == true) {
                  setState(() {
                    final updatedData = GetStorage().read(userCollectionName);
                    if (updatedData != null) {
                      userDetail = UserLogin.fromJson(updatedData);
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'ID Verify',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DocumentSelectionScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
