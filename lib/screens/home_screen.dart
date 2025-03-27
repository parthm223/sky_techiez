import 'package:flutter/material.dart';
import 'package:sky_techiez/screens/about_us_screen.dart';
import 'package:sky_techiez/screens/profile_screen.dart';
import 'package:sky_techiez/screens/privacy_policy_screen.dart';
import 'package:sky_techiez/screens/refund_policy_screen.dart';
import 'package:sky_techiez/screens/services_screen.dart';
import 'package:sky_techiez/screens/subscriptions_screen.dart';
import 'package:sky_techiez/screens/terms_conditions_screen.dart';
import 'package:sky_techiez/screens/ticket_status_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';

import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const ProfileScreen(),
    const SubscriptionsScreen(),
    const ServicesScreen(),
    const TicketStatusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.darkBackground,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'User Name',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'user@example.com',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.white),
              title:
                  const Text('Home', style: TextStyle(color: AppColors.white)),
              selected: _selectedIndex == 0,
              selectedTileColor: AppColors.primaryBlue.withOpacity(0.2),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.white),
              title: const Text('Profile',
                  style: TextStyle(color: AppColors.white)),
              selected: _selectedIndex == 1,
              selectedTileColor: AppColors.primaryBlue.withOpacity(0.2),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.subscriptions, color: AppColors.white),
              title: const Text('Subscriptions',
                  style: TextStyle(color: AppColors.white)),
              selected: _selectedIndex == 2,
              selectedTileColor: AppColors.primaryBlue.withOpacity(0.2),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services,
                  color: AppColors.white),
              title: const Text('Services',
                  style: TextStyle(color: AppColors.white)),
              selected: _selectedIndex == 3,
              selectedTileColor: AppColors.primaryBlue.withOpacity(0.2),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt, color: AppColors.white),
              title: const Text('Ticket Status',
                  style: TextStyle(color: AppColors.white)),
              selected: _selectedIndex == 4,
              selectedTileColor: AppColors.primaryBlue.withOpacity(0.2),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(color: AppColors.grey),
            ListTile(
              leading: const Icon(Icons.info, color: AppColors.white),
              title: const Text('About Us',
                  style: TextStyle(color: AppColors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.policy, color: AppColors.white),
              title: const Text('Refund Policy',
                  style: TextStyle(color: AppColors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RefundPolicyScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: AppColors.white),
              title: const Text('Privacy Policy',
                  style: TextStyle(color: AppColors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: AppColors.white),
              title: const Text('Terms & Conditions',
                  style: TextStyle(color: AppColors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsConditionsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.darkBackground,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Tickets',
          ),
        ],
      ),
    );
  }
}
