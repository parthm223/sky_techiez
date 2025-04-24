class Ticket {
  int? id;
  final String ticketId;
  final String subject;
  final String categoryId;
  final String? subcategoryId;
  final String categoryName;
  final String? subcategoryName;
  final String priority;
  final String description;
  final String status;
  final String date;

  Ticket({
    this.id,
    required this.ticketId,
    required this.subject,
    required this.categoryId,
    this.subcategoryId,
    required this.categoryName,
    this.subcategoryName,
    required this.priority,
    required this.description,
    required this.status,
    required this.date,
  });

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: (map['id']),
      ticketId: (map['ticket_id']).toString(),
      subject: map['subject']?.toString() ?? 'No Subject',
      categoryId: map['category_id']?.toString() ?? '0',
      subcategoryId: map['category_sub_id']?.toString(),
      categoryName: map['category_name']?.toString() ?? 'General',
      subcategoryName: map['sub_category_name']?.toString(),
      priority: map['priority']?.toString() ?? 'Medium',
      description: map['description']?.toString() ?? 'No description',
      status: map['status']?.toString() ?? 'Pending',
      date: map['date']?.toString() ??
          'N/A', // You can customize if formatting is needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'subject': subject,
      'category_id': categoryId,
      'category_sub_id': subcategoryId,
      'category_name': categoryName,
      'sub_category_name': subcategoryName,
      'priority': priority,
      'description': description,
      'status': status,
      'date': date,
    };
  }
}
