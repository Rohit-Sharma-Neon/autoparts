class InterestListModel {
  bool? success;
  String? msg;
  InterestResult? result;

  InterestListModel({this.success, this.msg, this.result});

  InterestListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    result =
    json['result'] != null ?  InterestResult.fromJson(json['result']) : null;
  }
}

class InterestResult {
  List<InterestRecords>? records;

  InterestResult({this.records});

  InterestResult.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <InterestRecords>[];
      json['records'].forEach((v) {
        records!.add( InterestRecords.fromJson(v));
      });
    }
  }

}

class InterestRecords {
  int? interestId;
  String? name;
  bool? status = false;
  Interest? interest;

  InterestRecords({this.interestId, this.name, this.interest,this.status});

  InterestRecords.fromJson(Map<String, dynamic> json) {
    interestId = json['interestId'];
    name = json['name'];
    interest = json['interest'] != null
        ?  Interest.fromJson(json['interest'])
        : null;
  }
}

class Interest {
  int? id;
  Interest({this.id});
  Interest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
