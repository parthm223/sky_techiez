import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/models/ticket.dart';
import 'package:sky_techiez/services/comment_service.dart';
import 'package:sky_techiez/services/subscription_service.dart';
import 'package:sky_techiez/services/ticket_service.dart';
import 'package:sky_techiez/widgets/session_string.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeContentController extends GetxController with WidgetsBindingObserver {
  // Ticket state
  final latestTicket = Rxn<Ticket>();
  final isLoadingTicket = true.obs;

  // Subscription state
  final hasSubscription = false.obs;
  final isCheckingSubscription = true.obs;

  // Toll-free number state
  final tollFreeNumber = '1-800-123-4567'.obs;
  final isLoadingTollFreeNumber = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadLatestTicket();
    checkSubscriptionStatus();
    fetchSettings();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> fetchSettings() async {
    print('Starting to fetch settings...');
    isLoadingTollFreeNumber.value = true;

    try {
      var headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };

      print('Headers: $headers');
      print('Making request to: https://tech.skytechiez.co/api/settings');

      var request = http.MultipartRequest(
          'GET', Uri.parse('https://tech.skytechiez.co/api/settings'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Raw API response: $responseBody');

        Map<String, dynamic> data = json.decode(responseBody);
        print('Parsed response data: $data');

        // Extract toll-free number from the nested structure
        String extractedNumber = '1-800-123-4567'; // Default fallback
        if (data['settings'] != null && data['settings'] is List) {
          for (var setting in data['settings']) {
            if (setting['key'] == 'toll_free_number') {
              extractedNumber = setting['value'] ?? extractedNumber;
              break;
            }
          }
        }

        print('Extracted toll-free number: $extractedNumber');
        tollFreeNumber.value = extractedNumber;
      } else {
        print('API request failed with status: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
        tollFreeNumber.value = '1-800-123-4567';
      }
    } catch (e) {
      print('Error in _fetchSettings: $e');
      tollFreeNumber.value = '1-800-123-4567';
    } finally {
      isLoadingTollFreeNumber.value = false;
      print('Finished loading toll-free number');
    }
  }

  Future<void> checkSubscriptionStatus() async {
    isCheckingSubscription.value = true;
    hasSubscription.value = await SubscriptionService.hasActiveSubscription();
    isCheckingSubscription.value = false;
  }

  Future<void> loadLatestTicket() async {
    isLoadingTicket.value = true;

    try {
      // First try to fetch from API
      final apiTickets = await TicketService.fetchTicketsFromApi();

      // Get local tickets as fallback
      final localTickets = TicketService.getAllTickets();

      // Use API tickets if available, otherwise use local tickets
      final allTickets = apiTickets.isNotEmpty ? apiTickets : localTickets;

      // Filter out closed tickets
      final activeTickets = allTickets.where((ticket) {
        final status = ticket.status.toLowerCase();
        return status != 'closed';
      }).toList();

      // Get the most recent active ticket (assuming the first one is the latest)
      latestTicket.value =
          activeTickets.isNotEmpty ? activeTickets.first : null;

      // Debug logging for subcategory name
      if (latestTicket.value != null &&
          latestTicket.value!.subcategoryName != null) {
        print(
            'Latest ticket has subcategory: ${latestTicket.value!.subcategoryName}');
      } else if (latestTicket.value != null) {
        print('Latest ticket has no subcategory name');
      }
    } catch (e) {
      print('Error loading latest ticket: $e');

      // Fall back to local tickets if API fails
      final localTickets = TicketService.getAllTickets();

      // Filter out closed tickets from local tickets too
      final activeLocalTickets = localTickets.where((ticket) {
        final status = ticket.status.toLowerCase();
        return status != 'closed';
      }).toList();

      latestTicket.value =
          activeLocalTickets.isNotEmpty ? activeLocalTickets.first : null;
    } finally {
      isLoadingTicket.value = false;
    }
  }

  Future<void> handleCloseTicket() async {
    if (latestTicket.value == null) return;

    // Create a text controller for the comment input
    final TextEditingController commentController = TextEditingController();

    // Store a local reference to the ticket ID to avoid null issues later
    final int? ticketId = latestTicket.value!.id;

    // Show dialog to get comment before closing ticket
    final bool? shouldCloseTicket = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Get.theme.cardColor,
        title: const Text(
          'Add Closing Comment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please add a comment before closing this ticket:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your comment here...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.black12,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    // If dialog was dismissed or canceled
    if (shouldCloseTicket != true) return;

    isLoadingTicket.value = true;

    try {
      // First add the comment if not empty
      if (commentController.text.isNotEmpty) {
        await CommentService.addComment(
            ticketId.toString(), commentController.text);
      }

      // Then close the ticket
      var headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('https://tech.skytechiez.co/api/close-ticket/$ticketId'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Ticket closed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Reload the latest ticket to reflect the status change
        loadLatestTicket();
      } else {
        Get.snackbar(
          'Error',
          'Failed to close ticket: ${response.reasonPhrase}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoadingTicket.value = false;
      }
    } catch (e) {
      print('Error processing ticket: $e');
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoadingTicket.value = false;
    }
  }

  String formatPhoneNumber(String number) {
    if (number.length == 10) {
      return '${number.substring(0, 3)}-${number.substring(3, 6)}-${number.substring(6)}';
    }
    return number;
  }

  Future<void> launchDialer(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      print('Could not launch dialer');
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.blue;
      case 'Pending':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      case 'New':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'In Progress':
        return Icons.pending_actions;
      case 'Pending':
        return Icons.hourglass_empty;
      case 'Resolved':
        return Icons.check_circle;
      case 'New':
        return Icons.fiber_new;
      default:
        return Icons.info;
    }
  }
}
