import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/widgets/session_string.dart';

class PaymentService {
  static Future<Map<String, dynamic>> processPayment({
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvv,
    required String planId,
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required String city,
    required String state,
    required String zip,
    String? country,
    String? phone,
  }) async {
    try {
      var headers = {
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
        'Content-Type': 'application/json',
      };

      var body = json.encode({
        'card_number': cardNumber.replaceAll(' ', ''),
        'exp_month': expMonth,
        'exp_year': expYear,
        'cvv': cvv,
        'plan_id': planId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'address': address,
        'city': city,
        'state': state,
        'zip': zip,
        if (country != null) 'country': country,
        if (phone != null) 'phone': phone,
      });

      var request =
          http.Request('POST', Uri.parse('https://tech.skytechiez.co/api/pay'));
      request.headers.addAll(headers);
      request.body = body;

      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(responseBody),
          'message': 'Payment processed successfully'
        };
      } else {
        final errorData = json.decode(responseBody);
        return {
          'success': false,
          'error': errorData,
          'message': errorData['message'] ?? 'Payment failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Network error occurred'
      };
    }
  }

  static String formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  static String getCardType(String cardNumber) {
    cardNumber = cardNumber.replaceAll(' ', '');
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5') || cardNumber.startsWith('2')) {
      return 'Mastercard';
    }
    if (cardNumber.startsWith('3')) return 'American Express';
    if (cardNumber.startsWith('6')) return 'Discover';
    return 'Unknown';
  }

  static bool isValidCardNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(' ', '');
    if (cardNumber.length < 13 || cardNumber.length > 19) return false;

    int sum = 0;
    bool alternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit = (digit % 10) + 1;
      }
      sum += digit;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  static bool isValidExpiryDate(String month, String year) {
    try {
      int expMonth = int.parse(month);
      int expYear = int.parse(year);

      if (expMonth < 1 || expMonth > 12) return false;

      DateTime now = DateTime.now();
      DateTime expiry = DateTime(2000 + expYear, expMonth);

      return expiry.isAfter(now);
    } catch (e) {
      return false;
    }
  }
}
