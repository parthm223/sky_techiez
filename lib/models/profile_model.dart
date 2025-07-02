class ProfileModel {
  User? user;

  ProfileModel({this.user});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? accountId;
  String? phone;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? profileUrl;
  String? fullName;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.dob,
    this.accountId,
    this.phone,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.profileUrl,
    this.fullName,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    accountId = json['account_id'];
    phone = json['phone'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileUrl = json['profile_url'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['dob'] = dob;
    data['account_id'] = accountId;
    data['phone'] = phone;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['profile_url'] = profileUrl;
    data['full_name'] = fullName;
    return data;
  }
}
