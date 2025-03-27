import 'dart:io';

class UserData {
  String firstName = '';
  String lastName = '';
  String dob = '';
  String email = '';
  String phone = '';
  String password = '';
  File? profileImage;

  UserData({
    this.firstName = '',
    this.lastName = '',
    this.dob = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.profileImage,
  });
}

