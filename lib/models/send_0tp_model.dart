class SendOtpModel {
  bool? success;
  String? msg;
  Result? result;

  SendOtpModel({this.success, this.msg, this.result});

  SendOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  String? otp;

  Result({this.otp});

  Result.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
  }
}
