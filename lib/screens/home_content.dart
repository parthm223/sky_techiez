import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/home_content_controller.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/printer_driver_screen.dart';
import 'package:sky_techiez/screens/services_screen.dart';
import 'package:sky_techiez/screens/payment/subscriptions_screen.dart';
import 'package:sky_techiez/screens/ticket_details_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final HomeContentController controller = Get.put(HomeContentController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadLatestTicket();
        await controller.checkSubscriptionStatus();
        await controller.fetchSettings();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Welcome To',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/images/SkyLogo.png',
                    height: 100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Display latest ticket if available
            Obx(() {
              if (controller.latestTicket.value != null) {
                return _buildLatestTicketCard(controller);
              } else if (controller.isLoadingTicket.value) {
                return _buildLoadingTicketCard();
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 24),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: List.generate(2, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        [Icons.computer, Icons.cloud][index],
                        size: 42,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ['IT Services', 'Cloud Solutions'][index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            buildPrinterDriverAssistantCard(),
            const Text(
              'WHAT WE\'RE OFFERING',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 16),
            _buildServicesList(),
            const SizedBox(height: 16),
            _buildHelpCard(),

            const SizedBox(height: 16),
            _buildTollFreeCard(),
          ],
        ),
      ),
    );
  }

  Widget buildPrinterDriverAssistantCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Subtle gradient background for depth
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0F132E),
                    const Color(0xFF090C22),
                    const Color(0xFF05071A),
                  ],
                ),
              ),
            ),
            // Decorative blurs
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3A5EFF).withOpacity(0.15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3A5EFF).withOpacity(0.15),
                      blurRadius: 40,
                      spreadRadius: 0,
                      offset: Offset.zero,
                    ),
                  ],
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Printer Driver Assistant',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Find compatible printer drivers and get\nsetup guidance for your device.',
                              style: TextStyle(
                                color: Color(0xFFB0B9E6),
                                fontSize: 16,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF5FE1FF),
                              Color(0xFF566BFF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3D5CFF).withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.print_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  InkWell(
                    onTap: () {
                      Get.to(() => PrinterDriverScreen());
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3D6DFF),
                            Color(0xFF4A3BFF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3D5CFF).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Find Driver',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestTicketCard(HomeContentController controller) {
    final ticket = controller.latestTicket.value!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Latest Ticket',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              )
            ],
          ),
          _buildTicketDetailRow('User Name:', ticket.subject),
          _buildTicketDetailRow('Category:', ticket.categoryName),
          if (ticket.subcategoryName != null)
            _buildTicketDetailRow('Sub Category:', ticket.subcategoryName),
          _buildTicketDetailRow('Priority:', ticket.priority),
          _buildTicketDetailRow('Date:', ticket.date),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                controller.getStatusIcon(ticket.status),
                color: controller.getStatusColor(ticket.status),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                ticket.status,
                style: TextStyle(
                  color: controller.getStatusColor(ticket.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(
                      () => TicketDetailsScreen(ticketData: ticket.toJson()),
                    )?.then((_) => controller.loadLatestTicket());
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple,
                  ),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 10),
              if (ticket.status == 'Resolved')
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.handleCloseTicket,
                    icon: const Icon(Icons.close),
                    label: const Text('Close Ticket'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingTicketCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildServicesList() {
    return ListView.builder(
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
            onTap: () {
              // Navigation logic based on index
              if (index == 1) {
                Get.to(() => ServicesScreen());
              } else if (index == 2) {
                Get.to(() => SubscriptionsScreen());
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildHelpCard() {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    Obx(() {
                      if (controller.isCheckingSubscription.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (controller.hasSubscription.value) {
                        return CustomButton(
                          text: 'Create Ticket',
                          onPressed: () {
                            Get.to(() => const CreateTicketScreen())
                                ?.then((_) => controller.loadLatestTicket());
                          },
                        );
                      } else {
                        return Column(
                          children: [
                            const Icon(
                              Icons.subscriptions,
                              color: Colors.amber,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Subscription Required',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You need an active subscription to create support tickets.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: 'View Subscription Plans',
                              onPressed: () {
                                Get.to(() => const SubscriptionsScreen())?.then(
                                    (_) =>
                                        controller.checkSubscriptionStatus());
                              },
                            ),
                          ],
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTollFreeCard() {
    return Card(
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
            Obx(() {
              if (controller.isLoadingTollFreeNumber.value) {
                return const CircularProgressIndicator();
              } else {
                return InkWell(
                  onTap: () {
                    controller.launchDialer(controller.tollFreeNumber.value);
                  },
                  child: Text(
                    controller
                        .formatPhoneNumber(controller.tollFreeNumber.value),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Not specified',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
