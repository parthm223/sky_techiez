class ProfileResponse {
  final bool success;
  final String message;
  final UserProfile? data;

  ProfileResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserProfile.fromJson(json['data']) : null,
    );
  }
}

class UserProfile {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? dob;
  final String? profileUrl;
  final String? accountId;
  final bool? isVerified;
  final String? createdAt;
  final String? updatedAt;

  UserProfile({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.dob,
    this.profileUrl,
    this.accountId,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      profileUrl: json['profile_url'],
      accountId: json['account_id'],
      isVerified: json['is_verified'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}