class ApiResponseModel {
  bool? success;
  String? msg;

  ApiResponseModel({this.success, this.msg});

  ApiResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
  }
}
