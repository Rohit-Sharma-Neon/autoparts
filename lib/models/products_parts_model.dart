class ProductsPartModel {
  bool? success;
  String? msg;
  Result? result;

  ProductsPartModel({this.success, this.msg, this.result});

  ProductsPartModel.fromJson(Map<String, dynamic> json) {
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
  List<ProductData>? data;
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
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(new ProductData.fromJson(v));
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

class ProductData {
  int? id;
  String? name;
  String? descriptions;
  int? categoryId;
  String? partNumber;
  String? hsNumber;
  String? featured;
  String? partCondition;
  String? video;
  String? imageUrl;
  int? qty;
  String? price;
  var unit;
  var weight;
  String? isStatus;
  Category? category;
  List<Dealers>? dealers;
  int? isFav;

  ProductData(
      {this.id,
        this.name,
        this.descriptions,
        this.categoryId,
        this.partNumber,
        this.hsNumber,
        this.featured,
        this.partCondition,
        this.video,
        this.imageUrl,
        this.qty,
        this.price,
        this.unit,
        this.weight,
        this.isStatus,
        this.category,
        this.dealers,
        this.isFav});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    descriptions = json['descriptions'];
    categoryId = json['categoryId'];
    partNumber = json['part_number'];
    hsNumber = json['hs_number'];
    featured = json['featured'];
    partCondition = json['part_condition'];
    video = json['video'];
    imageUrl = json['image_url'];
    qty = json['qty'];
    price = json['price'];
    unit = json['unit'];
    weight = json['weight'];
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
    isFav = json['is_fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['descriptions'] = this.descriptions;
    data['categoryId'] = this.categoryId;
    data['part_number'] = this.partNumber;
    data['hs_number'] = this.hsNumber;
    data['featured'] = this.featured;
    data['part_condition'] = this.partCondition;
    data['video'] = this.video;
    data['image_url'] = this.imageUrl;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['weight'] = this.weight;
    data['is_status'] = this.isStatus;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.dealers != null) {
      data['dealers'] = this.dealers!.map((v) => v.toJson()).toList();
    }
    data['is_fav'] = this.isFav;
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
  User? user;

  Dealers({this.userId, this.categoryId, this.user});

  Dealers.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    categoryId = json['categoryId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['categoryId'] = this.categoryId;
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

  User({this.image, this.id, this.name, this.featured});

  User.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
    featured = json['featured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    data['featured'] = this.featured;
    return data;
  }
}
