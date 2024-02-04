class HomeDataModel {
  bool? success;
  String? msg;
  Result? result;

  HomeDataModel({this.success, this.msg, this.result});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
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
  List<BannerList>? banner;
  List<TopCategories>? topCategories;
  List<Dealers>? dealers;
  List<BannerOne>? bannerOne;
  List<Sellers>? sellers;
  List<FeaturedCar>? featuredCar;
  List<TopProductForSale>? topProductForSale;
  List<TopCarsForSale>? topCarsForSale;
  List<FeaturedProduct>? featuredProduct;
  int? notificationCount;
  int? messageCount;

  Result(
      {this.banner,
      this.topCategories,
      this.dealers,
      this.sellers,
        this.featuredCar,
        this.topProductForSale,
        this.bannerOne,
      this.topCarsForSale,
      this.featuredProduct,
      this.notificationCount,
        this.messageCount
      });

  Result.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = <BannerList>[];
      json['banner'].forEach((v) {
        banner!.add(new BannerList.fromJson(v));
      });
    }
    if (json['featured_car'] != null) {
      featuredCar = <FeaturedCar>[];
      json['featured_car'].forEach((v) {
        featuredCar!.add(new FeaturedCar.fromJson(v));
      });
    }
    if (json['top_product_for_sale'] != null) {
      topProductForSale = <TopProductForSale>[];
      json['top_product_for_sale'].forEach((v) {
        topProductForSale!.add(new TopProductForSale.fromJson(v));
      });
    }
    if (json['banner_one'] != null) {
      bannerOne = <BannerOne>[];
      json['banner_one'].forEach((v) {
        bannerOne!.add(new BannerOne.fromJson(v));
      });
    }
    if (json['top_categories'] != null) {
      topCategories = <TopCategories>[];
      json['top_categories'].forEach((v) {
        topCategories!.add(new TopCategories.fromJson(v));
      });
    }
    if (json['dealers'] != null) {
      dealers = <Dealers>[];
      json['dealers'].forEach((v) {
        dealers!.add(new Dealers.fromJson(v));
      });
    }
    if (json['sellers'] != null) {
      sellers = <Sellers>[];
      json['sellers'].forEach((v) {
        sellers!.add(new Sellers.fromJson(v));
      });
    }
    if (json['top_cars_for_sale'] != null) {
      topCarsForSale = <TopCarsForSale>[];
      json['top_cars_for_sale'].forEach((v) {
        topCarsForSale!.add(new TopCarsForSale.fromJson(v));
      });
    }
    if (json['featured_product'] != null) {
      featuredProduct = <FeaturedProduct>[];
      json['featured_product'].forEach((v) {
        featuredProduct!.add(new FeaturedProduct.fromJson(v));
      });
    }
    notificationCount = json['notification_count'];
    messageCount = json['message_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.featuredCar != null) {
      data['featured_car'] = this.featuredCar!.map((v) => v.toJson()).toList();
    }
    if (this.bannerOne != null) {
      data['banner_one'] = this.bannerOne!.map((v) => v.toJson()).toList();
    }
    if (this.topProductForSale != null) {
      data['top_product_for_sale'] =
          this.topProductForSale!.map((v) => v.toJson()).toList();
    }
    if (this.topCategories != null) {
      data['top_categories'] =
          this.topCategories!.map((v) => v.toJson()).toList();
    }
    if (this.dealers != null) {
      data['dealers'] = this.dealers!.map((v) => v.toJson()).toList();
    }
    if (this.sellers != null) {
      data['sellers'] = this.sellers!.map((v) => v.toJson()).toList();
    }
    if (this.topCarsForSale != null) {
      data['top_cars_for_sale'] =
          this.topCarsForSale!.map((v) => v.toJson()).toList();
    }
    if (this.featuredProduct != null) {
      data['featured_product'] =
          this.featuredProduct!.map((v) => v.toJson()).toList();
    }
    data['notification_count'] = this.notificationCount;
    data['message_count'] = this.messageCount;
    return data;
  }
}

