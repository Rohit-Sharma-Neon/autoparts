class DealerListResponse {
  bool? success;
  String? msg;
  Result? result;

  DealerListResponse({this.success, this.msg, this.result});

  DealerListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
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

class Result {
  int? count;
  List<DealerList>? rows;

  Result({this.count, this.rows});

  Result.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <DealerList>[];
      json['rows'].forEach((v) {
        rows!.add(new DealerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DealerList {
  String? image;
  int? isFav;
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? mobile;
  String? userType;
  var nationality;
  String? gender;
  String? featured;
  var totalRate;
  var avgRate;
  List<DealerCategories>? dealerCategories;

  DealerList(
      {this.image,
        this.isFav,
        this.id,
        this.name,
        this.email,
        this.countryCode,
        this.mobile,
        this.userType,
        this.nationality,
        this.gender,
        this.featured,
        this.totalRate,
        this.avgRate,
        this.dealerCategories});

  DealerList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    isFav = json['is_fav'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    userType = json['user_type'];
    nationality = json['nationality'];
    gender = json['gender'];
    featured = json['featured'];
    totalRate = json['total_rate'];
    avgRate = json['avg_rate'];
    if (json['dealer_categories'] != null) {
      dealerCategories = <DealerCategories>[];
      json['dealer_categories'].forEach((v) {
        dealerCategories!.add(new DealerCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['is_fav'] = this.isFav;
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['user_type'] = this.userType;
    data['nationality'] = this.nationality;
    data['gender'] = this.gender;
    data['featured'] = this.featured;
    data['total_rate'] = this.totalRate;
    data['avg_rate'] = this.avgRate;
    if (this.dealerCategories != null) {
      data['dealer_categories'] =
          this.dealerCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DealerCategories {
  int? categoryId;
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
