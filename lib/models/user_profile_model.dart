class UserProfileModel {
  bool? success;
  String? msg;
  UserProfileData? result;

  UserProfileModel({this.success, this.msg, this.result});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
    json['result'] != null ?  UserProfileData.fromJson(json['result']) : null;
  }
}

class UserProfileData {
  String? image;
  String? headerImage;
  String? businessLogo;
  String? tradeLicense;
  int? id;
  dynamic userNo;
  String? name;
  String? businessName;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  dynamic whatsappCountryCode;
  dynamic whatsappMobile;
  String? password;
  String? token;
  String? userType;
  String? dob;
  String? nationality;
  dynamic interest;
  dynamic socialId;
  dynamic socialType;
  String? gender;
  String? deviceType;
  String? deviceToken;
  dynamic address;
  dynamic latitude;
  dynamic longitude;
  var isVerify;
  var isEmailVerify;
  String? becomeASeller;
  var isStatus;
  var isOnline;
  int? walletAmount;
  String? points;
  String? createdAt;
  String? updatedAt;

  UserProfileData(
      {this.image,
        this.headerImage,
        this.businessLogo,
        this.tradeLicense,
        this.id,
        this.userNo,
        this.businessName,
        this.name,
        this.firstName,
        this.lastName,
        this.email,
        this.countryCode,
        this.mobile,
        this.whatsappCountryCode,
        this.whatsappMobile,
        this.password,
        this.token,
        this.becomeASeller,
        this.userType,
        this.dob,
        this.nationality,
        this.interest,
        this.socialId,
        this.socialType,
        this.gender,
        this.deviceType,
        this.deviceToken,
        this.address,
        this.latitude,
        this.longitude,
        this.isVerify,
        this.isEmailVerify,
        this.isStatus,
        this.isOnline,
        this.walletAmount,
        this.points,
        this.createdAt,
        this.updatedAt});

  UserProfileData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    headerImage = json['header_image'];
    businessName = json['business_name'];
    businessLogo = json['business_logo'];
    tradeLicense = json['trade_license'];
    id = json['id'];
    userNo = json['userNo'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    whatsappCountryCode = json['whatsapp_country_code'];
    whatsappMobile = json['whatsapp_mobile'];
    password = json['password'];
    token = json['token'];
    userType = json['user_type'];
    dob = json['dob'];
    nationality = json['nationality'];
    becomeASeller = json['become_a_seller'];
    interest = json['interest'];
    socialId = json['social_id'];
    socialType = json['social_type'];
    gender = json['gender'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isVerify = json['is_verify'];
    isEmailVerify = json['is_email_verify'];
    isStatus = json['is_status'];
    isOnline = json['is_online'];
    walletAmount = json['wallet_amount'];
    points = json['points'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
