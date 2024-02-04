import 'package:autoparts/app_ui/screens/dashboard/seller_screen/seller_details_screen.dart';
import 'package:autoparts/main.dart';
import 'package:autoparts/models/advertisement_response.dart';
import 'package:autoparts/models/dealers_list_model.dart';
import 'package:autoparts/models/home_data_model.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:flutter/cupertino.dart";

import '../api_service/api_base_helper.dart';
import '../api_service/api_config.dart';
import '../models/dealers_details_model.dart';
import '../models/product_list_model.dart';
import '../models/seller_details_model.dart';
import '../models/seller_list_model.dart';

class SellersProvider with ChangeNotifier {
  List<SellerList>? sellerList;
  SellerListResponse? sellerListResponse;
  SellerDetailsResponse? sellerDetailsResponse;
  SellerDetail? sellerDetail;
  AdvertisementResponse? advertisementResponse;

  bool? _checkIsLogin;

  bool? get checkIsLogin => _checkIsLogin ?? false;

  initSellers() {
    bool check = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    _checkIsLogin = check;
    notifyListeners();
  }


  @override
  notifyListeners();

  getSortApi({String? sort}) async {
    Map<String, dynamic> body = {
      "sort" : sort,
    };
    var response = await ApiBaseHelper().postApiCall(true, sellerListApi, body);
    sellerListResponse = SellerListResponse.fromJson(response);
    if (sellerListResponse?.success ?? false) {
      sellerList = sellerListResponse?.result?.rows;
    }
    notifyListeners();
  }

  getSellersListApi({String categoryId = "", String? rating, bool isFavOnly = false}) async {
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "category_id": categoryId,
      "rating" : rating??"",
      "cart_type": cartType.toString(),
      "record_type": isFavOnly ? "Fav" : "",
    };
    var response = await ApiBaseHelper().postApiCall(false, sellerListApi, body,isShimmer: true);
    sellerListResponse = SellerListResponse.fromJson(response);
    if (sellerListResponse?.success ?? false) {
      sellerList = sellerListResponse?.result?.rows;
    }
    notifyListeners();
  }

  getSellerDetailsApi(sellerId) async {
    sellerDetailsResponse = null;
    sellerDetailsResponse = SellerDetailsResponse();
    sellerDetail = null;
    sellerDetail = SellerDetail();
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "user_id": sellerId.toString(),
      "cart_type": cartType.toString(),
    };
    var response = await ApiBaseHelper().postApiCall(true, sellerDetailApi, body);
    sellerDetailsResponse = SellerDetailsResponse.fromJson(response);
    if (sellerDetailsResponse?.success ?? false) {
      sellerDetail = sellerDetailsResponse?.result;
    }

    notifyListeners();
  }

  getAdvertisementsApi() async {
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "cart_type": cartType.toString(),
    };
    var response = await ApiBaseHelper().postApiCall(false, getAllAdvertisement, body);
    advertisementResponse = AdvertisementResponse.fromJson(response);
    notifyListeners();
  }

}
