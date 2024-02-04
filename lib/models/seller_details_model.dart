class SellerDetailsResponse {
  bool? success;
  String? msg;
  SellerDetail? result;

  SellerDetailsResponse({this.success, this.msg, this.result});

  SellerDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
    json['result'] != null ? new SellerDetail.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class SellerDetail {
  UserResult? userResult;
  List<Products>? products;

  SellerDetail({this.userResult, this.products});

  SellerDetail.fromJson(Map<String, dynamic> json) {
    userResult = json['user_result'] != null
        ? new UserResult.fromJson(json['user_result'])
        : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userResult != null) {
      data['user_result'] = this.userResult!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserResult {
  String? image;
  int? isFav;
  int? distance;
  int? id;
  var name;
  var email;
  String? countryCode;
  String? sellerVerify;
  String? mobile;
  var userType;
  var address;
  var latitude;
  var longitude;
  var nationality;
  var gender;
  var featured;
  String? isStatus;
  int? productSold;
  var totalRate;
  var avgRate;
  //List<Null>? dealerCategories;

  UserResult(
      {this.image,
        this.isFav,
        this.distance,
        this.sellerVerify,
        this.id,
        this.productSold,
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
        });

  UserResult.fromJson(Map<String, dynamic> json) {
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
    sellerVerify = json['seller_verify'];
    nationality = json['nationality'];
    gender = json['gender'];
    featured = json['featured'];
    productSold = json['product_sold'];
    isStatus = json['is_status'];
    totalRate = json['total_rate'];
    avgRate = json['avg_rate'];
    // if (json['dealer_categories'] != null) {
    //   dealerCategories = <Null>[];
    //   json['dealer_categories'].forEach((v) {
    //     dealerCategories!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['is_fav'] = this.isFav;
    data['distance'] = this.distance;
    data['id'] = this.id;
    data['seller_verify'] = this.sellerVerify;
    data['name'] = this.name;
    data['email'] = this.email;
    data['product_sold'] = this.productSold;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['user_type'] = this.userType;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['nationality'] = this.nationality;
    data['gender'] = this.gender;
    data['featured'] = this.featured;
    data['is_status'] = this.isStatus;
    data['total_rate'] = this.totalRate;
    data['avg_rate'] = this.avgRate;
    // if (this.dealerCategories != null) {
    //   data['dealer_categories'] =
    //       this.dealerCategories!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Products {
  String? imageUrl;
  int? id;
  String? name;
  int? isFav=0;
  var descriptions;
  int? categoryId;
  String? partNumber;
  String? hsNumber;
  String? featured;
  String? video;
  int? qty;
  String? price;
  var weight;
  var unit;
  Categories? categories;
  String? partCondition;
  String? isStatus;

  Products(
      {this.imageUrl,
        this.id,
        this.name,
        this.descriptions,
        this.isFav,
        this.categoryId,
        this.categories,
        this.partNumber,
        this.hsNumber,
        this.featured,
        this.video,
        this.qty,
        this.price,
        this.weight,
        this.unit,
        this.partCondition,
        this.isStatus});

  Products.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    id = json['id'];
    name = json['name'];
    descriptions = json['descriptions'];
    categoryId = json['categoryId'];
    partNumber = json['part_number'];
    isFav = json['is_fav'];
    categories = json['categories'] != null
        ? new Categories.fromJson(json['categories'])
        : null;
    hsNumber = json['hs_number'];
    featured = json['featured'];
    video = json['video'];
    qty = json['qty'];
    price = json['price'];
    weight = json['weight'];
    unit = json['unit'];
    partCondition = json['part_condition'];
    isStatus = json['is_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.categories != null) {
      data['categories'] = this.categories!.toJson();
    }
    data['descriptions'] = this.descriptions;
    data['categoryId'] = this.categoryId;
    data['part_number'] = this.partNumber;
    data['hs_number'] = this.hsNumber;
    data['featured'] = this.featured;
    data['video'] = this.video;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['weight'] = this.weight;
    data['unit'] = this.unit;
    data['part_condition'] = this.partCondition;
    data['is_status'] = this.isStatus;
    return data;
  }
}

class Categories {
  int? id;
  String? name;

  Categories({this.id, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}