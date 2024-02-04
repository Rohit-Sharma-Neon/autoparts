class UploadImageModel {
  bool? success;
  String? msg;
  UploadImageResult? result;

  UploadImageModel({this.success, this.msg, this.result});

  UploadImageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
    json['result'] != null ? UploadImageResult.fromJson(json['result']) : null;
  }
}

class UploadImageResult {
  String? imageUrl;

  UploadImageResult({this.imageUrl});

  UploadImageResult.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
  }
}
