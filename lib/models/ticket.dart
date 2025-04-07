class Ticket {
  final String id;
  final String subject;
  final String category;
  final String? technicalSupportType;
  final String priority;
  final String description;
  final String status;
  final String date;

  Ticket({
    required this.id,
    required this.subject,
    required this.category,
    this.technicalSupportType,
    required this.priority,
    required this.description,
    required this.status,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'category': category,
      'technicalSupportType': technicalSupportType,
      'priority': priority,
      'description': description,
      'status': status,
      'date': date,
    };
  }
}
