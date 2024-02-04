class CarConvertibleModel {
  bool? success;
  String? msg;
  Result? result;

  CarConvertibleModel({this.success, this.msg, this.result});

  CarConvertibleModel.fromJson(Map<String, dynamic> json) {
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
  List<ConvertibleData>? data;
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
      data = <ConvertibleData>[];
      json['data'].forEach((v) {
        data!.add(new ConvertibleData.fromJson(v));
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

class ConvertibleData {
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
  String? image;
  String? totalRunning;
  int? price;
  String? isStatus;
  CarCategory? carCategory;
  Model? model;
  Make? make;
  int? isFav;
  String? carName;
  int? sellRecordId;
  ConvertibleData(
      {this.id,
        this.carCategoryId,
        this.makeId,
        this.modelId,
        this.year,
        this.sellRecordId,
        this.carName,
        this.region,
        this.transmissionType,
        this.grade,
        this.engine,
        this.chassisNumber,
        this.image,
        this.totalRunning,
        this.price,
        this.isStatus,
        this.carCategory,
        this.model,
        this.make,
        this.isFav});

  ConvertibleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carCategoryId = json['carCategoryId'];
    makeId = json['makeId'];
    modelId = json['modelId'];
    year = json['year'];
    sellRecordId = json['sell_record_id'];
    region = json['region'];
    transmissionType = json['transmission_type'];
    grade = json['grade'];
    engine = json['engine'];
    chassisNumber = json['chassis_number'];
    image = json['image'];
    totalRunning = json['total_running'];
    price = json['price'];
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
    data['sell_record_id'] = this.sellRecordId;
    data['region'] = this.region;
    data['transmission_type'] = this.transmissionType;
    data['grade'] = this.grade;
    data['engine'] = this.engine;
    data['chassis_number'] = this.chassisNumber;
    data['image'] = this.image;
    data['total_running'] = this.totalRunning;
    data['price'] = this.price;
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
