import 'package:autoparts/api_service/api_base_helper.dart';
import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/app_ui/screens/location/location_screen.dart';
import 'package:autoparts/app_ui/screens/user_profile/user_account_screen.dart';
import 'package:autoparts/models/api_response_model.dart';
import 'package:autoparts/models/car_category_model.dart';
import 'package:autoparts/models/car_convertible_model.dart';
import 'package:autoparts/models/car_makes_response.dart';
import 'package:autoparts/models/car_models_response.dart';
import 'package:autoparts/models/car_sell_response.dart';
import 'package:autoparts/models/common_model.dart';
import 'package:autoparts/models/country_list_model.dart';
import 'package:autoparts/models/interest_list_model.dart';
import 'package:autoparts/models/reminder_list_model.dart';
import 'package:autoparts/models/review_rating_response.dart';
import 'package:autoparts/models/sell_listing_response.dart';
import 'package:autoparts/models/user_profile_model.dart';
import 'package:autoparts/provider/dashboard_provider.dart';
import 'package:autoparts/routes/navigator_service.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/add_remove_notification_model.dart';

class UserProvider with ChangeNotifier {

  var page = 1;
  var limit = "20";
// var pageSize = 0;

  // There is next page or not
  bool hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool isDismiss = false;

  // Used to display loading indicators when _loadMore function is running
  bool isLoadMore = false;

  setNextPage(value) {
    hasNextPage = value;
    notifyListeners();
  }

