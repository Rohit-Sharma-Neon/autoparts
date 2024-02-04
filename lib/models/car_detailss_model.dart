class CarDetailsModel {
  bool? success;
  String? msg;
  CarResultDetails? result;
  SellData? sellData;

  CarDetailsModel({this.success, this.msg, this.result, this.sellData});

  CarDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
    json['result'] != null ? new CarResultDetails.fromJson(json['result']) : null;
    sellData = json['sellData'] != null
        ? new SellData.fromJson(json['sellData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    if (this.sellData != null) {
      data['sellData'] = this.sellData!.toJson();
    }
    return data;
  }
}

class CarResultDetails {
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
  String? warranty;
  String? kilometer;
  String? featured;
  var name;
  var description;
  String? isStatus;
  CarCategory? carCategory;
  Model? model;
  Make? make;
  int? isFav;

  CarResultDetails(
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
        this.warranty,
        this.kilometer,
        this.featured,
        this.name,
        this.description,
        this.isStatus,
        this.carCategory,
        this.model,
        this.make,
        this.isFav});

  CarResultDetails.fromJson(Map<String, dynamic> json) {
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
    warranty = json['warranty'];
    kilometer = json['kilometer'];
    featured = json['featured'];
    name = json['name'];
    description = json['description'];
    isStatus = json['is_status'];
    carCategory = json['car_category'] != null
        ? new CarCategory.fromJson(json['car_category'])
        : null;
    model = json['model'] != null ? new Model.fromJson(json['model']) : null;
    make = json['make'] != null ? new Make.fromJson(json['make']) : null;
    isFav = json['is_fav'];
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
    data['warranty'] = this.warranty;
    data['kilometer'] = this.kilometer;
    data['featured'] = this.featured;
    data['name'] = this.name;
    data['description'] = this.description;
    data['is_status'] = this.isStatus;
    if (this.carCategory != null) {
      data['car_category'] = this.carCategory!.toJson();
    }
    if (this.model != null) {
      data['model'] = this.model!.toJson();
    }
    if (this.make != null) {
      data['make'] = this.make!.toJson();
    }
    data['is_fav'] = this.isFav;
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
  User? user;

  SellData(
      {this.id,
        this.userId,
        this.sellType,
        this.productId,
        this.description,
        this.price,
        this.user,
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
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
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

class User {
  String? image;
  String? headerImage;
  String? businessLogo;
  String? tradeLicense;
  int? id;
  String? name;
  String? firstName;
  var lastName;
  String? email;
  String? countryCode;
  String? mobile;
  var whatsappCountryCode;
  var whatsappMobile;
  String? userType;
  String? becomeASeller;
  var sellerVerify;
  var featured;
  var businessName;
  var totalRate;
  var avgRate;
  var address;
  var latitude;
  var longitude;

  User(
      {this.image,
        this.headerImage,
        this.businessLogo,
        this.tradeLicense,
        this.id,
        this.name,
        this.firstName,
        this.lastName,
        this.email,
        this.countryCode,
        this.mobile,
        this.whatsappCountryCode,
        this.whatsappMobile,
        this.userType,
        this.becomeASeller,
        this.sellerVerify,
        this.featured,
        this.businessName,
        this.totalRate,
        this.avgRate,
        this.address,
        this.latitude,
        this.longitude});

  User.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    headerImage = json['header_image'];
    businessLogo = json['business_logo'];
    tradeLicense = json['trade_license'];
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    whatsappCountryCode = json['whatsapp_country_code'];
    whatsappMobile = json['whatsapp_mobile'];
    userType = json['user_type'];
    becomeASeller = json['become_a_seller'];
    sellerVerify = json['seller_verify'];
    featured = json['featured'];
    businessName = json['business_name'];
    totalRate = json['total_rate'];
    avgRate = json['avg_rate'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['header_image'] = this.headerImage;
    data['business_logo'] = this.businessLogo;
    data['trade_license'] = this.tradeLicense;
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['whatsapp_country_code'] = this.whatsappCountryCode;
    data['whatsapp_mobile'] = this.whatsappMobile;
    data['user_type'] = this.userType;
    data['become_a_seller'] = this.becomeASeller;
    data['seller_verify'] = this.sellerVerify;
    data['featured'] = this.featured;
    data['business_name'] = this.businessName;
    data['total_rate'] = this.totalRate;
    data['avg_rate'] = this.avgRate;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}



