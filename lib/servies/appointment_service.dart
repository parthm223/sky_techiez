import 'package:get_storage/get_storage.dart';

class AppointmentService {
  static const String appointmentKey = 'latest_appointment';

  // Save appointment details
  static void saveAppointment(Map<String, dynamic> appointmentDetails) {
    GetStorage().write(appointmentKey, appointmentDetails);
    print('Saved appointment details: $appointmentDetails');
  }

  // Get appointment details
  static Map<String, dynamic>? getAppointment() {
    final data = GetStorage().read(appointmentKey);
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  // Clear appointment details
  static void clearAppointment() {
    GetStorage().remove(appointmentKey);
    print('Cleared appointment details');
  }

  // Generate a unique appointment ID
  static String generateAppointmentId() {
    final now = DateTime.now();
    return 'APT-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch % 10000}';
  }
}
