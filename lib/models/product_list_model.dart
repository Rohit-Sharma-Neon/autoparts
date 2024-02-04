class ProductListResponse {
  bool? success;
  String? msg;
  Result? result;

  ProductListResponse({this.success, this.msg, this.result});

  ProductListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
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
}

class Products {
  int? totalItems;
  List<Product>? data;
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
      data = <Product>[];
      json['data'].forEach((v) {
        data!.add(new Product.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    limit = json['limit'];
    currentPage = json['currentPage'];
  }
}

class Product {
  int? id;
  String? name;
  int? categoryId;
  String? imageUrl;
  int? qty;
  String? partCondition;
  String? price;
  var unit;
  var weight;
  Category? category;
  String? isStatus;
  String? descriptions;
  int? isFav;

  Product(
      {this.id,
      this.name,
      this.categoryId,
      this.imageUrl,
      this.qty,
      this.price,
        this.category,
        this.partCondition,
      this.unit,
      this.descriptions,
      this.weight,
      this.isStatus,
      this.isFav});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['categoryId'];
    imageUrl = json['image_url'];
    category = json['category'] != null
        ?  Category.fromJson(json['category'])
        : null;
    qty = json['qty'];
    partCondition = json['part_condition'];
    price = json['price'];
    descriptions = json['descriptions'];
    unit = json['unit'];
    weight = json['weight'];
    isStatus = json['is_status'];
    isFav = json['is_fav'];
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
