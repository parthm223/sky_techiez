import 'package:flutter/material.dart';
import 'package:sky_techiez/models/notification_model.dart';
import 'package:sky_techiez/theme/app_theme.dart';

class NotificationsDrawer extends StatefulWidget {
  final List<NotificationModel> notifications;
  final Function(int) onMarkAsRead;
  final VoidCallback onRefresh;
  final bool isLoading;

  const NotificationsDrawer({
    super.key,
    required this.notifications,
    required this.onMarkAsRead,
    required this.onRefresh,
    required this.isLoading,
  });

  @override
  State<NotificationsDrawer> createState() => _NotificationsDrawerState();
}

class _NotificationsDrawerState extends State<NotificationsDrawer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regularNotifications =
        widget.notifications.where((n) => !n.isSpecial).toList();
    final specialNotifications =
        widget.notifications.where((n) => n.isSpecial).toList();

    final regularUnreadCount =
        regularNotifications.where((n) => !n.isRead).length;
    final specialUnreadCount =
        specialNotifications.where((n) => !n.isRead).length;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: AppColors.darkBackground,
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.refresh, color: AppColors.white),
                          onPressed: widget.onRefresh,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primaryBlue,
                  indicatorWeight: 3,
                  labelColor: AppColors.primaryBlue,
                  unselectedLabelColor: AppColors.white.withOpacity(0.7),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.notifications_outlined),
                          const SizedBox(width: 8),
                          const Text('All'),
                          if (regularUnreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$regularUnreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star_outline),
                          const SizedBox(width: 8),
                          const Text('Special'),
                          if (specialUnreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$specialUnreadCount',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // Regular notifications tab
                      _buildNotificationsList(regularNotifications),

                      // Special notifications tab
                      _buildNotificationsList(specialNotifications,
                          isSpecial: true),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications,
      {bool isSpecial = false}) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSpecial ? Icons.star_border : Icons.notifications_none,
              size: 64,
              color: isSpecial
                  ? Colors.amber.withOpacity(0.5)
                  : AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isSpecial
                  ? 'No special notifications yet'
                  : 'No notifications yet',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      padding: const EdgeInsets.all(12),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification, isSpecial);
      },
    );
  }

  Widget _buildNotificationCard(
      NotificationModel notification, bool isSpecial) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSpecial
              ? [
                  Colors.amber.withOpacity(notification.isRead ? 0.1 : 0.3),
                  Colors.amber.withOpacity(notification.isRead ? 0.05 : 0.15),
                ]
              : [
                  AppColors.primaryBlue
                      .withOpacity(notification.isRead ? 0.1 : 0.3),
                  AppColors.primaryBlue
                      .withOpacity(notification.isRead ? 0.05 : 0.15),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isSpecial
                ? Colors.amber.withOpacity(0.1)
                : AppColors.primaryBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              widget.onMarkAsRead(notification.id);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSpecial
                            ? Colors.amber.withOpacity(0.2)
                            : AppColors.primaryBlue.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSpecial ? Icons.star : Icons.notifications,
                        color: isSpecial ? Colors.amber : AppColors.primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: notification.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isSpecial
                                        ? Colors.amber
                                        : AppColors.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.timeAgo,
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 52),
                  child: Text(
                    notification.description,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
