class StaticPageResponse {
  bool? success;
  String? msg;
  String? result;

  StaticPageResponse({this.success, this.msg, this.result});

  StaticPageResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}