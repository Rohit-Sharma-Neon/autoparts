class CarModelsResponse {
  bool? success;
  String? msg;
  Result? result;

  CarModelsResponse({this.success, this.msg, this.result});

  CarModelsResponse.fromJson(Map<String, dynamic> json) {
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
  List<CarModelRecord>? records;

  Result({this.records});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <CarModelRecord>[];
      json['records'].forEach((v) {
        records!.add(new CarModelRecord.fromJson(v));
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

class CarModelRecord {
  String? image;
  int? id;
  int? makeId;
  String? title;

  CarModelRecord({this.image, this.id, this.makeId, this.title});

  CarModelRecord.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    makeId = json['makeId'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['makeId'] = this.makeId;
    data['title'] = this.title;
    return data;
  }
}