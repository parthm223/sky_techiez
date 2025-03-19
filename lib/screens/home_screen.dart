import 'package:flutter/material.dart';
import 'package:sky_techiez/screens/about_us_screen.dart';
import 'package:sky_techiez/screens/book_appointment_screen.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/profile_screen.dart';
import 'package:sky_techiez/screens/privacy_policy_screen.dart';
import 'package:sky_techiez/screens/refund_policy_screen.dart';
import 'package:sky_techiez/screens/services_screen.dart';
import 'package:sky_techiez/screens/subscriptions_screen.dart';
import 'package:sky_techiez/screens/terms_conditions_screen.dart';
import 'package:sky_techiez/screens/ticket_status_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

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

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DIGITAL IT SOLUTION',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'IN NEW YORK',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(3, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      [Icons.computer, Icons.cloud, Icons.security][index],
                      size: 32,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      [
                        'IT Services',
                        'Cloud Solutions',
                        'Cyber Security'
                      ][index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const Text(
            'WE\'RE READY TO GROW YOUR BUSINESS WITH US',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Expert Consultation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Get professional advice from our IT experts',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'Book Appointment',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BookAppointmentScreen(),
                                ),
                              );
                            },
                            width: 160,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.people,
                        size: 48,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'WHAT WE\'RE OFFERING',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: AppColors.cardBackground,
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      [
                        Icons.design_services,
                        Icons.support_agent,
                        Icons.subscriptions
                      ][index],
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  title: Text(
                    [
                      'Design Service',
                      'Support Service',
                      'Premium Subscription'
                    ][index],
                    style: const TextStyle(color: AppColors.white),
                  ),
                  subtitle: Text(
                    [
                      'Get custom designs',
                      'Get 24/7 support',
                      'Unlock premium features'
                    ][index],
                    style: const TextStyle(color: AppColors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppColors.grey),
                  onTap: () {},
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            color: AppColors.cardBackground,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a support ticket and our team will assist you',
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Create Ticket',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateTicketScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: AppColors.cardBackground,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Toll Free Number',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Call us for free at',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1-800-123-4567',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
