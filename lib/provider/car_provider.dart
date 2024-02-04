
import 'package:autoparts/main.dart';
import 'package:autoparts/models/all_cars_model.dart';
import 'package:autoparts/models/car_category_model.dart';
import 'package:autoparts/models/car_convertible_model.dart';
import 'package:autoparts/models/car_detailss_model.dart';
import 'package:autoparts/models/common_model.dart';
import 'package:autoparts/models/dealers_filter_model.dart';
import 'package:autoparts/models/dealers_list_model.dart';
import 'package:autoparts/models/get_products_details.dart';
import 'package:autoparts/models/home_data_model.dart';
import 'package:autoparts/models/part_categories_list.dart';
import 'package:autoparts/models/products_parts_model.dart';
import 'package:autoparts/routes/navigator_service.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:flutter/cupertino.dart";

import '../api_service/api_base_helper.dart';
import '../api_service/api_config.dart';
import '../models/dealers_details_model.dart';
import '../models/product_list_model.dart';

class CarProvider with ChangeNotifier {
  List<CarCategories>? categories;
  List<CarCategories>? carCategories = [];
  List<CarCategories>? partCategories = [];
  List<ConvertibleData>? convertibleDataList;
  CarCategoryListModel? carCategoryListModel;
  CarConvertibleModel? carConvertibleModel;
  CarDetailsModel? carDetailsModel;
  List<String> carImages = [];
  CarResultDetails? result;
  AllCarsModel? allCarsModel;

  List<CarCategories> searchTopCategoryData = [];
  List<ConvertibleData> searchedCarSubCategoryList = [];

  setSearchCategoryData(CarCategories value){
    searchTopCategoryData.add(value);
    notifyListeners();
  }

  setSearchCategoryClear(){
    searchTopCategoryData.clear();
    notifyListeners();
  }

  setSearchedCarSubCategoryData(ConvertibleData value){
    searchedCarSubCategoryList.add(value);
    notifyListeners();
  }

  clearSearchedCarSubCategoryData(){
    searchedCarSubCategoryList.clear();
    notifyListeners();
  }

  bool? _checkIsLogin;

  bool? get checkIsLogin => _checkIsLogin ?? false;

  initCarProvider() {
    bool check = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    _checkIsLogin = check;
    notifyListeners();
  }



  @override
  notifyListeners();
  // sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString()
  getTopCategoriesApi(categoryId,{bool showLoader = true}) async {
    carCategoryListModel = CarCategoryListModel();
    categories = [];
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
    var response = await ApiBaseHelper().postApiCall(showLoader, partCategoryList, body,isShimmer: !showLoader);
    carCategoryListModel = CarCategoryListModel.fromJson(response);
    categories = carCategoryListModel?.result?.categories;
    notifyListeners();
  }

  getCategoriesApi(categoryId,{bool showLoader = true}) async {
    carCategoryListModel = CarCategoryListModel();
    carCategories = [];
    partCategories = [];
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
    var response = await ApiBaseHelper().postApiCall(showLoader, partCategoryList, body,isShimmer: !showLoader);
    carCategoryListModel = CarCategoryListModel.fromJson(response);
    if (categoryId.toString() == "1") {
      carCategories = carCategoryListModel?.result?.categories;
    }else if(categoryId.toString() == "2"){
      partCategories = carCategoryListModel?.result?.categories;
    }
    notifyListeners();
  }

  getCarConvertible(categoryId,{String? isFeatured,String? carCategoryId,bool isShimmer = false,String? sort,makeId,modelId
  ,bool isFavOnly = false,year,minPrice,maxPrice,minMileage,maxMileage,transmissionType,productCondition}) async {
    carConvertibleModel = CarConvertibleModel();
    convertibleDataList = [];
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "category_id": categoryId,
      "featured": isFeatured??"",
      "cart_type": cartType,
      "carCategoryId": carCategoryId??"",
      "sort": sort??"",
      "makeId": makeId??"",
      "modelId": modelId??"",
      "record_type": isFavOnly ? "Fav" : "",
      "year": year??"",
      "min_price": minPrice??"",
      "max_price": maxPrice??"",
      "min_mileage": minMileage??"",
      "max_mileage": maxMileage??"",
      "transmission_type": transmissionType??"",
      "product_condition": productCondition??"",
    };
    var response = await ApiBaseHelper().postApiCall(!isShimmer, carsApi, body,isShimmer: isShimmer);
    carConvertibleModel = CarConvertibleModel.fromJson(response);
    convertibleDataList = carConvertibleModel?.result?.products?.data;
    convertibleDataList?.forEach((element) {
      element.carName = '${element.make?.title ?? ""} ${element.model?.title ?? ""} | ${element.carCategory?.name ?? ""}';
    });
    notifyListeners();
  }

  carDetailsPartsApi(productId,{String? sellRecordId}) async {
    result = CarResultDetails();
    carImages = [];
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "product_id" : productId,
      "cart_type": cartType,
      "sell_record_id": sellRecordId?.toString()??"",
    };
    var response = await ApiBaseHelper().postApiCall(true, carDetailApi, body);
    carDetailsModel = CarDetailsModel.fromJson(response);
    if (carDetailsModel?.success ?? false) {
      result = carDetailsModel?.result;
      carImages.add(carDetailsModel?.sellData?.image.toString()??"");
      if ((carDetailsModel?.sellData?.imageTwo.toString()??"") != "null") {
        print(carDetailsModel?.sellData?.imageTwo.toString()??"");
        carImages.add(carDetailsModel?.sellData?.imageTwo.toString()??"");
      }
      if ((carDetailsModel?.sellData?.imageThree.toString()??"") != "null") {
        print(carDetailsModel?.sellData?.imageThree.toString()??"");
        carImages.add(carDetailsModel?.sellData?.imageThree.toString()??"");
      }
    }
    notifyListeners();
  }

  getAllCars({categoryId,sort,vin,makeId,modelId,year}) async {
    allCarsModel = AllCarsModel();
    notifyListeners();
    var cartType;
    if (!_checkIsLogin!) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "category_id": categoryId,
      "sort": sort??"",
      "cart_type": "user",
      "vin": vin,
      "makeId": makeId,
      "modelId": modelId,
      "year": year,
    };
    var response = await ApiBaseHelper().postApiCall(true, allCars, body);
    allCarsModel = AllCarsModel.fromJson(response);
    allCarsModel?.result?.products?.forEach((element) {
      element.carNames = '${element.make?.title ?? ""} ${element.model?.title ?? ""} | ${element.carCategory?.name ?? ""}';
    });
    notifyListeners();
  }
}
