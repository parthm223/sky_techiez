import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/models/service_model.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class ServiceApi {
  static const String baseUrl = 'https://tech.skytechiez.co/api';

  // Fetch all services
  static Future<List<Service>> getServices() async {
    var headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
    };

    try {
      var request = http.Request('GET', Uri.parse('$baseUrl/services'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> data = json.decode(responseBody);

        if (data.containsKey('services')) {
          return (data['services'] as List)
              .map((serviceJson) => Service.fromJson(serviceJson))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load services: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching services: $e');
    }
  }

  // Get service icon based on service name
  static IconData getServiceIcon(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'desktop support':
        return Icons.computer;
      case 'wireless printer setup':
      case 'printer support':
        return Icons.print;
      case 'quicken support':
        return Icons.account_balance_wallet;
      case 'quickbooks support':
        return Icons.book;
      case 'antivirus support':
        return Icons.security;
      case 'office 365 support':
        return Icons.article;
      case 'outlook support':
        return Icons.email;
      default:
        return Icons.miscellaneous_services;
    }
  }
}
