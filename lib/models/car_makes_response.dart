class CarMakesResponse {
  bool? success;
  String? msg;
  Result? result;

  CarMakesResponse({this.success, this.msg, this.result});

  CarMakesResponse.fromJson(Map<String, dynamic> json) {
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
  List<CarMakeRecord>? records;

  Result({this.records});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <CarMakeRecord>[];
      json['records'].forEach((v) {
        records!.add(new CarMakeRecord.fromJson(v));
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

class CarMakeRecord {
  int? id;
  String? title;
  var modelsCount;

  CarMakeRecord({this.id, this.title, this.modelsCount});

  CarMakeRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    modelsCount = json['modelsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['modelsCount'] = this.modelsCount;
    return data;
  }
}