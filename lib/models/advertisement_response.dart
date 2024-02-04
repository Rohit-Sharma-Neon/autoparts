class AdvertisementResponse {
  bool? success;
  String? msg;
  Result? result;

  AdvertisementResponse({this.success, this.msg, this.result});

  AdvertisementResponse.fromJson(Map<String, dynamic> json) {
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
  List<Records>? records;

  Result({this.records});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  String? image;
  int? id;
  String? ownerName;
  int? dealerId;
  String? startDate;
  String? endDate;
  String? uploadType;
  String? type;
  String? videoUrl;
  int? totalClick;
  String? clickUrl;
  String? gender;
  String? ageGroup;

  Records(
      {this.image,
        this.id,
        this.ownerName,
        this.dealerId,
        this.startDate,
        this.endDate,
        this.uploadType,
        this.type,
        this.videoUrl,
        this.totalClick,
        this.clickUrl,
        this.gender,
        this.ageGroup});

  Records.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    ownerName = json['owner_name'];
    dealerId = json['dealerId'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    uploadType = json['upload_type'];
    type = json['type'];
    videoUrl = json['video_url'];
    totalClick = json['total_click'];
    clickUrl = json['click_url'];
    gender = json['gender'];
    ageGroup = json['age_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['owner_name'] = this.ownerName;
    data['dealerId'] = this.dealerId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['upload_type'] = this.uploadType;
    data['type'] = this.type;
    data['video_url'] = this.videoUrl;
    data['total_click'] = this.totalClick;
    data['click_url'] = this.clickUrl;
    data['gender'] = this.gender;
    data['age_group'] = this.ageGroup;
    return data;
  }
}