class DealerDetailsResponse {
  bool? success;
  String? msg;
  DealerDetails? result;

  DealerDetailsResponse({this.success, this.msg, this.result});

  DealerDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
    json['result'] != null ? DealerDetails.fromJson(json['result']) : null;
  }


}

class DealerDetails {
  String? image;
  int? isFav;
  int? distance;
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? mobile;
  String? userType;
  var address;
  var latitude;
  var longitude;
  var nationality;
  var gender;
  String? featured;
  String? isStatus;
  var totalRate;
  var avgRate;
  List<DealerCategories>?   dealerCategories;

  DealerDetails(
      {this.image,
        this.isFav,
        this.distance,
        this.id,
        this.name,
        this.email,
        this.countryCode,
        this.mobile,
        this.userType,
        this.address,
        this.latitude,
        this.longitude,
        this.nationality,
        this.gender,
        this.featured,
        this.isStatus,
        this.totalRate,
        this.avgRate,
        this.dealerCategories});

  DealerDetails.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    isFav = json['is_fav'];
    distance = json['distance'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    userType = json['user_type'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    nationality = json['nationality'];
    gender = json['gender'];
    featured = json['featured'];
    isStatus = json['is_status'];
    totalRate = json['total_rate'];
    avgRate = json['avg_rate'];
    if (json['dealer_categories'] != null) {
      dealerCategories = <DealerCategories>[];
      json['dealer_categories'].forEach((v) {
        dealerCategories!.add(new DealerCategories.fromJson(v));
      });
    }
  }

}

class DealerCategories {
  int? categoryId;
  bool isSelect=false;
  Category? category;

  DealerCategories({this.categoryId, this.category});

  DealerCategories.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  String? name;

  Category({this.name});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
