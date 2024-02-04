import 'package:autoparts/api_service/api_base_helper.dart';
import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/app_ui/screens/location/location_screen.dart';
import 'package:autoparts/app_ui/screens/user_profile/user_account_screen.dart';
import 'package:autoparts/models/api_response_model.dart';
import 'package:autoparts/models/country_list_model.dart';
import 'package:autoparts/models/interest_list_model.dart';
import 'package:autoparts/models/notification_list_model.dart';
import 'package:autoparts/models/user_profile_model.dart';
import 'package:autoparts/provider/dashboard_provider.dart';
import 'package:autoparts/routes/navigator_service.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/common_model.dart';

class NotificationProvider with ChangeNotifier {
  NotificationListModel? notificationListModel;
  List<NotificationData>? notificationListData;
  CommonResponse? commonResponse;

  bool? _checkIsLogin;

  bool? get checkIsLogin => _checkIsLogin ?? false;

  initNotificationsProvider() {
    bool check = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    _checkIsLogin = check;
    notifyListeners();
  }

  @override
  notifyListeners();

  getNotificationListApi() async {

    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "cart_type": cartType.toString(),

    };
    var response = await ApiBaseHelper().postApiCall(false, notificationList, body,isShimmer: true);
    notificationListModel = NotificationListModel.fromJson(response);
    if (notificationListModel?.success ?? false) {
      notificationListData = notificationListModel!.result;
      sp!.putInt(SpUtil.NOTIFICATION_COUNT, notificationListModel?.notificationCount ?? 0);
    }else{
      notificationListData=null;
    }
    notifyListeners();
  }

  notificationReadApi(isShow, notificationId) async {
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "notification_id": notificationId,
      "cart_type": cartType.toString()
    };
    var response = await ApiBaseHelper().postApiCall(isShow, notificationRead, body);
    commonResponse = CommonResponse.fromJson(response);
    if (commonResponse?.success ?? false) {
      if (notificationId == "") {
        sp!.putInt(SpUtil.NOTIFICATION_COUNT, 0);
      } else {
        var notificationCount = 0;
        notificationCount = sp!.getInt(SpUtil.NOTIFICATION_COUNT) ?? 0;
        notificationCount--;
        sp!.putInt(SpUtil.NOTIFICATION_COUNT, notificationCount);
      }
    }
    notifyListeners();
  }

  notificationDeleteApi(isShow, notificationId) async {
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "notification_id": notificationId,
      "cart_type": cartType.toString()
    };
    var response = await ApiBaseHelper().postApiCall(isShow, notificationDelete, body);
    commonResponse = CommonResponse.fromJson(response);
    if (commonResponse?.success ?? false) {
      if (notificationId == "") {
        sp!.putInt(SpUtil.NOTIFICATION_COUNT, 0);
      } else {
        var notificationCount = 0;
        notificationCount = sp!.getInt(SpUtil.NOTIFICATION_COUNT) ?? 0;
        notificationCount--;
        sp!.putInt(SpUtil.NOTIFICATION_COUNT, notificationCount);
      }
    }
    notifyListeners();
  }

  notificationUnreadApi() async {
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "cart_type": cartType.toString()
    };
    var response = await ApiBaseHelper().postApiCall(true, notificationUnread, body);

    notifyListeners();
  }
}
