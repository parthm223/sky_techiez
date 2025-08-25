import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/controllers/auth_controller.dart';
import 'package:sky_techiez/controllers/theme_controller.dart';
import 'package:sky_techiez/models/profile_model.dart';
import 'package:sky_techiez/services/profile_service.dart';
import 'package:sky_techiez/screens/profile_screen.dart';
import 'package:sky_techiez/screens/services_screen.dart';
import 'package:sky_techiez/screens/payment/subscriptions_screen.dart';
import 'package:sky_techiez/screens/ticket_status_screen.dart';
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
  User? userDetail;
  List<NotificationModel> notifications = [];
  bool isLoadingNotifications = false;
  bool isLoadingProfile = true;
  int unreadCount = 0;
  int specialUnreadCount = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Initialize ThemeController if not already initialized
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController());
    }

    // Load user data and fetch fresh profile
    _initializeUserData();
    _fetchNotifications();
  }

  Future<void> _initializeUserData() async {
    setState(() {
      isLoadingProfile = true;
    });

    // First load from storage for immediate display
    _loadUserFromStorage();

    // Then fetch fresh data from API
    await _fetchProfileFromAPI();

    setState(() {
      isLoadingProfile = false;
    });
  }

  void _loadUserFromStorage() {
    final storedUser = ProfileService.getUserFromStorage();
    if (storedUser != null) {
      setState(() {
        userDetail = storedUser;
      });
    }
  }

  Future<void> _fetchProfileFromAPI() async {
    try {
      final profileModel = await ProfileService.getProfile();
      if (profileModel?.user != null) {
        setState(() {
          userDetail = profileModel!.user;
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
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

  // Pull-to-refresh handler that refreshes both profile and notifications
  Future<void> _onRefresh() async {
    await Future.wait([
      _fetchProfileFromAPI(),
      _fetchNotifications(),
    ]);
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
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
    _scaffoldKey.currentState?.openEndDrawer();
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

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    const ProfileScreen(),
    const SubscriptionsScreen(),
    const ServicesScreen(),
    const TicketStatusScreen(),
  ];

  // Method to get AppBar based on selected index
  PreferredSizeWidget? _getAppBar() {
    // Only show AppBar for Home screen (index 0)
    if (_selectedIndex == 0) {
      return AppBar(
        title: const Text('Home'),
        elevation: 0,
        actions: [
          // Notifications button
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
      );
    }
    // Return null for other screens to hide AppBar
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      key: _scaffoldKey,
      appBar: _getAppBar(),
      drawer: _selectedIndex == 0
          ? _buildDrawer()
          : null, // Only show drawer on Home screen
      endDrawer: _selectedIndex == 0
          ? NotificationsDrawer(
              notifications: notifications,
              onMarkAsRead: _markAsRead,
              onRefresh: _fetchNotifications,
              isLoading: isLoadingNotifications,
            )
          : null, // Only show notifications drawer on Home screen
      // Wrap the body with RefreshIndicator for pull-to-refresh functionality
      body: _selectedIndex == 0
          ? RefreshIndicator(
              onRefresh: _onRefresh,
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: _screens[_selectedIndex],
            )
          : _screens[_selectedIndex], // No refresh indicator for other screens
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDrawer() {
    final isLoggedIn = GetStorage().hasData(isLoginSession);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
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
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            child: isLoadingProfile
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        Theme.of(context).cardColor,
                                    child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  )
                                : (isLoggedIn && userDetail?.profileUrl != null)
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            userDetail!.profileUrl!),
                                        onBackgroundImageError: (_, __) {
                                          // Handle image load error
                                        },
                                      )
                                    : CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                        child: Icon(
                                          Icons.person,
                                          size: 35,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isLoggedIn
                                      ? _getUserDisplayName()
                                      : 'Guest User',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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

                if (!isLoggedIn) ...[
                  _buildDrawerItem(
                    context,
                    icon: Icons.login_outlined,
                    activeIcon: Icons.login,
                    title: 'Login',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/login');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_add_outlined,
                    activeIcon: Icons.person_add,
                    title: 'Create New Account',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/register');
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                        color: Theme.of(context).dividerColor, thickness: 0.5),
                  ),
                  const SizedBox(height: 10),
                ],

                // Main Menu Items (always visible)
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_filled,
                  title: 'Home',
                  index: 0,
                ),

                if (isLoggedIn) ...[
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
                ] else ...[
                  _buildDrawerItem(
                    context,
                    icon: Icons.subscriptions_outlined,
                    activeIcon: Icons.subscriptions,
                    title: 'Subscriptions',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _selectedIndex = 2);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.miscellaneous_services_outlined,
                    activeIcon: Icons.miscellaneous_services,
                    title: 'Services',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _selectedIndex = 3);
                    },
                  ),
                ],

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                      color: Theme.of(context).dividerColor, thickness: 0.5),
                ),
                const SizedBox(height: 10),

                // Support & Legal Section (always visible)
                Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 10),
                  child: Text(
                    'SUPPORT & LEGAL',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                  title: 'Cancellation Policy',
                  onTap: () => Get.toNamed('/cancellationPolicy'),
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
          if (isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                onPressed: () {
                  // Clear user session
                  GetStorage().remove(isLoginSession);
                  GetStorage().remove(tokenKey);
                  GetStorage().remove(userCollectionName);

                  // Navigate to Home Screen (not login)
                  Get.offAllNamed('/home');

                  // Show logout message
                  Get.snackbar(
                    'Logged Out',
                    'You have been successfully logged out',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ),
        ],
      ),
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
            ? Theme.of(context).primaryColor.withOpacity(0.2)
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
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color?.withOpacity(0.8),
                  size: 24,
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
                const Spacer(),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
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
    GetStorage().hasData(isLoginSession);

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
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color,
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
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
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
