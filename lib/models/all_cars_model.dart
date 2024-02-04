class AllCarsModel {
  bool? success;
  String? msg;
  Result? result;

  AllCarsModel({this.success, this.msg, this.result});

  AllCarsModel.fromJson(Map<String, dynamic> json) {
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
  List<AllCarsDetail>? products;

  Result({this.products});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <AllCarsDetail>[];
      json['products'].forEach((v) {
        products!.add(new AllCarsDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllCarsDetail {
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
  String? warranty;
  String? kilometer;
  String? image;
  String? totalRunning;
  int? price;
  String? featured;
  String? isStatus;
  CarCategory? carCategory;
  Model? model;
  Make? make;
  int? isFav;
  String? carNames;

  AllCarsDetail(
      {this.id,
        this.carCategoryId,
        this.makeId,
        this.modelId,
        this.year,
        this.region,
        this.carNames,
        this.transmissionType,
        this.grade,
        this.engine,
        this.chassisNumber,
        this.warranty,
        this.kilometer,
        this.image,
        this.totalRunning,
        this.price,
        this.featured,
        this.isStatus,
        this.carCategory,
        this.model,
        this.make,
        this.isFav});

  AllCarsDetail.fromJson(Map<String, dynamic> json) {
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
    warranty = json['warranty'];
    kilometer = json['kilometer'];
    image = json['image'];
    totalRunning = json['total_running'];
    price = json['price'];
    featured = json['featured'];
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
    data['warranty'] = this.warranty;
    data['kilometer'] = this.kilometer;
    data['image'] = this.image;
    data['total_running'] = this.totalRunning;
    data['price'] = this.price;
    data['featured'] = this.featured;
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
  String? lTitle;
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