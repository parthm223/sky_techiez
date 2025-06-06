import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/controllers/auth_controller.dart';
import 'package:sky_techiez/models/user_login.dart';
import 'package:sky_techiez/screens/profile_screen.dart';
import 'package:sky_techiez/screens/services_screen.dart';
import 'package:sky_techiez/screens/subscriptions_screen.dart';
import 'package:sky_techiez/screens/ticket_status_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/services/notification_service.dart';
import 'package:sky_techiez/models/notification_model.dart';
import 'package:sky_techiez/widgets/notifications_drawer.dart';

import '../widgets/session_string.dart';
import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserLogin userDetail = UserLogin();
  List<NotificationModel> notifications = [];
  bool isLoadingNotifications = false;
  int unreadCount = 0;
  int specialUnreadCount = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    userDetail = UserLogin.fromJson(GetStorage().read(userCollectionName));
    super.initState();
    // Fetch notifications when the screen loads
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      isLoadingNotifications = true;
    });

    try {
      final response = await NotificationService.getNotifications();
      if (response['notifications'] != null) {
        setState(() {
          notifications = List<NotificationModel>.from(response['notifications']
              .map((n) => NotificationModel.fromJson(n)));
          unreadCount = notifications.where((n) => !n.isRead).length;
          specialUnreadCount =
              notifications.where((n) => n.isSpecial && !n.isRead).length;
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      setState(() {
        isLoadingNotifications = false;
      });
    }
  }

  Future<void> _markAsRead(int notificationId) async {
    final success = await NotificationService.markAsRead(notificationId);
    if (success) {
      setState(() {
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index].isRead = true;
          unreadCount = notifications.where((n) => !n.isRead).length;
          specialUnreadCount =
              notifications.where((n) => n.isSpecial && !n.isRead).length;
        }
      });
    }
  }

  void _openNotificationsDrawer() {
    // Close the main drawer if it's open
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }

    // Open the notifications drawer from the right
    _scaffoldKey.currentState?.openEndDrawer();
  }

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    const ProfileScreen(),
    const SubscriptionsScreen(),
    const ServicesScreen(),
    const TicketStatusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: _openNotificationsDrawer,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: specialUnreadCount > 0 ? Colors.amber : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: TextStyle(
                        color: specialUnreadCount > 0
                            ? Colors.black
                            : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: AppColors.darkBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  // Header with user info
                  Container(
                    padding: const EdgeInsets.only(
                        top: 50, left: 20, right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryBlue,
                                  width: 2,
                                ),
                              ),
                              child: userDetail.profileUrl != null
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          NetworkImage(userDetail.profileUrl!),
                                    )
                                  : const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppColors.white,
                                      child: Icon(
                                        Icons.person,
                                        size: 35,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                // ignore: unnecessary_null_comparison
                                userDetail != null
                                    ? '${userDetail.firstName} ${userDetail.lastName}'
                                    : 'User Name',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Image.asset(
                            'assets/images/SkyLogo.png',
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Main Menu Items
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_filled,
                    title: 'Home',
                    index: 0,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    title: 'Profile',
                    index: 1,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.subscriptions_outlined,
                    activeIcon: Icons.subscriptions,
                    title: 'Subscriptions',
                    index: 2,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.miscellaneous_services_outlined,
                    activeIcon: Icons.miscellaneous_services,
                    title: 'Services',
                    index: 3,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.receipt_outlined,
                    activeIcon: Icons.receipt,
                    title: 'Ticket Status',
                    index: 4,
                  ),

                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: AppColors.grey, thickness: 0.5),
                  ),
                  const SizedBox(height: 10),

                  // Support & Legal Section
                  const Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 10),
                    child: Text(
                      'SUPPORT & LEGAL',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () => Get.toNamed('/aboutUs'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.policy_outlined,
                    title: 'Refund Policy',
                    onTap: () => Get.toNamed('/refundPolicy'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () => Get.toNamed('/privacyPolicy'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () => Get.toNamed('/termsConditions'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.gavel_outlined,
                    title: 'Owen Agreement',
                    onTap: () => Get.toNamed('/skyTechiezAgreement'),
                  ),
                ],
              ),
            ),

            // Footer with logout button
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                  foregroundColor: AppColors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.primaryBlue),
                  ),
                ),
                onPressed: () {
                  // Clear user session
                  GetStorage().remove(isLoginSession);
                  GetStorage().remove(tokenKey);
                  GetStorage().remove(userCollectionName);

                  // Navigate to Login Screen
                  Get.offAllNamed('/login');
                },
              ),
            ),
          ],
        ),
      ),
      endDrawer: NotificationsDrawer(
        notifications: notifications,
        onMarkAsRead: _markAsRead,
        onRefresh: _fetchNotifications,
        isLoading: isLoadingNotifications,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    IconData? activeIcon,
    required String title,
    int? index,
    VoidCallback? onTap,
  }) {
    final isSelected = index != null && _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Material(
        color: isSelected
            ? AppColors.primaryBlue.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap ??
              () {
                if (index != null) {
                  setState(() => _selectedIndex = index);
                  Navigator.pop(context);
                }
              },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isSelected ? activeIcon ?? icon : icon,
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.white.withOpacity(0.8),
                  size: 24,
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryBlue : AppColors.white,
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.darkBackground,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.grey,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          showUnselectedLabels: true,
          elevation: 10,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                child: const Icon(Icons.home_outlined, size: 24),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.home_filled, size: 24),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                child: const Icon(Icons.person_outline, size: 24),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person, size: 24),
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                child: const Icon(Icons.subscriptions_outlined, size: 24),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.subscriptions, size: 24),
              ),
              label: 'Subscriptions',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                child:
                    const Icon(Icons.miscellaneous_services_outlined, size: 24),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.miscellaneous_services, size: 24),
              ),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                child: const Icon(Icons.receipt_outlined, size: 24),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt, size: 24),
              ),
              label: 'Tickets',
            ),
          ],
        ),
      ),
    );
  }
}
