import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/models/ticket.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class TicketService {
  // Existing methods...

  static List<Ticket> _tickets = [];

  static List<Ticket> getAllTickets() {
    return _tickets;
  }

  static void addTicket(Ticket ticket) {
    _tickets.add(ticket);
  }

  static Future<Ticket?> getTicketById(String id) async {
    // First check local tickets
    for (var ticket in _tickets) {
      if (ticket.id == id) {
        return ticket;
      }
    }

    // If not found locally, try to fetch from API
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

  // New method to fetch tickets from API
  static Future<List<Ticket>> fetchTicketsFromApi() async {
    debugPrint('Fetching tickets from API...');

    var headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
    };

    try {
      var request = http.Request(
          'GET', Uri.parse('https://tech.skytechiez.co/api/my-tickets'));
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
            // Convert API ticket format to our Ticket model
            final ticket = Ticket(
              id: ticketData['ticket_id'] ?? ticketData['id'].toString(),
              subject: ticketData['subject'] ?? 'No Subject',
              category: ticketData['category_id'] ?? 'General',
              technicalSupportType: ticketData['category_sub_id'],
              priority: ticketData['priority'] ?? 'Medium',
              description: ticketData['description'] ?? 'No description',
              status: ticketData['status'] ?? 'Pending',
              date: _formatDate(ticketData['created_at']),
            );

            apiTickets.add(ticket);

            // Update local cache if this ticket doesn't exist locally
            bool exists = false;
            for (var localTicket in _tickets) {
              if (localTicket.id == ticket.id) {
                exists = true;
                break;
              }
            }

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

  // New method to update ticket status
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
      // First update locally
      bool locallyUpdated = false;
      for (int i = 0; i < _tickets.length; i++) {
        if (_tickets[i].id == ticketId) {
          _tickets[i] = Ticket(
            id: _tickets[i].id,
            subject: _tickets[i].subject,
            category: _tickets[i].category,
            technicalSupportType: _tickets[i].technicalSupportType,
            priority: _tickets[i].priority,
            description: _tickets[i].description,
            status: newStatus,
            date: _tickets[i].date,
          );
          locallyUpdated = true;
          break;
        }
      }

      // Then try to update on the server
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
        // Return true if at least locally updated
        return locallyUpdated;
      }
    } catch (e) {
      debugPrint('Error updating ticket: $e');
      return false;
    }
  }

  // New method to close a ticket
  static Future<bool> closeTicket(String ticketId) async {
    return await updateTicketStatus(ticketId, 'Completed');
  }

  // Helper method to format date from API
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

  // Clear all tickets (for testing)
  static void clearTickets() {
    _tickets.clear();
  }
}
