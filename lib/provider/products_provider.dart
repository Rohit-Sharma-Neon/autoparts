
import 'package:autoparts/models/common_model.dart';
import 'package:autoparts/models/dealers_list_model.dart';
import 'package:autoparts/models/part_categories_list.dart';
import 'package:autoparts/models/product_sell_response.dart';
import 'package:autoparts/models/products_part_category_list.dart';
import 'package:autoparts/models/products_parts_model.dart';
import "package:flutter/cupertino.dart";
import '../api_service/api_base_helper.dart';
import '../api_service/api_config.dart';
import '../app_ui/common_widget/show_dialog.dart';
import '../main.dart';
import '../models/add_remove_notification_model.dart';
import '../routes/navigator_service.dart';
import '../utils/shared_preferences.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductData>? productData;
  List<DealerList>? dealersList;
  List<FilterCategories>? categories;
  CommonResponse commonResponse = CommonResponse();
  List<CategoriesData>? categoriesData;
  ProductsPartModel? productsPartModel;
  ProductSellResponse? productSellResponse;
  PartCategoriesList? partCategoriesList;
  ProductsPartCategoryModel? productsPartCategoryModel;
  DealerListResponse? dealerListResponse;

  bool? _checkIsLogin;

  bool? get checkIsLogin => _checkIsLogin ?? false;

  initProductsProvider() {
    bool check = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    _checkIsLogin = check;
    notifyListeners();
  }

  @override
  notifyListeners();

  productPartsApi() async {
    Map<String, dynamic> body = {};
    var response = await ApiBaseHelper().postApiCall(true, products, body);
    productsPartModel = ProductsPartModel.fromJson(response);
    if (productsPartModel?.success ?? false) {
      productData = productsPartModel?.result?.products?.data;
    }
    notifyListeners();
  }

  getFilterProductCategoryApi(categoryId) async {
    Map<String, dynamic> body = {
      "category_id": categoryId,
    };
    var response = await ApiBaseHelper().postApiCall(true, partCategoryList, body);
    productsPartCategoryModel = ProductsPartCategoryModel.fromJson(response);
    categories = productsPartCategoryModel?.result?.categories;
    notifyListeners();
  }
  getTopPartsCategoriesApi({String categoryId = ""}) async {
    Map<String, dynamic> body = {
      "category_id": categoryId,
    };
    var response = await ApiBaseHelper().postApiCall(true, partCategoryList, body);
    productsPartCategoryModel = ProductsPartCategoryModel.fromJson(response);
    categories = productsPartCategoryModel?.result?.categories;
    notifyListeners();
  }
  getDealerFilterListApi({String? categoryId,String? categoryIds}) async {
    Map<String, dynamic> body = {
      "category_id" : categoryId,
      "product_category_id": categoryIds??"",
    };
    var response = await ApiBaseHelper().postApiCall(true, products, body);
    dealerListResponse = DealerListResponse.fromJson(response);
    if (dealerListResponse?.success ?? false) {
      dealersList = dealerListResponse?.result?.rows;
    }
    notifyListeners();
  }
  getSortApi({String? sort}) async {
    Map<String, dynamic> body = {
      "sort" : sort,
      "featured": "Yes",
    };
    var response = await ApiBaseHelper().postApiCall(true, products, body);
    productsPartModel = ProductsPartModel.fromJson(response);
    if (productsPartModel?.success ?? false) {
      productData = productsPartModel?.result?.products?.data;
    }
    notifyListeners();
  }

  Future<bool> sellProductApi({productId,price,condition,expectancyType,expectancy,expectancyDurationType,wareHouseCode,
    description,subCategoryId,productImage,
    bool isProductNew = false,bool shouldPop = true}) async {
    var context = NavigationService.navigatorKey.currentContext;
    String categoryId = sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString();
    Map<String, dynamic> body = {};
    if (isProductNew) {
      body = {
        "sell_product_type": isProductNew ? "New" : "Exist",
        "cart_type": "user",
        "price": price,
        "condition": condition,
        "life_expectancy": expectancy,
        "life_expectancy_type": expectancyType,
        "distance_type": expectancyDurationType,
        "warehouse_code": wareHouseCode,
        "name": wareHouseCode,
        "serviceId": categoryId,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "descriptions": description,
        "qty": "1",
        "image": productImage,
      };
    }else{
      body = {
        "productId": productId,
        "sell_product_type": isProductNew ? "New" : "Exist",
        "cart_type": "user",
        "price": price,
        "condition": condition,
        "life_expectancy": expectancy,
        "life_expectancy_type": expectancyType,
        "distance_type": expectancyDurationType,
        "warehouse_code": wareHouseCode,
      };
    }
    var response = await ApiBaseHelper().postApiCall(true, sellProduct, body);
    productSellResponse = ProductSellResponse.fromJson(response);
    notifyListeners();
    return (productSellResponse?.success??false);
  }

  Future<bool> updateSoldProductApi({productId,price,condition,expectancyType,expectancy,expectancyDurationType,wareHouseCode,
    description,subCategoryId,productImage,recordId,businessName,
    bool isProductNew = false,bool shouldPop = true}) async {
    var context = NavigationService.navigatorKey.currentContext;
    String categoryId = sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString();
    Map<String, dynamic> body = {};
    if (isProductNew) {
      body = {
        "sell_product_type": isProductNew ? "New" : "Exist",
        "cart_type": "user",
        "price": price,
        "condition": condition,
        "life_expectancy": expectancy,
        "life_expectancy_type": expectancyType,
        "distance_type": expectancyDurationType,
        "warehouse_code": wareHouseCode,
        "name": businessName,
        "serviceId": categoryId,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "descriptions": description,
        "qty": "1",
        "image": productImage,
        "record_id": recordId.toString(),
        "productId": productId.toString(),
      };
    }else{
      body = {
        "productId": productId,
        "sell_product_type": isProductNew ? "New" : "Exist",
        "cart_type": "user",
        "price": price,
        "condition": condition,
        "life_expectancy": expectancy,
        "life_expectancy_type": expectancyType,
        "distance_type": expectancyDurationType,
        "warehouse_code": wareHouseCode,
        "record_id": recordId,
      };
    }
    var response = await ApiBaseHelper().postApiCall(true, updateSoldProductAddress, body);
    commonResponse = CommonResponse.fromJson(response);
    showToastMessage(commonResponse.msg??"");
    notifyListeners();
    return commonResponse.success??false;
  }

}
