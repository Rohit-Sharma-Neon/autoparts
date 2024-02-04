class ReviewRatingResponse {
  bool? success;
  String? msg;
  List<RatingsData>? result;

  ReviewRatingResponse({this.success, this.msg, this.result});

  ReviewRatingResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    if (json['result'] != null) {
      result = <RatingsData>[];
      json['result'].forEach((v) {
        result!.add( RatingsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingsData {
  int? id;
  int? rating;
  String? review;
  int? orderId;
  int? userId;
  String? createdAt;
  User? user;

  RatingsData(
      {this.id,
        this.rating,
        this.review,
        this.orderId,
        this.userId,
        this.createdAt,
        this.user});

  RatingsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    review = json['review'];
    orderId = json['orderId'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    user = json['user'] != null ?  User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['orderId'] = this.orderId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
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

  User({this.image, this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}