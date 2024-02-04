
import 'package:autoparts/main.dart';
import 'package:autoparts/models/advertisement_response.dart';
import 'package:autoparts/models/common_model.dart';
import 'package:autoparts/models/dealers_filter_model.dart';
import 'package:autoparts/models/dealers_list_model.dart';
import 'package:autoparts/models/get_products_details.dart';
import 'package:autoparts/models/home_data_model.dart';
import 'package:autoparts/models/part_categories_list.dart';
import 'package:autoparts/models/products_part_category_list.dart';
import 'package:autoparts/models/products_parts_model.dart';
import 'package:autoparts/routes/navigator_service.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:flutter/cupertino.dart";

import '../api_service/api_base_helper.dart';
import '../api_service/api_config.dart';
import '../models/dealers_details_model.dart';
import '../models/product_list_model.dart';

class DealersProvider with ChangeNotifier {
  List<DealerList>? dealersList;
  List<DealerList> searchedDealersList = [];
  List<Product>? productList;
  List<Categories>? categoriesList;
  List<CategoriesData>? categoriesData;
  List<ProductData>? productData;
  List<ProductData> searchProductData = [];
  ResultData? result;
  AdvertisementResponse? advertisementResponse;
  List<FilterCategories>? categories;
  ProductsPartCategoryModel? productsPartCategoryModel;
  DealerDetails? dealerDetails;
  DealerListResponse? dealerListResponse;
  ProductsPartModel? productsPartModel;
  GetProductDetails? getProductDetails;
  CommonResponse? commonResponse;
  DealerDetailsResponse? dealerDetailsResponse;
  ProductListResponse? productListResponse;
  DealersFilterModel? dealersFilterModel;
  PartCategoriesList? partCategoriesList;

  bool? _checkIsLogin;

  bool? get checkIsLogin => _checkIsLogin ?? false;

  setSearchCategoryData(ProductData value){
    searchProductData.add(value);
    notifyListeners();
  }

  clearSearchedProducts(){
    searchProductData.clear();
    notifyListeners();
  }

  setSearchedDealerData(DealerList value){
    searchedDealersList.add(value);
    notifyListeners();
  }

  clearSearchedDealerList(){
    searchedDealersList.clear();
    notifyListeners();
  }

  initDealers() {
    bool check = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    _checkIsLogin = check;
    notifyListeners();
  }

  @override
  notifyListeners();

