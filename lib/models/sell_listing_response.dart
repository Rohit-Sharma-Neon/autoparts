class SellListingResponse {
  bool? success;
  String? msg;
  Result? result;


  SellListingResponse({this.success, this.msg, this.result});

  SellListingResponse.fromJson(Map<String, dynamic> json) {
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
  Products? products;

  Result({this.products});

  Result.fromJson(Map<String, dynamic> json) {
    products = json['products'] != null
        ? new Products.fromJson(json['products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    return data;
  }
}

class Products {
  int? totalItems;
  List<SoldData>? data;
  int? totalPages;
  int? limit;
  int? currentPage;

  Products(
      {this.totalItems,
        this.data,
        this.totalPages,
        this.limit,
        this.currentPage});

  Products.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    if (json['data'] != null) {
      data = <SoldData>[];
      json['data'].forEach((v) {
        data!.add(new SoldData.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    limit = json['limit'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalItems'] = this.totalItems;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['limit'] = this.limit;
    data['currentPage'] = this.currentPage;
    return data;
  }
}

class SoldData {
  int? id;
  int? userId;
  String? sellType;
  int? productId;
  String? description;
  int? price;
  String? productCondition;
  String? lifeExpectancy;
  String? lifeExpectancyType;
  String? warehouseCode;
  var distanceType;
  String? mileage;
  String? mileageType;
  String? warranty;
  String? image;
  String? color;
  var imageTwo;
  var imageThree;
  String? sellStatus;
  String? sellProductType;
  String? createdAt;
  String? video;
  String? descriptions;
  int? categoryId;
  SellData? sellData;
  ProductDetails? products;

  SoldData(
      {this.id,
        this.userId,
        this.sellType,
        this.productId,
        this.description,
        this.price,
        this.categoryId,
        this.video,
        this.descriptions,
        this.color,
        this.sellData,
        this.sellStatus,
        this.sellProductType,
        this.createdAt,
        this.productCondition,
        this.lifeExpectancy,
        this.lifeExpectancyType,
        this.warehouseCode,
        this.distanceType,
        this.mileage,
        this.mileageType,
        this.warranty,
        this.image,
        this.imageTwo,
        this.imageThree,
        this.products});

  SoldData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    sellType = json['sell_type'];
    productId = json['productId'];
    description = json['description'];
    price = json['price'];
    sellData = json['sellData'] != null
        ? new SellData.fromJson(json['sellData'])
        : null;
    sellStatus = json['sell_status'];
    sellProductType = json['sell_product_type'];
    createdAt = json['createdAt'];
    color = json['color'];
    categoryId = json['categoryId'];
    video = json['video'];
    descriptions = json['descriptions'];
    productCondition = json['product_condition'];
    lifeExpectancy = json['life_expectancy'];
    lifeExpectancyType = json['life_expectancy_type'];
    warehouseCode = json['warehouse_code'];
    distanceType = json['distance_type'];
    mileage = json['mileage'];
    mileageType = json['mileage_type'];
    warranty = json['warranty'];
    image = json['image'];
    imageTwo = json['image_two'];
    imageThree = json['image_three'];
    products = json['products'] != null
        ? ProductDetails.fromJson(json['products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['sell_type'] = this.sellType;
    data['productId'] = this.productId;
    data['description'] = this.description;
    data['price'] = this.price;
    data['video'] = this.video;
    data['descriptions'] = this.descriptions;
    data['categoryId'] = this.categoryId;
    data['sell_status'] = this.sellStatus;
    data['sell_product_type'] = this.sellProductType;
    data['createdAt'] = this.createdAt;
    data['color'] = this.color;
    if (this.sellData != null) {
      data['sellData'] = this.sellData!.toJson();
    }
    data['product_condition'] = this.productCondition;
    data['life_expectancy'] = this.lifeExpectancy;
    data['life_expectancy_type'] = this.lifeExpectancyType;
    data['warehouse_code'] = this.warehouseCode;
    data['distance_type'] = this.distanceType;
    data['mileage'] = this.mileage;
    data['mileage_type'] = this.mileageType;
    data['warranty'] = this.warranty;
    data['image'] = this.image;
    data['image_two'] = this.imageTwo;
    data['image_three'] = this.imageThree;
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    return data;
  }
}

class ProductDetails {
  int? id;
  String? name;
  int? distance;
  String? email;
  String? video;
  String? descriptions;
  int? categoryId;
  String? countryCode;
  String? mobile;
  String? userType;
  String? address;
  String? latitude;
  String? longitude;
  String? nationality;
  String? gender;
  String? featured;
  int? totalRate;
  int? avgRate;
  var weight;
  var unit;
  var price;
  String? imageUrl;
  String? imageWidth;
  String? isStatus;
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

  ProductDetails(
      {this.id,
        this.name,
        this.distance,
        this.email,
        this.countryCode,
        this.mobile,
        this.userType,
        this.categoryId,
        this.video,
        this.descriptions,
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
        this.make});

  ProductDetails.fromJson(Map<String, dynamic> json) {
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
    categoryId = json['categoryId'];
    video = json['video'];
    descriptions = json['descriptions'];
    isStatus = json['is_status'];
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
        ? new CarCategory.fromJson(json['car_category'])
        : null;
    model = json['model'] != null ? new Model.fromJson(json['model']) : null;
    make = json['make'] != null ? new Make.fromJson(json['make']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['video'] = this.video;
    data['descriptions'] = this.descriptions;
    data['categoryId'] = this.categoryId;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  var lTitle;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  var lTitle;
  var modelsCount;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class SellData {
  int? id;
  int? userId;
  String? sellType;
  int? productId;
  String? description;
  int? price;
  String? productCondition;
  var lifeExpectancy;
  var lifeExpectancyType;
  String? kmDriven;
  String? kmDrivenType;
  String? chassisNumber;
  var warehouseCode;
  String? engineNumber;
  var distanceType;
  String? mileage;
  String? mileageType;
  String? warranty;
  String? warrantyTime;
  String? warrantyType;
  String? color;
  String? image;
  var imageTwo;
  var imageThree;
  String? sellStatus;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  SellData(
      {this.id,
        this.userId,
        this.sellType,
        this.productId,
        this.description,
        this.price,
        this.productCondition,
        this.lifeExpectancy,
        this.lifeExpectancyType,
        this.kmDriven,
        this.kmDrivenType,
        this.chassisNumber,
        this.warehouseCode,
        this.engineNumber,
        this.distanceType,
        this.mileage,
        this.mileageType,
        this.warranty,
        this.warrantyTime,
        this.warrantyType,
        this.color,
        this.image,
        this.imageTwo,
        this.imageThree,
        this.sellStatus,
        this.isStatus,
        this.createdAt,
        this.updatedAt});

  SellData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    sellType = json['sell_type'];
    productId = json['productId'];
    description = json['description'];
    price = json['price'];
    productCondition = json['product_condition'];
    lifeExpectancy = json['life_expectancy'];
    lifeExpectancyType = json['life_expectancy_type'];
    kmDriven = json['km_driven'];
    kmDrivenType = json['km_driven_type'];
    chassisNumber = json['chassis_number'];
    warehouseCode = json['warehouse_code'];
    engineNumber = json['engine_number'];
    distanceType = json['distance_type'];
    mileage = json['mileage'];
    mileageType = json['mileage_type'];
    warranty = json['warranty'];
    warrantyTime = json['warranty_time'];
    warrantyType = json['warranty_type'];
    color = json['color'];
    image = json['image'];
    imageTwo = json['image_two'];
    imageThree = json['image_three'];
    sellStatus = json['sell_status'];
    isStatus = json['is_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['sell_type'] = this.sellType;
    data['productId'] = this.productId;
    data['description'] = this.description;
    data['price'] = this.price;
    data['product_condition'] = this.productCondition;
    data['life_expectancy'] = this.lifeExpectancy;
    data['life_expectancy_type'] = this.lifeExpectancyType;
    data['km_driven'] = this.kmDriven;
    data['km_driven_type'] = this.kmDrivenType;
    data['chassis_number'] = this.chassisNumber;
    data['warehouse_code'] = this.warehouseCode;
    data['engine_number'] = this.engineNumber;
    data['distance_type'] = this.distanceType;
    data['mileage'] = this.mileage;
    data['mileage_type'] = this.mileageType;
    data['warranty'] = this.warranty;
    data['warranty_time'] = this.warrantyTime;
    data['warranty_type'] = this.warrantyType;
    data['color'] = this.color;
    data['image'] = this.image;
    data['image_two'] = this.imageTwo;
    data['image_three'] = this.imageThree;
    data['sell_status'] = this.sellStatus;
    data['is_status'] = this.isStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}