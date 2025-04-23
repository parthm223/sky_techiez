import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/models/ticket.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class TicketService {
  static final List<Ticket> _tickets = [];

  static List<Ticket> getAllTickets() {
    return _tickets;
  }

  static void addTicket(Ticket ticket) {
    _tickets.add(ticket);
  }

  static Future<Ticket?> getTicketById(String id) async {
    for (var ticket in _tickets) {
      if (ticket.id == id) {
        return ticket;
      }
    }

    try {
      final apiTickets = await fetchTicketsFromApi();
      for (var ticket in apiTickets) {
        if (ticket.id == id) {
          return ticket;
        }
      }
    } catch (e) {
      debugPrint('Error fetching ticket by ID: $e');
    }

    return null;
  }

  static Future<List<Ticket>> fetchTicketsFromApi() async {
    debugPrint('Fetching tickets from API...');

    var headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
    };

    try {
      var request = http.Request(
        'GET',
        Uri.parse('https://tech.skytechiez.co/api/my-tickets'),
      );
      request.headers.addAll(headers);

      debugPrint('Sending request with headers: $headers');

      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: $responseBody');

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        List<Ticket> apiTickets = [];

        if (data['tickets'] != null && data['tickets'] is List) {
          for (var ticketData in data['tickets']) {
            final ticket = Ticket(
              id: (ticketData['ticket_id'] ?? ticketData['id']).toString(),
              subject: ticketData['subject']?.toString() ?? 'No Subject',
              categoryId: ticketData['category_id']?.toString() ?? '0',
              subcategoryId: ticketData['category_sub_id']?.toString(),
              categoryName:
                  ticketData['category_name']?.toString() ?? 'General',
              subcategoryName: ticketData['subcategory_name']?.toString(),
              priority: ticketData['priority']?.toString() ?? 'Medium',
              description:
                  ticketData['description']?.toString() ?? 'No description',
              status: ticketData['status']?.toString() ?? 'Pending',
              date: _formatDate(ticketData['created_at']),
            );

            // Enhanced logging for subcategory
            debugPrint('Created ticket with ID: ${ticket.id}');
            debugPrint('  Subject: ${ticket.subject}');
            debugPrint('  Category: ${ticket.categoryName}');
            if (ticket.subcategoryName != null) {
              debugPrint('  Subcategory: ${ticket.subcategoryName}');
            } else {
              debugPrint('  No subcategory name');
              // Check if subcategory data exists in the raw response
              if (ticketData['category_sub_id'] != null) {
                debugPrint(
                    '  Has subcategory ID: ${ticketData['category_sub_id']} but no name');
              }
            }

            apiTickets.add(ticket);

            bool exists =
                _tickets.any((localTicket) => localTicket.id == ticket.id);
            if (!exists) {
              _tickets.add(ticket);
            }
          }
        }

        debugPrint('Fetched ${apiTickets.length} tickets from API');
        return apiTickets;
      } else {
        debugPrint('Failed to fetch tickets: ${response.reasonPhrase}');
        throw Exception('Failed to fetch tickets: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error fetching tickets: $e');
      throw Exception('Error fetching tickets: $e');
    }
  }

  static Future<bool> updateTicketStatus(
      String ticketId, String newStatus) async {
    debugPrint('Updating ticket $ticketId to status: $newStatus');

    var headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      bool locallyUpdated = false;
      for (int i = 0; i < _tickets.length; i++) {
        if (_tickets[i].id == ticketId) {
          _tickets[i] = Ticket(
            id: _tickets[i].id,
            subject: _tickets[i].subject,
            categoryId: _tickets[i].categoryId,
            subcategoryId: _tickets[i].subcategoryId,
            categoryName: _tickets[i].categoryName,
            subcategoryName: _tickets[i].subcategoryName,
            priority: _tickets[i].priority,
            description: _tickets[i].description,
            status: newStatus,
            date: _tickets[i].date,
          );
          locallyUpdated = true;
          break;
        }
      }

      var request = http.Request(
        'PUT',
        Uri.parse(
            'https://tech.skytechiez.co/api/update-ticket-status/$ticketId'),
      );

      request.body = json.encode({
        'status': newStatus,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      debugPrint('Update ticket response status: ${response.statusCode}');
      debugPrint('Update ticket response body: $responseBody');

      if (response.statusCode == 200) {
        debugPrint('Ticket status updated successfully on server');
        return true;
      } else {
        debugPrint(
            'Failed to update ticket on server: ${response.reasonPhrase}');
        return locallyUpdated;
      }
    } catch (e) {
      debugPrint('Error updating ticket: $e');
      return false;
    }
  }

  static Future<bool> closeTicket(String ticketId) async {
    return await updateTicketStatus(ticketId, 'Completed');
  }

  static String _formatDate(String? apiDate) {
    if (apiDate == null) return 'N/A';

    try {
      final dateTime = DateTime.parse(apiDate);
      final month = _getMonthName(dateTime.month);
      return '$month ${dateTime.day}, ${dateTime.year}';
    } catch (e) {
      return apiDate;
    }
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  static void clearTickets() {
    _tickets.clear();
  }
}