  getDealerListApi({String? categoryId, String? rating, bool isFavOnly = false}) async {
    dealersList = [];
    searchedDealersList = [];
    dealerListResponse = DealerListResponse();
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "category_id" : categoryId,
      "rating" : rating??"",
      "cart_type": cartType.toString(),
      "record_type": isFavOnly ? "Fav" : "",
    };
    var response = await ApiBaseHelper().postApiCall(false, dealerList, body,isShimmer: true);
    dealerListResponse = DealerListResponse.fromJson(response);
    if (dealerListResponse?.success ?? false) {
      dealersList = dealerListResponse?.result?.rows;
    }
    notifyListeners();
  }

  getTopPartsCategoriesApi({String categoryId = ""}) async {
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
    var response = await ApiBaseHelper().postApiCall(true, partCategoryList, body);
    productsPartCategoryModel = ProductsPartCategoryModel.fromJson(response);
    categories = productsPartCategoryModel?.result?.categories;
    notifyListeners();
  }

  getSortApi({String? sort}) async {
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "sort" : sort,
      "cart_type": cartType,
    };
    var response = await ApiBaseHelper().postApiCall(true, dealerList, body);
    dealerListResponse = DealerListResponse.fromJson(response);
    if (dealerListResponse?.success ?? false) {
      dealersList = dealerListResponse?.result?.rows;
    }
    notifyListeners();
  }


  productPartsApi({required String categoryId, String? productsCategoryId,String? isFeatured, bool isFavOnly = false}) async {
    productsPartModel = null;
    productData = null;
    productData = productsPartModel?.result?.products?.data;
    productsPartModel = ProductsPartModel();
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "category_id" : categoryId,
      "product_category_id" : productsCategoryId,
      "featured" : isFeatured,
      "cart_type": cartType,
      "record_type": isFavOnly ? "Fav" : "",
    };
    var response = await ApiBaseHelper().postApiCall(false, products, body,isShimmer: true);
    productsPartModel = ProductsPartModel.fromJson(response);
    if (productsPartModel?.success ?? false) {
      productData = productsPartModel?.result?.products?.data;
    }
    notifyListeners();
  }




  productDetailsPartsApi(productId) async {
    result = null;
    result = ResultData();
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "product_id" : productId,
      "cart_type":cartType,
    };
    var response = await ApiBaseHelper().postApiCall(true, productsDetails, body);
    GetProductDetails getProductDetails = GetProductDetails.fromJson(response);
    if (getProductDetails.success ?? false) {
      result = getProductDetails.result;
    }
    notifyListeners();
  }

  // dealerListApi(categoryId,rating) async {
  //   var context = NavigationService.navigatorKey.currentContext;
  //   Map<String, dynamic> body = {
  //     "category_id" : categoryId,
  //     "rating" : rating,
  //   };
  //   var response = await ApiBaseHelper().postApiCall(true, dealerList, body);
  //    commonResponse = CommonResponse.fromJson(response);
  //   if(commonResponse!.success == true){
  //     Navigator.pop(context!);
  //   }else{
  //     print(commonResponse!.msg);
  //   }
  //   notifyListeners();
  // }


  getDealerDetailsApi(dealerId,{String? primaryCategoryId}) async {
    dealerDetails = null;
    dealerDetailsResponse = DealerDetailsResponse();
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "user_id": dealerId,
      "cart_type": cartType.toString(),
    };
    var response = await ApiBaseHelper().postApiCall(true, dealerDetailsApi, body);

    dealerDetailsResponse = DealerDetailsResponse.fromJson(response);
    if (dealerDetailsResponse?.success ?? false) {
      dealerDetails = dealerDetailsResponse?.result;
      if(productList!=null){
        productList!.clear();
      }
      if (dealerDetails!.dealerCategories!.isNotEmpty) {
        dealerDetails?.dealerCategories?[0].isSelect = true;
        getProductsListApi(primaryCategoryId,productCategoryId: dealerDetails?.dealerCategories?[0].categoryId.toString(),isUserSpecific: "Yes");
      }
    }

    notifyListeners();
  }

  getProductsListApi(categoryId,{String? productCategoryId,isUserSpecific}) async {
    productList = [];
    productListResponse = ProductListResponse();
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "category_id": categoryId,
      "product_category_id": productCategoryId,
      "cart_type": cartType,
      "user_specific": isUserSpecific??"",
    };
    var response = await ApiBaseHelper().postApiCall(true, productsListApi, body);
    productListResponse = ProductListResponse.fromJson(response);
    productList = productListResponse?.result?.products?.data;
    notifyListeners();
  }

 // sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString()
  getFilterCategoryApi(categoryId) async {
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "category_id": categoryId,
      "cart_type": cartType
    };
    var response = await ApiBaseHelper().postApiCall(true, partCategoryList, body);
    partCategoriesList = PartCategoriesList.fromJson(response);
    categoriesData = partCategoriesList?.result?.categories;
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
    var response = await ApiBaseHelper().postApiCall(true, getAllAdvertisement, body);
    advertisementResponse = AdvertisementResponse.fromJson(response);
    notifyListeners();
  }

  sortProductsApi({String? sort,required String isFeatured}) async {
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "sort" : sort,
      "featured": isFeatured,
      "cart_type": cartType,
    };
    var response = await ApiBaseHelper().postApiCall(true, products, body);
    productsPartModel = ProductsPartModel.fromJson(response);
    if (productsPartModel?.success ?? false) {
      productData = productsPartModel?.result?.products?.data;
    }
    notifyListeners();
  }
}
