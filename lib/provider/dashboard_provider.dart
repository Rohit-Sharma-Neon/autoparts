
import 'package:autoparts/main.dart';
import 'package:autoparts/models/home_data_model.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:flutter/cupertino.dart";

import '../api_service/api_base_helper.dart';
import '../api_service/api_config.dart';
import '../routes/navigator_service.dart';

class DashboardProvider with ChangeNotifier {
  bool? _checkIsLogin;

  bool? get checkIsLogin => _checkIsLogin ?? false;
  HomeDataModel? homeDataModel;
  List<TopCategories>? topCategories;
  List<BannerList>? banner;
  List<BannerOne>? bannerOne;
  List<Dealers>? dealers;
  List<Sellers>? sellers;
  List<FeaturedCar>? featuredCar;
  List<TopProductForSale>? topProductForSale;
  List<TopCarsForSale>? topCarsForSale;
  List<FeaturedProduct>? featuredProduct;

  @override
  notifyListeners();

  initDashboard() {
    bool check = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    _checkIsLogin = check;
    notifyListeners();
  }

  getHomeDataApi(categoryId) async {
    var context = NavigationService.navigatorKey.currentContext;
    bool check = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    _checkIsLogin = check;
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "category_id": categoryId,
      "cart_type": cartType,
    };
    await ApiBaseHelper().postApiCall(false, dashboard, body,isShimmer: true,shimmerScreenName: "HOME").then((value) {
      homeDataModel = HomeDataModel.fromJson(value);
      if (homeDataModel?.success ?? false) {
        banner = homeDataModel?.result?.banner;
        topCategories = homeDataModel?.result?.topCategories;
        dealers = homeDataModel?.result?.dealers;
        sellers = homeDataModel?.result?.sellers;
        bannerOne = homeDataModel?.result?.bannerOne;
        featuredCar = homeDataModel?.result?.featuredCar;
        topProductForSale = homeDataModel?.result?.topProductForSale;
        topCarsForSale = homeDataModel?.result?.topCarsForSale;
        featuredProduct = homeDataModel?.result?.featuredProduct;
        sp!.putInt(SpUtil.NOTIFICATION_COUNT, homeDataModel?.result?.notificationCount ?? 0);
        notifyListeners();
      }
    });
  }
}
