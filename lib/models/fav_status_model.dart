class FavStatusModel {
  bool? success;
  String? msg;
  String? status;

  FavStatusModel({this.success, this.msg, this.status});

  FavStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}