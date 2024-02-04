class NotificationListModel {
  bool? success;
  String? msg;
  List<NotificationData>? result;
  int? notificationCount;

  NotificationListModel(
      {this.success, this.msg, this.result, this.notificationCount});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    if (json['result'] != null) {
      result = <NotificationData>[];
      json['result'].forEach((v) {
        result!.add(new NotificationData.fromJson(v));
      });
    }
    notificationCount = json['notificationCount'];
  }


}

class NotificationData {
  String? createdAt;
  int? id;
  String? userType;
  String? fromId;
  String? toId;
  String? title;
  String? description;
  String? tableName;
  String? tableId;
  bool? isRead;
  bool? isStatus;
  String? updatedAt;

  NotificationData(
      {this.createdAt,
        this.id,
        this.userType,
        this.fromId,
        this.toId,
        this.title,
        this.description,
        this.tableName,
        this.tableId,
        this.isRead,
        this.isStatus,
        this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    id = json['id'];
    userType = json['user_type'];
    fromId = json['from_id'];
    toId = json['to_id'];
    title = json['title'];
    description = json['description'];
    tableName = json['table_name'];
    tableId = json['table_id'];
    isRead = json['is_read'];
    isStatus = json['is_status'];
    updatedAt = json['updatedAt'];
  }


}
