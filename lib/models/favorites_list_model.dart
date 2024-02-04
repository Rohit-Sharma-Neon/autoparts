class FavoritesListResponse {
  bool? success;
  String? msg;
  List<FavoritesList>? result;

  FavoritesListResponse({this.success, this.msg, this.result});

  FavoritesListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    if (json['result'] != null) {
      result = <FavoritesList>[];
      json['result'].forEach((v) {
        result!.add(FavoritesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FavoritesList {
  int? id;
  String? userId;
  String? productId;
  Products? products;

  FavoritesList({this.id, this.userId, this.productId, this.products});

  FavoritesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    productId = json['productId'];
    products = json['products'] != null
        ? Products.fromJson(json['products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['productId'] = this.productId;
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    return data;
  }
}

class Products {
  int? id;
  String? name;
  int? distance;
  String? email;
  String? countryCode;
  String? mobile;
  String? userType;
  String? address;
  String? latitude;
  String? longitude;
  String? nationality;
  String? gender;
  var featured;
  var totalRate;
  var avgRate;
  String? weight;
  String? unit;
  var price;
  String? imageUrl;
  String? imageWidth;
  String? isStatus;
  String? imageHeight;
  List<DealerCategories>? dealerCategories;
  /// cars
  int? carCategoryId;
  int? makeId;
  int? modelId;
  String? year;
  String? region;
  String? transmissionType;
  String? grade;
  String? engine;
  String? chassisNumber;
  String? image;
  String? totalRunning;
  CarCategory? carCategory;
  Model? model;
  Make? make;

  Products(
      {this.id,
        this.name,
        this.distance,
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
        this.totalRate,
        this.avgRate,
        this.weight,
        this.unit,
        this.price,
        this.imageUrl,
        this.imageWidth,
        this.isStatus,
        this.imageHeight,
        this.dealerCategories,
        /// Cars
        this.carCategoryId,
        this.makeId,
        this.modelId,
        this.year,
        this.region,
        this.transmissionType,
        this.grade,
        this.engine,
        this.chassisNumber,
        this.image,
        this.totalRunning,
        this.carCategory,
        this.model,
        this.make,
      });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    distance = json['distance'];
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
    totalRate = json['total_rate'];
    avgRate = json['avg_rate'];
    weight = json['weight'];
    unit = json['unit'];
    price = json['price'];
    imageUrl = json['image_url'];
    imageWidth = json['image_width'];
    isStatus = json['is_status'];
    imageHeight = json['image_height'];
    if (json['dealer_categories'] != null) {
      dealerCategories = <DealerCategories>[];
      json['dealer_categories'].forEach((v) {
        dealerCategories!.add(DealerCategories.fromJson(v));
      });
    }
    carCategoryId = json['carCategoryId'];
    makeId = json['makeId'];
    modelId = json['modelId'];
    year = json['year'];
    region = json['region'];
    transmissionType = json['transmission_type'];
    grade = json['grade'];
    engine = json['engine'];
    chassisNumber = json['chassis_number'];
    image = json['image'];
    totalRunning = json['total_running'];
    carCategory = json['car_category'] != null
        ? CarCategory.fromJson(json['car_category'])
        : null;
    model = json['model'] != null ? Model.fromJson(json['model']) : null;
    make = json['make'] != null ? Make.fromJson(json['make']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['distance'] = this.distance;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['user_type'] = this.userType;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['nationality'] = this.nationality;
    data['gender'] = this.gender;
    data['featured'] = this.featured;
    data['total_rate'] = this.totalRate;
    data['avg_rate'] = this.avgRate;
    data['weight'] = this.weight;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['image_url'] = this.imageUrl;
    data['image_width'] = this.imageWidth;
    data['is_status'] = this.isStatus;
    data['image_height'] = this.imageHeight;
    if (this.dealerCategories != null) {
      data['dealer_categories'] =
          this.dealerCategories!.map((v) => v.toJson()).toList();
    }
    data['carCategoryId'] = this.carCategoryId;
    data['makeId'] = this.makeId;
    data['modelId'] = this.modelId;
    data['year'] = this.year;
    data['region'] = this.region;
    data['transmission_type'] = this.transmissionType;
    data['grade'] = this.grade;
    data['engine'] = this.engine;
    data['chassis_number'] = this.chassisNumber;
    data['image'] = this.image;
    data['total_running'] = this.totalRunning;
    if (this.carCategory != null) {
      data['car_category'] = this.carCategory!.toJson();
    }
    if (this.model != null) {
      data['model'] = this.model!.toJson();
    }
    if (this.make != null) {
      data['make'] = this.make!.toJson();
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
        ? Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class CarCategory {
  String? image;
  int? id;
  String? categoryNo;
  int? globalCategoryId;
  String? name;
  String? lName;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  CarCategory(
      {this.image,
        this.id,
        this.categoryNo,
        this.globalCategoryId,
        this.name,
        this.lName,
        this.isStatus,
        this.createdAt,
        this.updatedAt});

  CarCategory.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    categoryNo = json['categoryNo'];
    globalCategoryId = json['globalCategoryId'];
    name = json['name'];
    lName = json['l_name'];
    isStatus = json['is_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['categoryNo'] = this.categoryNo;
    data['globalCategoryId'] = this.globalCategoryId;
    data['name'] = this.name;
    data['l_name'] = this.lName;
    data['is_status'] = this.isStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Model {
  String? image;
  int? id;
  int? makeId;
  String? code;
  String? title;
  String? lTitle;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  Model(
      {this.image,
        this.id,
        this.makeId,
        this.code,
        this.title,
        this.lTitle,
        this.isStatus,
        this.createdAt,
        this.updatedAt});

  Model.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    makeId = json['makeId'];
    code = json['code'];
    title = json['title'];
    lTitle = json['l_title'];
    isStatus = json['is_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['makeId'] = this.makeId;
    data['code'] = this.code;
    data['title'] = this.title;
    data['l_title'] = this.lTitle;
    data['is_status'] = this.isStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Make {
  String? image;
  int? id;
  String? code;
  String? title;
  String? lTitle;
  Null? modelsCount;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  Make(
      {this.image,
        this.id,
        this.code,
        this.title,
        this.lTitle,
        this.modelsCount,
        this.isStatus,
        this.createdAt,
        this.updatedAt});

  Make.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    code = json['code'];
    title = json['title'];
    lTitle = json['l_title'];
    modelsCount = json['modelsCount'];
    isStatus = json['is_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['code'] = this.code;
    data['title'] = this.title;
    data['l_title'] = this.lTitle;
    data['modelsCount'] = this.modelsCount;
    data['is_status'] = this.isStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
