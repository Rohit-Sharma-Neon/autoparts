import 'package:autoparts/api_service/api_base_helper.dart';
import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/models/category_list_model.dart';
import 'package:autoparts/routes/navigator_service.dart';
import 'package:flutter/material.dart';

class CommonProvider with ChangeNotifier {

  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber!;
  CategoryListModel? categoryListModel;
  getCategoryListApi() async {
    Map<String, dynamic> body = {};
    var response = await ApiBaseHelper().postApiCall(false,categoryList, body,isShimmer: true);
    categoryListModel = CategoryListModel.fromJson(response);
    notifyListeners();
  }
}