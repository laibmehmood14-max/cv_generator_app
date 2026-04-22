import 'dart:io';

class CVData {
  String name;
  String phone;
  String email;
  String city;
  String github;
  String objective;
  String education;
  String skills;
  String experience;
  String certificates;
  File? profileImage;

  CVData({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.city = '',
    this.github = '',
    this.objective = '',
    this.education = '',
    this.skills = '',
    this.experience = '',
    this.certificates = '',
    this.profileImage,
  });
}
