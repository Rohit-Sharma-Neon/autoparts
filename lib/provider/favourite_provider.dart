import 'package:autoparts/main.dart';
import 'package:autoparts/models/dealers_list_model.dart';
import 'package:autoparts/models/fav_status_model.dart';
import 'package:autoparts/models/home_data_model.dart';
import 'package:autoparts/provider/car_provider.dart';
import 'package:autoparts/provider/dealers_provider.dart';
import 'package:autoparts/provider/products_provider.dart';
import 'package:autoparts/provider/sellers_provider.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:flutter/cupertino.dart";
import 'package:provider/provider.dart';

import '../api_service/api_base_helper.dart';
import '../api_service/api_config.dart';
import '../models/common_model.dart';
import '../models/dealers_details_model.dart';
import '../models/favorites_list_model.dart';
import '../models/product_list_model.dart';
import '../routes/navigator_service.dart';

class FavouriteProvider with ChangeNotifier {

  bool? _checkIsLogin;

  bool? get checkIsLogin => _checkIsLogin ?? false;

  // List<DealerList>? dealersList;
  List<FavoritesList>? dealers;
  List<FavoritesList>? sellers;
  List<FavoritesList>? cars;
  List<FavoritesList>? parts;
  CommonResponse? commonResponse;
  FavoritesListResponse? favoritesListResponse;
  FavStatusModel? favStatusModel;


  @override
  notifyListeners();

  initDashboard() {
    bool check = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    _checkIsLogin = check;
    notifyListeners();
  }

  Future<bool> addRemoveFav(itemId, type, {int? index,bool isFavScreen = false}) async {
    var context = NavigationService.navigatorKey.currentContext;
    bool returnStatus = false;
    commonResponse = CommonResponse();
    notifyListeners();
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "product_id": itemId.toString(),
      "type": type,
    };
    var response = await ApiBaseHelper().postApiCall(true, addRemoveWishlist, body);
    favStatusModel = FavStatusModel.fromJson(response);
    notifyListeners();
    if (favStatusModel?.success??false) {
      if((favStatusModel?.status??"") == "added"){
        returnStatus = true;
      }else{
        if (isFavScreen) {
          if (type == "dealer") {
            context?.read<DealersProvider>().dealersList?.removeAt(index??0);
          }else if (type == "seller") {
            context?.read<SellersProvider>().sellerList?.removeAt(index??0);
          }else if (type == "auto-part") {
            // context?.read<DealersProvider>().productData?.removeAt(index??0);
            await context?.read<DealersProvider>().productPartsApi(categoryId: "",
                productsCategoryId: "",isFeatured: "",isFavOnly: true);
          }else if (type == "cars") {
            await context?.read<CarProvider>().getCarConvertible("1", isFeatured: "",
                carCategoryId: "",isShimmer: true,isFavOnly: true);
          }
        }
        returnStatus = false;
      }
    }
    notifyListeners();
    return returnStatus;
  }

  getFavoritesListApi(type,{categoryId, rating, sort,}) async {
    // dealer/seller/auto-part/car
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "type": type,
      "rating" : rating,
      "cart_type": cartType.toString(),
    };
    var response = await ApiBaseHelper().postApiCall(false, getWishlistApi, body,isShimmer: true);
    favoritesListResponse = FavoritesListResponse.fromJson(response);
    if (favoritesListResponse?.success ?? false) {
      if (type == "dealer") {
        dealers = favoritesListResponse?.result;
      } else if (type == "seller") {
        sellers = favoritesListResponse?.result;
      } else if (type == "auto-part") {
        parts = favoritesListResponse?.result;
      } else if (type == "cars") {
        cars = favoritesListResponse?.result;
      }
    } else {
      dealers = null;
      sellers = null;
      parts = null;
      cars = null;
    }
    notifyListeners();
  }
}
