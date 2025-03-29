class User {
  final String firstName;
  final String lastName;
  final String email;
  final String? profileUrl;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileUrl,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      profileUrl: map['profileUrl'],
    );
  }

  String get fullName => '$firstName $lastName';
}
