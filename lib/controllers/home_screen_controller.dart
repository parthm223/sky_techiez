import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/models/notification_model.dart';
import 'package:sky_techiez/models/user_login.dart';
import 'package:sky_techiez/services/notification_service.dart';
import '../widgets/session_string.dart';

class HomeController extends GetxController {
  // User data
  final userDetail = UserLogin().obs;

  // Notifications
  final notifications = <NotificationModel>[].obs;
  final isLoadingNotifications = false.obs;
  final unreadCount = 0.obs;
  final specialUnreadCount = 0.obs;

  // Navigation
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchNotifications();
  }

  void loadUserData() {
    userDetail.value =
        UserLogin.fromJson(GetStorage().read(userCollectionName));
  }

  Future<void> fetchNotifications() async {
    isLoadingNotifications.value = true;

    try {
      final response = await NotificationService.getNotifications();
      if (response['notifications'] != null) {
        notifications.assignAll(List<NotificationModel>.from(
            response['notifications']
                .map((n) => NotificationModel.fromJson(n))));
        updateUnreadCounts();
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoadingNotifications.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final success = await NotificationService.markAsRead(notificationId);
    if (success) {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index].isRead = true;
        updateUnreadCounts();
      }
    }
  }

  void updateUnreadCounts() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
    specialUnreadCount.value =
        notifications.where((n) => n.isSpecial && !n.isRead).length;
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    // Clear user session
    GetStorage().remove(isLoginSession);
    GetStorage().remove(tokenKey);
    GetStorage().remove(userCollectionName);

    // Navigate to Login Screen
    Get.offAllNamed('/login');
  }
}
