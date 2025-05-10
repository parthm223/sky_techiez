import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/services/comment_service.dart';
import 'package:sky_techiez/services/ticket_service.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class TicketDetailsController extends GetxController {
  // Ticket data
  final ticketData = <String, dynamic>{}.obs;

  // Comments state
  final comments = <Map<String, dynamic>>[].obs;
  final isLoadingComments = false.obs;
  final hasCommentError = false.obs;
  final isCommentVisible = false.obs;
  final commentController = TextEditingController();

  // Progress state
  final ticketProgress = <String>[].obs;
  final isLoadingProgress = false.obs;
  final hasProgressError = false.obs;

  // General loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ticketData.value = Get.arguments ?? {};

    // If ticket data is incomplete, fetch details
    if (ticketData.containsKey('id') && ticketData.length < 5) {
      fetchTicketDetails(ticketData['id']);
    }

    // Initial data loading
    fetchTicketProgress();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  Future<void> fetchTicketDetails(String ticketId) async {
    isLoading.value = true;

    try {
      final ticket = await TicketService.getTicketById(ticketId);
      if (ticket != null) {
        ticketData.addAll(ticket.toJson());

        // Debug logging for subcategory
        if (ticketData['sub_category_name'] != null) {
          print(
              'Ticket details has subcategory: ${ticketData['sub_category_name']}');
        } else {
          print('Ticket details has no subcategory name');
        }
      } else {
        Get.snackbar('Error', 'Ticket not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error loading ticket: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTicketProgress() async {
    if (ticketData['id'] == null) return;
    if (isLoadingProgress.value) return;

    isLoadingProgress.value = true;
    hasProgressError.value = false;

    try {
      var headers = {
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };

      var request = http.Request(
          'GET',
          Uri.parse(
              'https://tech.skytechiez.co/api/ticket-progress/${ticketData['id']}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> responseData = jsonDecode(responseBody);

        // Parse the ticket_progress array from the response
        if (responseData.containsKey('ticket_progress') &&
            responseData['ticket_progress'] is List) {
          List<String> progressItems =
              List<String>.from(responseData['ticket_progress']);
          ticketProgress.value = progressItems.toSet().toList();
        } else {
          // Fallback to default progress items
          ticketProgress.value = [
            "New ticket",
            "Assigned to Technician",
            "Pending",
            "In Progress",
            "Resolved"
          ];
        }
      } else {
        hasProgressError.value = true;
        Get.snackbar('Error', 'Failed to load ticket progress');
      }
    } catch (e) {
      hasProgressError.value = true;
      Get.snackbar('Error', 'Error loading ticket progress: $e');
    } finally {
      isLoadingProgress.value = false;
    }
  }

  Future<void> fetchComments() async {
    if (ticketData['id'] == null) return;
    if (isLoadingComments.value) return;

    isLoadingComments.value = true;
    hasCommentError.value = false;

    try {
      final commentsList =
          await CommentService.getComments(ticketData['id'].toString());
      comments.value = commentsList;
    } catch (e) {
      hasCommentError.value = true;
      Get.snackbar('Error', 'Unable to load comments. Please try again.');
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<void> addComment() async {
    if (commentController.text.trim().isEmpty || ticketData['id'] == null) {
      return;
    }

    final comment = commentController.text;
    final ticketId = ticketData['id'].toString();

    isLoadingComments.value = true;

    try {
      bool success = await CommentService.addComment(ticketId, comment);

      if (success) {
        commentController.clear();
        isCommentVisible.value = false;
        Get.snackbar('Success', 'Comment added successfully');
        await fetchComments();
      } else {
        Get.snackbar('Error', 'Failed to add comment. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error adding comment: $e');
    } finally {
      isLoadingComments.value = false;
    }
  }

  bool isProgressItemCompleted(int index) {
    final currentStatus = ticketData['status']?.toLowerCase() ?? '';
    final progressItem = ticketProgress[index].toLowerCase();

    if (currentStatus == 'in progress') {
      return progressItem == 'in progress' ||
          progressItem == 'pending' ||
          progressItem == 'assigned to parth patel' ||
          progressItem.contains('assigned to');
    } else if (currentStatus == 'pending') {
      return progressItem == 'pending' || progressItem.contains('assigned to');
    } else if (currentStatus == 'resolved' ||
        currentStatus == 'closed' ||
        currentStatus == 'completed') {
      return true;
    } else {
      if (progressItem.contains(currentStatus)) {
        return true;
      }

      if ((currentStatus == 'in progress' &&
              (progressItem == 'pending' ||
                  progressItem.contains('assigned to'))) ||
          (currentStatus == 'pending' &&
              progressItem.contains('assigned to'))) {
        return true;
      }
    }

    return false;
  }

  String formatDate(String? date) {
    if (date == null) return '';

    try {
      if (date.contains('T')) {
        final dateTime = DateTime.parse(date);
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      // Use original date if parsing fails
    }
    return date;
  }
}
