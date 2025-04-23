class Service {
  final int id;
  final String name;
  final String description;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String serviceIcon;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceIcon,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      serviceIcon: json['service_icon'],
    );
  }

  // Extract features from HTML description
  List<String> get features {
    // Simple parser to extract list items from HTML
    final RegExp featureRegex = RegExp(r'<p>–\s*(.*?)<\/p>');
    final matches = featureRegex.allMatches(description);
    
    if (matches.isEmpty) {
      return ['No features available'];
    }
    
    return matches.map((match) => match.group(1) ?? '').toList();
  }
}