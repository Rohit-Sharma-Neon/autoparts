class CountryListModel {
  bool? success;
  String? msg;
  List<CountryList>? result;

  CountryListModel({this.success, this.msg, this.result});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    if (json['result'] != null) {
      result = <CountryList>[];
      json['result'].forEach((v) {
        result!.add(CountryList.fromJson(v));
      });
    }
  }
}

class CountryList {
  int? id;
  String? sortName;
  String? name;
  int? phoneCode;
  String? currencyName;
  String? currencySymbol;
  int? status;
  String? createdAt;
  String? updatedAt;

  CountryList(
      {this.id,
        this.sortName,
        this.name,
        this.phoneCode,
        this.currencyName,
        this.currencySymbol,
        this.status,
        this.createdAt,
        this.updatedAt});

  CountryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sortName = json['sortname'];
    name = json['name'];
    phoneCode = json['phonecode'];
    currencyName = json['currency_name'];
    currencySymbol = json['currency_symbol'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
