import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
  String? name;
  String? email;
  String? profilePicURL;
  String? gender;
  String? userId;
  String? address;
  String? city;
  String? zipCode;
  String? phone;

  UserModel({
    this.name,
    this.email,
    this.profilePicURL,
    this.gender,
    this.userId,
    this.address,
    this.city,
    this.zipCode,
    this.phone,
  });
}
