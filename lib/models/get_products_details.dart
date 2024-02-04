class GetProductDetails {
  bool? success;
  String? msg;
  ResultData? result;

  GetProductDetails({this.success, this.msg, this.result});

  GetProductDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
    json['result'] != null ? new ResultData.fromJson(json['result']) : null;
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

class ResultData {
  String? imageUrl;
  int? id;
  String? name;
  String? descriptions;
  int? categoryId;
  String? partNumber;
  String? hsNumber;
  String? featured;
  String? video;
  int? qty;
  String? price;
  var weight;
  var unit;
  String? partCondition;
  String? isStatus;
  Category? category;
  int? isFav;
  List<Dealers>? dealers;

  ResultData(
      {this.imageUrl,
        this.id,
        this.name,
        this.isFav,
        this.descriptions,
        this.categoryId,
        this.partNumber,
        this.hsNumber,
        this.featured,
        this.video,
        this.qty,
        this.price,
        this.weight,
        this.unit,
        this.partCondition,
        this.isStatus,
        this.category,
        this.dealers});

  ResultData.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    id = json['id'];
    name = json['name'];
    descriptions = json['descriptions'];
    categoryId = json['categoryId'];
    partNumber = json['part_number'];
    hsNumber = json['hs_number'];
    featured = json['featured'];
    video = json['video'];
    qty = json['qty'];
    isFav = json['is_fav'];
    price = json['price'];
    weight = json['weight'];
    unit = json['unit'];
    partCondition = json['part_condition'];
    isStatus = json['is_status'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['dealers'] != null) {
      dealers = <Dealers>[];
      json['dealers'].forEach((v) {
        dealers!.add(new Dealers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['id'] = this.id;
    data['name'] = this.name;
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
    data['is_fav'] = this.isFav;
    data['part_condition'] = this.partCondition;
    data['is_status'] = this.isStatus;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.dealers != null) {
      data['dealers'] = this.dealers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
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

class Dealers {
  int? userId;
  int? categoryId;
  String? isReminder;
  User? user;

  Dealers({this.userId, this.categoryId, this.isReminder, this.user});

  Dealers.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    categoryId = json['categoryId'];
    isReminder = json['is_reminder'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['categoryId'] = this.categoryId;
    data['is_reminder'] = this.isReminder;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? image;
  int? id;
  String? name;
  String? featured;
  String? countryCode;
  String? mobile;
  String? email;

  User(
      {this.image,
        this.id,
        this.name,
        this.featured,
        this.countryCode,
        this.mobile,
        this.email});

  User.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
    featured = json['featured'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    data['featured'] = this.featured;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    return data;
  }
}
