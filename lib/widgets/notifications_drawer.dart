import 'package:flutter/material.dart';
import 'package:sky_techiez/models/notification_model.dart';

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

class _NotificationsDrawerState extends State<NotificationsDrawer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount = widget.notifications.where((n) => !n.isRead).length;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.2),
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
                    Text(
                      'Notifications',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.refresh, color: theme.iconTheme.color),
                          onPressed: widget.onRefresh,
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: theme.iconTheme.color),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_outlined, color: theme.iconTheme.color),
                      const SizedBox(width: 8),
                      Text(
                        'All',
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unreadCount',
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
              ],
            ),
          ),
          Expanded(
            child: widget.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  )
                : _buildNotificationsList(widget.notifications),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    final theme = Theme.of(context);
    
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: theme.iconTheme.color?.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
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
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withOpacity(notification.isRead ? 0.1 : 0.3),
            theme.primaryColor.withOpacity(notification.isRead ? 0.05 : 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.1),
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
                        color: theme.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: theme.primaryColor,
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
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: notification.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.timeAgo,
                            style: theme.textTheme.bodySmall?.copyWith(
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
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
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
