class AddRemoveNotificationModel {
  bool? success;
  String? msg;
  int? isReminder;

  AddRemoveNotificationModel(
      {this.success, this.msg, this.isReminder});

  AddRemoveNotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    isReminder = json['is_reminder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['is_reminder'] = this.isReminder;
    return data;
  }
}