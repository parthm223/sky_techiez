import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/models/profile_model.dart';
import 'package:sky_techiez/screens/edit_profile_screen.dart';
import 'package:sky_techiez/services/profile_service.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? userDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchProfileData();
  }

  void _loadUserData() {
    final storedData = GetStorage().read(userCollectionName);
    if (storedData != null) {
      try {
        setState(() {
          userDetail = User.fromJson(storedData);
        });
      } catch (e) {
        print('Error parsing stored user data: $e');
        setState(() {
          userDetail = null;
        });
      }
    } else {
      setState(() {
        userDetail = null;
      });
    }
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final ProfileModel? result = await ProfileService.getProfile();

      if (result != null && result.user != null) {
        setState(() {
          userDetail = result.user;
        });
        print(
            'Profile fetched successfully: ${userDetail?.firstName} ${userDetail?.lastName}');
      } else {
        print('Failed to fetch profile: No user data received');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _fetchProfileData();
  }

  String _getUserDisplayName() {
    if (userDetail?.fullName != null && userDetail!.fullName!.isNotEmpty) {
      return userDetail!.fullName!;
    } else if (userDetail?.firstName != null || userDetail?.lastName != null) {
      return '${userDetail?.firstName ?? ''} ${userDetail?.lastName ?? ''}'
          .trim();
    }
    return 'User Name';
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = GetStorage().hasData(isLoginSession);

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 100,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Sky Techiez',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Please login or create an account to access your profile and manage your tickets.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed('/login'),
                    icon: const Icon(Icons.login),
                    label: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Get.toNamed('/register'),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Create New Account'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        // Removed refresh button from AppBar
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works even when content doesn't fill screen
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pull-to-refresh hint text
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Pull down to refresh profile data',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Center(
                      child: Image.asset(
                        'assets/images/SkyLogo.png',
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 16),

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
                              _buildProfileItem('Name:', _getUserDisplayName()),
                              _buildProfileItem(
                                  'Email:', userDetail?.email ?? 'N/A'),
                              _buildProfileItem(
                                  'Phone:', userDetail?.phone ?? 'N/A'),
                              _buildProfileItem(
                                  'DOB:', userDetail?.dob ?? 'N/A'),
                              _buildProfileItem('Account ID:',
                                  userDetail?.accountId ?? 'N/A'),
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
                                          errorBuilder:
                                              (context, error, stackTrace) {
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
                          _loadUserData();
                          _fetchProfileData();
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Add some extra space at the bottom to ensure pull-to-refresh works properly
                    const SizedBox(height: 100),
                  ],
                ),
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
              value.isEmpty ? 'N/A' : value,
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
