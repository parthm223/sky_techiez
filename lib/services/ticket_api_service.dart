// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:sky_techiez/models/ticket.dart';
// // import 'package:sky_techiez/models/ticket_response.dart';

// class TicketApiService {
//   static Future<List<Ticket>> fetchUserTickets(String authToken) async {
//     final headers = {
//       'X-Requested-With': 'XMLHttpRequest',
//       'Authorization': authToken,
//     };

//     final response = await http.get(
//       Uri.parse('https://tech.skytechiez.co/api/my-tickets'),
//       headers: headers,
//     );

//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       final ticketResponse = TicketResponse.fromJson(jsonResponse);
//       return ticketResponse.tickets;
//     } else {
//       throw Exception('Failed to load tickets: ${response.reasonPhrase}');
//     }
//   }
// }
