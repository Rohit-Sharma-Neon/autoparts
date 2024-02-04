class ReminderList {
  bool? success;
  String? msg;
  Result? result;

  ReminderList({this.success, this.msg, this.result});

  ReminderList.fromJson(Map<String, dynamic> json) {
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
  List<ReminderListData>? data;
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
      data = <ReminderListData>[];
      json['data'].forEach((v) {
        data!.add(new ReminderListData.fromJson(v));
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

class ReminderListData {
  String? createdAt;
  int? id;
  int? carId;
  var productId;
  int? userId;
  String? updatedAt;
  Car? car;
  Product? product;
  String? carName;

  ReminderListData(
      {this.createdAt,
        this.id,
        this.carName,
        this.carId,
        this.productId,
        this.userId,
        this.updatedAt,
        this.car,
        this.product});

  ReminderListData.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    id = json['id'];
    carId = json['carId'];
    productId = json['productId'];
    userId = json['userId'];
    updatedAt = json['updatedAt'];
    car = json['car'] != null ? new Car.fromJson(json['car']) : null;
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['id'] = this.id;
    data['carId'] = this.carId;
    data['productId'] = this.productId;
    data['userId'] = this.userId;
    data['updatedAt'] = this.updatedAt;
    if (this.car != null) {
      data['car'] = this.car!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Car {
  int? id;
  var name;
  var description;
  var modelName;
  var catalogId;
  var brand;
  CarCategory? carCategory;
  Model? model;
  Make? make;

  Car(
      {this.id,
        this.name,
        this.description,
        this.modelName,
        this.catalogId,
        this.brand,
        this.carCategory,
        this.model,
        this.make});

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    modelName = json['modelName'];
    catalogId = json['catalogId'];
    brand = json['brand'];
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
    data['description'] = this.description;
    data['modelName'] = this.modelName;
    data['catalogId'] = this.catalogId;
    data['brand'] = this.brand;
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

class Product {
  int? id;
  String? name;
  String? descriptions;

  Product({this.id, this.name, this.descriptions});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    descriptions = json['descriptions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['descriptions'] = this.descriptions;
    return data;
  }
}