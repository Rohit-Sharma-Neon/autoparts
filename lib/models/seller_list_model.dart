class SellerListResponse {
  bool? success;
  String? msg;
  Result? result;

  SellerListResponse({this.success, this.msg, this.result});

  SellerListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }


}

class Result {
  int? count;
  List<SellerList>? rows;

  Result({this.count, this.rows});

  Result.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <SellerList>[];
      json['rows'].forEach((v) {
        rows!.add(new SellerList.fromJson(v));
      });
    }
  }

}

class SellerList {
  String? image;
  int? isFav;
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? mobile;
  String? userType;
  String? nationality;
  String? gender;
  String? featured;
  String? sellerVerify;
  var totalRate;
  var avgRate;
  //List<Null>? dealerCategories;

  SellerList(
      {this.image,
        this.isFav,
        this.id,
        this.name,
        this.email,
        this.countryCode,
        this.mobile,
        this.sellerVerify,
        this.userType,
        this.nationality,
        this.gender,
        this.featured,
        this.totalRate,
        this.avgRate,
        });

  SellerList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    isFav = json['is_fav'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    sellerVerify = json['seller_verify'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    userType = json['user_type'];
    nationality = json['nationality'];
    gender = json['gender'];
    featured = json['featured'];
    totalRate = json['total_rate'];
    avgRate = json['avg_rate'];
    // if (json['dealer_categories'] != null) {
    //   dealerCategories = <Null>[];
    //   json['dealer_categories'].forEach((v) {
    //     dealerCategories!.add(new Null.fromJson(v));
    //   });
    // }
  }


}