class BannerList {
  String? bannerImage;
  int? id;
  String? type;
  String? bannerUrl;
  String? isStatus;
  Category? category;

  BannerList(
      {this.bannerImage, this.id, this.type, this.bannerUrl, this.isStatus,
        this.category,
      });

  BannerList.fromJson(Map<String, dynamic> json) {
    bannerImage = json['banner_image'];
    id = json['id'];
    type = json['type'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    bannerUrl = json['banner_url'];
    isStatus = json['is_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_image'] = this.bannerImage;
    data['id'] = this.id;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['type'] = this.type;
    data['banner_url'] = this.bannerUrl;
    data['is_status'] = this.isStatus;
    return data;
  }
}

class Category {
  String? image;
  int? id;
  String? name;

  Category({this.image, this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class TopCategories {
  String? image;
  int? id;
  String? name;

  TopCategories({this.image, this.id, this.name});

  TopCategories.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Dealers {
  String? image;
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? mobile;
  String? featured;
  String? sellerVerify;

  Dealers(
      {this.image,
        this.id,
        this.name,
        this.email,
        this.countryCode,
        this.mobile,
        this.featured,
        this.sellerVerify});

  Dealers.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    featured = json['featured'];
    sellerVerify = json['seller_verify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['featured'] = this.featured;
    data['seller_verify'] = this.sellerVerify;
    return data;
  }
}

class TopCarsForSale {
  String? image;
  int? id;
  int? carCategoryId;
  int? makeId;
  int? modelId;
  String? year;
  int? sellRecordId;
  String? region;
  String? transmissionType;
  String? grade;
  String? engine;
  String? chassisNumber;
  String? totalRunning;
  int? price;
  CarCategory? carCategory;
  Model? model;
  Make? make;
  String? kmDriven;

  TopCarsForSale(
      {this.image,
      this.id,
        this.sellRecordId,
      this.carCategoryId,
      this.makeId,
        this.kmDriven,
      this.modelId,
      this.year,
      this.region,
      this.transmissionType,
      this.grade,
      this.engine,
      this.chassisNumber,
      this.totalRunning,
      this.price,
      this.carCategory,
      this.model,
      this.make});

  TopCarsForSale.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    kmDriven = json['km_driven'];
    sellRecordId = json['sell_record_id'];
    carCategoryId = json['carCategoryId'];
    makeId = json['makeId'];
    modelId = json['modelId'];
    year = json['year'];
    region = json['region'];
    transmissionType = json['transmission_type'];
    grade = json['grade'];
    engine = json['engine'];
    chassisNumber = json['chassis_number'];
    totalRunning = json['total_running'];
    price = json['price'];
    carCategory = json['car_category'] != null
        ? new CarCategory.fromJson(json['car_category'])
        : null;
    model = json['model'] != null ? new Model.fromJson(json['model']) : null;
    make = json['make'] != null ? new Make.fromJson(json['make']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['carCategoryId'] = this.carCategoryId;
    data['makeId'] = this.makeId;
    data['modelId'] = this.modelId;
    data['year'] = this.year;
    data['region'] = this.region;
    data['sell_record_id'] = this.sellRecordId;
    data['km_driven'] = this.kmDriven;
    data['transmission_type'] = this.transmissionType;
    data['grade'] = this.grade;
    data['engine'] = this.engine;
    data['chassis_number'] = this.chassisNumber;
    data['total_running'] = this.totalRunning;
    data['price'] = this.price;
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

class CarCategory {
  String? image;
  int? id;
  String? categoryNo;
  String? name;
  String? lName;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  CarCategory(
      {this.image,
      this.id,
      this.categoryNo,
      this.name,
      this.lName,
      this.isStatus,
      this.createdAt,
      this.updatedAt});

  CarCategory.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    categoryNo = json['categoryNo'];
    name = json['name'];
    lName = json['l_name'];
    isStatus = json['is_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['categoryNo'] = this.categoryNo;
    data['name'] = this.name;
    data['l_name'] = this.lName;
    data['is_status'] = this.isStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Model {
  int? id;
  int? makeId;
  String? code;
  String? title;
  var lTitle;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  Model(
      {this.id,
      this.makeId,
      this.code,
      this.title,
      this.lTitle,
      this.isStatus,
      this.createdAt,
      this.updatedAt});

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    makeId = json['make_id'];
    code = json['code'];
    title = json['title'];
    lTitle = json['l_title'];
    isStatus = json['is_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['make_id'] = this.makeId;
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
  var lTitle;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  Make(
      {this.image,
      this.id,
      this.code,
      this.title,
      this.lTitle,
      this.isStatus,
      this.createdAt,
      this.updatedAt});

  Make.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    code = json['code'];
    title = json['title'];
    lTitle = json['l_title'];
    isStatus = json['is_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['code'] = this.code;
    data['title'] = this.title;
    data['l_title'] = this.lTitle;
    data['is_status'] = this.isStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class FeaturedProduct {
  String? imageUrl;
  int? id;
  String? productNo;
  int? categoryId;
  var descriptions;
  String? name;
  String? partNumber;
  String? partCondition;
  String? hsNumber;
  String? featured;
  String? video;
  int? qty;
  String? price;
  var weight;
  var unit;

  FeaturedProduct(
      {this.imageUrl,
      this.id,
      this.productNo,
      this.categoryId,
      this.descriptions,
      this.name,
      this.partNumber,
      this.partCondition,
      this.hsNumber,
      this.featured,
      this.video,
      this.qty,
      this.price,
      this.weight,
      this.unit});

  FeaturedProduct.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    id = json['id'];
    productNo = json['productNo'];
    categoryId = json['categoryId'];
    descriptions = json['descriptions'];
    name = json['name'];
    partNumber = json['part_number'];
    partCondition = json['part_condition'];
    hsNumber = json['hs_number'];
    featured = json['featured'];
    video = json['video'];
    qty = json['qty'];
    price = json['price'];
    weight = json['weight'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['id'] = this.id;
    data['productNo'] = this.productNo;
    data['categoryId'] = this.categoryId;
    data['descriptions'] = this.descriptions;
    data['name'] = this.name;
    data['part_number'] = this.partNumber;
    data['part_condition'] = this.partCondition;
    data['hs_number'] = this.hsNumber;
    data['featured'] = this.featured;
    data['video'] = this.video;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['weight'] = this.weight;
    data['unit'] = this.unit;
    return data;
  }
}

class Sellers {
  String? image;
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? mobile;
  String? featured;
  String? sellerVerify;
  var totalRate;
  var avgRate;

  Sellers(
      {this.image,
        this.id,
        this.name,
        this.email,
        this.countryCode,
        this.mobile,
        this.featured,
        this.sellerVerify,
        this.totalRate,
        this.avgRate});

  Sellers.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    featured = json['featured'];
    sellerVerify = json['seller_verify'];
    totalRate = json['total_rate'];
    avgRate = json['avg_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['featured'] = this.featured;
    data['seller_verify'] = this.sellerVerify;
    data['total_rate'] = this.totalRate;
    data['avg_rate'] = this.avgRate;
    return data;
  }
}

class BannerOne {
  String? bannerImage;
  int? id;
  String? type;
  String? bannerUrl;
  String? isStatus;
  User? user;

  BannerOne(
      {this.bannerImage, this.id, this.type, this.bannerUrl, this.isStatus,
        this.user
      });

  BannerOne.fromJson(Map<String, dynamic> json) {
    bannerImage = json['banner_image'];
    id = json['id'];
    type = json['type'];
    bannerUrl = json['banner_url'];
    isStatus = json['is_status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_image'] = this.bannerImage;
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['type'] = this.type;
    data['banner_url'] = this.bannerUrl;
    data['is_status'] = this.isStatus;
    return data;
  }
}

class User {
  int? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
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

class TopProductForSale {
  String? imageUrl;
  int? id;
  String? productNo;
  int? categoryId;
  String? descriptions;
  String? name;
  String? partNumber;
  String? partCondition;
  String? hsNumber;
  String? featured;
  String? video;
  int? qty;
  String? price;
  var weight;
  var unit;

  TopProductForSale(
      {this.imageUrl,
        this.id,
        this.productNo,
        this.categoryId,
        this.descriptions,
        this.name,
        this.partNumber,
        this.partCondition,
        this.hsNumber,
        this.featured,
        this.video,
        this.qty,
        this.price,
        this.weight,
        this.unit});

  TopProductForSale.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    id = json['id'];
    productNo = json['productNo'];
    categoryId = json['categoryId'];
    descriptions = json['descriptions'];
    name = json['name'];
    partNumber = json['part_number'];
    partCondition = json['part_condition'];
    hsNumber = json['hs_number'];
    featured = json['featured'];
    video = json['video'];
    qty = json['qty'];
    price = json['price'];
    weight = json['weight'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['id'] = this.id;
    data['productNo'] = this.productNo;
    data['categoryId'] = this.categoryId;
    data['descriptions'] = this.descriptions;
    data['name'] = this.name;
    data['part_number'] = this.partNumber;
    data['part_condition'] = this.partCondition;
    data['hs_number'] = this.hsNumber;
    data['featured'] = this.featured;
    data['video'] = this.video;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['weight'] = this.weight;
    data['unit'] = this.unit;
    return data;
  }
}

class FeaturedCarData {
  List<FeaturedCar>? featuredCar;

  FeaturedCarData({this.featuredCar});

  FeaturedCarData.fromJson(Map<String, dynamic> json) {
    if (json['featured_car'] != null) {
      featuredCar = <FeaturedCar>[];
      json['featured_car'].forEach((v) {
        featuredCar!.add(new FeaturedCar.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.featuredCar != null) {
      data['featured_car'] = this.featuredCar!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeaturedCar {
  String? image;
  int? id;
  int? carCategoryId;
  int? makeId;
  int? modelId;
  String? year;
  String? region;
  String? transmissionType;
  String? grade;
  String? engine;
  String? chassisNumber;
  String? totalRunning;
  int? price;
  String? featured;
  CarCategory? carCategory;
  Model? model;
  Make? make;

  FeaturedCar(
      {this.image,
        this.id,
        this.carCategoryId,
        this.makeId,
        this.modelId,
        this.year,
        this.region,
        this.transmissionType,
        this.grade,
        this.engine,
        this.chassisNumber,
        this.totalRunning,
        this.price,
        this.featured,
        this.carCategory,
        this.model,
        this.make});

  FeaturedCar.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    carCategoryId = json['carCategoryId'];
    makeId = json['makeId'];
    modelId = json['modelId'];
    year = json['year'];
    region = json['region'];
    transmissionType = json['transmission_type'];
    grade = json['grade'];
    engine = json['engine'];
    chassisNumber = json['chassis_number'];
    totalRunning = json['total_running'];
    price = json['price'];
    featured = json['featured'];
    carCategory = json['car_category'] != null
        ? new CarCategory.fromJson(json['car_category'])
        : null;
    model = json['model'] != null ? new Model.fromJson(json['model']) : null;
    make = json['make'] != null ? new Make.fromJson(json['make']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['carCategoryId'] = this.carCategoryId;
    data['makeId'] = this.makeId;
    data['modelId'] = this.modelId;
    data['year'] = this.year;
    data['region'] = this.region;
    data['transmission_type'] = this.transmissionType;
    data['grade'] = this.grade;
    data['engine'] = this.engine;
    data['chassis_number'] = this.chassisNumber;
    data['total_running'] = this.totalRunning;
    data['price'] = this.price;
    data['featured'] = this.featured;
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


