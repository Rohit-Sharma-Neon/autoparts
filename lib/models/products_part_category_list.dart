class ProductsPartCategoryModel {
  bool? success;
  String? msg;
  Result? result;

  ProductsPartCategoryModel({this.success, this.msg, this.result});

  ProductsPartCategoryModel.fromJson(Map<String, dynamic> json) {
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
  List<FilterCategories>? categories;

  Result({this.categories});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <FilterCategories>[];
      json['categories'].forEach((v) {
        categories!.add(new FilterCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterCategories {
  int? id;
  String? name;
  String? image;
  int? totalItem;

  FilterCategories({this.id, this.name, this.image, this.totalItem});

  FilterCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    totalItem = json['total_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['total_item'] = this.totalItem;
    return data;
  }
}
