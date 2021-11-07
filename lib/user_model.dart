// ignore_for_file: prefer_const_declarations

final String tableName = "user_preferences";
class UserFields {
  final String id = "_id";
  final String name  = "Name";
  final String firstTime = "firstTime";
  final String hasPin    = "hasPin";
  final String phoneNumber = "phoneNumber";
  final String password = "password";
  final String pin = "pin";
  final String username = "username";
  final String profilePhoto = "profilePhoto";
}
class User{
  final int? id;
  final String? name;
  final bool? firstTime;
  final bool? hasPin;
  final String? phoneNumber;
  final String? profilePhoto;
  final DateTime createdTime;
  final String?  username;
  final String? password;
  final String? pin;

  const User({
    this.id,
    required this.name,
    required this.createdTime,
    required this.firstTime,
    required this.hasPin,
    required this.phoneNumber,
    required this.profilePhoto,
    this.pin,
    required this.password,
    this.username
});

}