  setDismiss(value) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      isDismiss = value;
      notifyListeners();
    });
  }

  setLoadMore(value) {
    isLoadMore = value;
    notifyListeners();
  }


  init() {
    sellListing = [];
    page = 1;
    hasNextPage = true;
    isLoadMore = false;
    isDismiss = false;
  }





  CountryListModel? countryListModel = CountryListModel();
  ReviewRatingResponse? reviewRatingResponse = ReviewRatingResponse();
  List<SoldData>? sellListing = [];
  UserProfileModel? userProfileModel = UserProfileModel();
  CarMakesResponse? carMakesResponse = CarMakesResponse();
  CarModelsResponse? carModelsResponse = CarModelsResponse();
  CarSellResponse? carSellResponse = CarSellResponse();
  InterestListModel? interestListModel = InterestListModel();
  CarCategoryListModel? carCategoryListModel;
  CarConvertibleModel? carConvertibleModel;
  List<ConvertibleData>? convertibleDataList;
  AddRemoveNotificationModel? addRemoveNotificationModel;
  ReminderList? reminderListResponse;
  CommonResponse commonResponse = CommonResponse();
  List<InterestRecords>? interestRecordsList = [];
  bool? _checkIsLogin;
  bool? get checkIsLogin => _checkIsLogin ?? false;

  @override
  notifyListeners();

  initUserProvider() {
    bool check = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    _checkIsLogin = check;
    notifyListeners();
  }

  updateUserProfileApi(
      firstName, lastName, email, gender, nationality, interest,bool isNewUser,
      [selectedDob, type]) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "user_type": "Individual",
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "nationality": nationality,
      "interest": interest,
      "dob": selectedDob,
      "image": sp!.getString(SpUtil.USER_IMAGE)
    };
    var response = await ApiBaseHelper().postApiCall(true, updateUserProfile, body);
    Navigator.pop(context!);
    UserProfileModel userProfileModel = UserProfileModel.fromJson(response);
    showToastMessage(userProfileModel.msg??"");
    if (userProfileModel.success == true) {
      sp!.putString(SpUtil.USER_NAME, userProfileModel.result!.name ?? "");
      sp!.putString(SpUtil.USER_TYPE, userProfileModel.result!.userType ?? "");
      sp!.putString(SpUtil.USER_IMAGE, userProfileModel.result!.image ?? "");
      sp!.putString(SpUtil.COUNTRY_CODE, userProfileModel.result?.nationality??"+971");
      if (type == "edit") {
        Navigator.pushReplacementNamed(context, UserAccountScreen.routeName);
      } else {
        sp?.putString(SpUtil.USER_MOBILE, "");
        sp?.putString(SpUtil.LOGIN_PASSWORD, "");
        sp?.putString(SpUtil.COUNTRY_CODE, "+971");
        sp?.putBool(SpUtil.REMEMBER_ME, false);
        sp!.putBool(SpUtil.IS_LOGGED_IN, true);
        context.read<DashboardProvider>().initDashboard();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LocationScreen(isNewUser: isNewUser,)), (route) => false);
      }
    }
    notifyListeners();
  }

  getUserProfileApi() async {
    userProfileModel = null;
    userProfileModel = UserProfileModel();
    notifyListeners();
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
    };
    var response = await ApiBaseHelper().postApiCall(true, getUserProfile, body);
    userProfileModel = UserProfileModel.fromJson(response);
    if (userProfileModel!.success == true) {}
    notifyListeners();
  }

  getCarMakesApi() async {
    // carMakesResponse = null;
    // carMakesResponse = CarMakesResponse();
    // notifyListeners();
    // var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {};
    var response = await ApiBaseHelper().postApiCall(true, carMakesApi, body);
    carMakesResponse = CarMakesResponse.fromJson(response);
    if ((carMakesResponse?.success??false) == true) {

    }
    notifyListeners();
  }

  getCarModelsApi({required String carMakeId}) async {
    carModelsResponse = null;
    carModelsResponse = CarModelsResponse();
    notifyListeners();
    // var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "makeId": carMakeId
    };
    var response = await ApiBaseHelper().postApiCall(true, carModelsApi, body);
    carModelsResponse = CarModelsResponse.fromJson(response);
    if ((carModelsResponse?.success??false) == true) {

    }
    notifyListeners();
  }

  clearCarsListing() {
    carConvertibleModel = CarConvertibleModel();
    convertibleDataList = [];
    notifyListeners();
  }

  getCarsListing({categoryId,sort,vin,makeId,modelId,year,}) async {
    carConvertibleModel = CarConvertibleModel();
    convertibleDataList = [];
    notifyListeners();
    var cartType;
    if (!(_checkIsLogin??false)) {
      cartType = "guest";
    } else {
      cartType = "user";
    }
    Map<String, dynamic> body = {
      "category_id": categoryId,
      "sort": sort??"",
      "cart_type": cartType,
      "vin": vin,
      "makeId": makeId,
      "modelId": modelId,
      "year": year,
    };
    var response = await ApiBaseHelper().postApiCall(true, carsApi, body);
    carConvertibleModel = CarConvertibleModel.fromJson(response);
    convertibleDataList = carConvertibleModel?.result?.products?.data;
    notifyListeners();
  }

  Future<bool> carSellApi({
    carId,description,mileage,mileageType,carCondition,warranty,color,price,imageOne,imageTwo,imageThree,chassisNumber,
    kmDriven,kmDrivenType,engineNumber,warrantyTime,warrantyType,
  }) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "carId": carId,
      "cart_type": "user",
      "description": description,
      "mileage": mileage,
      "mileage_type": mileageType,
      "car_condition": carCondition,
      "warranty": warranty,
      "color": color,
      "price": price,
      "image_one": imageOne,
      "image_two": imageTwo,
      "image_three": imageThree,
      "chassis_number": chassisNumber,
      "km_driven": kmDriven.toString(),
      "km_driven_type": kmDrivenType.toString(),
      "engine_number": engineNumber.toString(),
      "warranty_time": warrantyTime.toString(),
      "warranty_type": warrantyType.toString(),
    };
    var response = await ApiBaseHelper().postApiCall(true, carSellAddress, body);
    carSellResponse = CarSellResponse.fromJson(response);
    notifyListeners();
    return (carSellResponse?.success??false);
  }

  Future<bool> updateSoldCar({
    carId,description,mileage,mileageType,carCondition,warranty,color,price,imageOne,imageTwo,imageThree,recordId,
    chassisNumber,kmDriven,kmDrivenType,engineNumber,warrantyTime,warrantyType,
  }) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "carId": carId.toString(),
      "cart_type": "user",
      "description": description,
      "mileage": mileage,
      "mileage_type": mileageType,
      "car_condition": carCondition,
      "warranty": warranty,
      "color": color,
      "price": price,
      "image_one": imageOne,
      "image_two": imageTwo,
      "image_three": imageThree,
      "record_id": recordId.toString(),
      "chassis_number": chassisNumber.toString(),
      "km_driven": kmDriven.toString(),
      "km_driven_type": kmDrivenType.toString(),
      "engine_number": engineNumber.toString(),
      "warranty_time": warrantyTime.toString(),
      "warranty_type": warrantyType.toString(),
    };
    var response = await ApiBaseHelper().postApiCall(true, updateSoldCarAddress, body);
    carSellResponse = CarSellResponse.fromJson(response);
    if(carSellResponse?.success??false){
      showToastMessage(carSellResponse?.msg??"");
      Navigator.pop(context!,"update");
    }
    notifyListeners();
    return (carSellResponse?.success??false);
  }

  updateBusinessProfileApi(
      headerNetworkImage,
      businessLogoNetworkImage,
      businessName,
      mobile,
      countryCode,
      whatsAppNumber,
      whatsAppCountryCode,
      email,
      tradeLicenseImage,
      bool isNewUser,
      [type]
      ) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "user_type": "Business",
      "email": email,
      "business_name": businessName,
      "address": "Jaipur",
      "latitude": "26.922070",
      "longitude": "75.778885",
      "country_code": countryCode,
      "mobile": mobile,
      "whatsapp_country_code": whatsAppCountryCode,
      "whatsapp_mobile": whatsAppNumber,
      "header_image": headerNetworkImage,
      "business_logo": businessLogoNetworkImage,
      "trade_license": tradeLicenseImage
    };
    var response = await ApiBaseHelper().postApiCall(true, updateUserProfile, body);
    UserProfileModel userProfileModel = UserProfileModel.fromJson(response);
    showToastMessage(userProfileModel.msg!);
    if (userProfileModel.success == true) {
      if (type == "edit") {
        // Navigator.pushReplacementNamed(context!, UserAccountScreen.routeName);
        Navigator.pop(context!,"update");
      } else {
        sp?.putString(SpUtil.USER_MOBILE, "");
        sp?.putString(SpUtil.LOGIN_PASSWORD, "");
        sp?.putString(SpUtil.COUNTRY_CODE, "+971");
        sp?.putBool(SpUtil.REMEMBER_ME, false);
        sp!.putBool(SpUtil.IS_LOGGED_IN, true);
        context!.read<DashboardProvider>().initDashboard();
        // Navigator.pushNamedAndRemoveUntil(context, LocationScreen.routeName, (route) => false);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>  LocationScreen(isNewUser: isNewUser,)), (route) => false);
      }
    }
    notifyListeners();
  }

  createBecomeADealerApi(headerNetworkImage, businessLogoNetworkImage,
      businessName, tradeLicenseImage) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "business_name": businessName,
      "address": "Jaipur",
      "latitude": "26.922070",
      "longitude": "75.778885",
      "header_image": headerNetworkImage,
      "business_logo": businessLogoNetworkImage,
      "trade_license": tradeLicenseImage
    };
    var response = await ApiBaseHelper().postApiCall(true, becomeADealer, body);
    UserProfileModel userProfileModel = UserProfileModel.fromJson(response);
    showToastMessage(userProfileModel.msg!);
    if (userProfileModel.success == true) {
      sp?.putBool(SpUtil.IS_SELLER, true);
      Navigator.pop(context!);
      sp?.putString(SpUtil.USER_TYPE, "Seller");

    }
    notifyListeners();
  }

  getInterestListApi() async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {};
    var response = await ApiBaseHelper().postApiCall(false, interestList, body);
    interestListModel = InterestListModel.fromJson(response);
    interestRecordsList = interestListModel!.result!.records;
    notifyListeners();
  }

  getCountryListApi() async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {};
    var response = await ApiBaseHelper().postApiCall(false, countryList, body);
    countryListModel = CountryListModel.fromJson(response);
    notifyListeners();
  }

  getReviewRatingsApi() async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "user_id": sp.getString(SpUtil.USER_ID)
    };
    var response = await ApiBaseHelper().postApiCall(true, reviewRatings, body);
    reviewRatingResponse = ReviewRatingResponse.fromJson(response);
    notifyListeners();
  }

  changePasswordApi(oldPassword, newPassword) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
    var response = await ApiBaseHelper().postApiCall(true, changePassword, body);
    ApiResponseModel apiResponseModel = ApiResponseModel.fromJson(response);

    if (apiResponseModel.success == true) {
      showToastMessage(apiResponseModel.msg??"");
      sp!.putString(SpUtil.LOGIN_PASSWORD, "");
      Navigator.pop(context!);
    } else {
      //showToastMessage(apiResponseModel.msg!);
    }
    notifyListeners();
  }

  // getUserSellerListingApi() async {
  //   // var context = NavigationService.navigatorKey.currentContext;
  //   Map<String, dynamic> body = {
  //     "cart_type": "user",
  //     "page": "1"
  //   };
  //   var response = await ApiBaseHelper().postApiCall(false, userSellList, body,isShimmer: true);
  //   SellListingResponse sellListingResponse = SellListingResponse.fromJson(response);
  //   sellListing = sellListingResponse.result?.products?.data??[];
  //   notifyListeners();
  // }

  getUserSellerListingApi({isLoader}) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "cart_type": "user",
      "page": page.toString(),
    };
    var response = await ApiBaseHelper().postApiCall(true, userSellList, body,isShimmer: false);
    SellListingResponse model = SellListingResponse.fromJson(response);
    setLoadMore(false);
    if (model.success == true) {

    //pageSize = model.data!.totalPages ?? 0;
    if ((model.result?.products?.data??[]).isNotEmpty) {
      page++;
      sellListing?.addAll(model.result?.products?.data??[]);
      notifyListeners();
    } else {
      setNextPage(false);
      setDismiss(true);
    }
    }else{
      setNextPage(false);
      setDismiss(true);
    }
  }

  markProductAsSoldApi({productId,recordId}) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "cart_type": "user",
      "product_id": productId,
      "record_id": recordId,
      "sell_status": "Sold"
    };
    var response = await ApiBaseHelper().postApiCall(true, markProductAsSold, body);
    commonResponse = CommonResponse.fromJson(response);
    if(commonResponse.success??false){
      await context?.read<UserProvider>().getUserSellerListingApi();
    }
    showToastMessage(commonResponse.msg??"");
    notifyListeners();
  }

  addReminderApi({carId,productId}) async {
    // var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "cart_type": "user",
      "carId": carId.toString(),
      "productId": productId.toString(),
    };
    var response = await ApiBaseHelper().postApiCall(true, addReminder, body);
    commonResponse = CommonResponse.fromJson(response);
    showToastMessage(commonResponse.msg??"");
    notifyListeners();
  }

  Future<int> setReminderApi({String? userId}) async {
    Map<String, dynamic> body = {"user_id": userId};
    var response = await ApiBaseHelper().postApiCall(true, addRemoveNotification, body);
    addRemoveNotificationModel = AddRemoveNotificationModel.fromJson(response);
    notifyListeners();
    return addRemoveNotificationModel?.isReminder??0;
  }

 getReminderListApi() async {
    Map<String, dynamic> body = {};
    var response = await ApiBaseHelper().postApiCall(true, reminderList, body);
    reminderListResponse = ReminderList.fromJson(response);
    reminderListResponse?.result?.products?.data?.forEach((element) {
      element.carName = '${element.car?.make?.title ?? ""} ${element.car?.model?.title ?? ""} | ${element.car?.carCategory?.name ?? ""}';
    });
    notifyListeners();
  }

  deleteReminderApi({required String reminderId,required int index}) async {
    Map<String, dynamic> body = {
      "cart_type": "user",
      "reminderId": reminderId,
    };
    var response = await ApiBaseHelper().postApiCall(
        true, deleteReminder, body);
    commonResponse = CommonResponse.fromJson(response);
    showToastMessage(commonResponse.msg ?? "");
    if (commonResponse.success??false) {
      reminderListResponse?.result?.products?.data?.removeAt(index);
    }
    notifyListeners();
  }
}