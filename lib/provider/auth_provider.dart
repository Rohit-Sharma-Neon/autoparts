import 'dart:io';
import 'package:autoparts/api_service/api_base_helper.dart';
import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/app_ui/screens/auth/forgot_password/forgot_password.dart';
import 'package:autoparts/app_ui/screens/location/location_screen.dart';
import 'package:autoparts/app_ui/screens/auth/login/login_screen.dart';
import 'package:autoparts/app_ui/screens/auth/signup_screen/set_password_screen.dart';
import 'package:autoparts/app_ui/screens/auth/signup_screen/signup_select_type.dart';
import 'package:autoparts/app_ui/screens/auth/signup_screen/verify_screen_otp.dart';
import 'package:autoparts/app_ui/screens/tutorial/tutorial_screen.dart';
import 'package:autoparts/chat/chat_constants.dart';
import 'package:autoparts/main.dart';
import 'package:autoparts/models/User_model.dart';
import 'package:autoparts/models/send_0tp_model.dart';
import 'package:autoparts/models/static_page_response.dart';
import 'package:autoparts/models/user_profile_model.dart';
import 'package:autoparts/provider/dashboard_provider.dart';
import 'package:autoparts/provider/sellers_provider.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:autoparts/routes/navigator_service.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:twitter_login/twitter_login.dart';

import 'car_provider.dart';
import 'dealers_provider.dart';
import 'favourite_provider.dart';
import 'notofication_provider.dart';

class AuthProvider with ChangeNotifier {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  late FirebaseFirestore firebaseFirestore;
  String? deviceType;
  String? deviceToken;
  String? _phoneNumber;
  String? _countryCode;
  String? otp;
  StaticPageResponse? staticPageResponse;
  String? _fromForgot;
  bool? _rememberMe = false;
  @override
  notifyListeners();
  String? get phoneNumber => _phoneNumber;

  String? get countryCode => _countryCode;

String? get otpNumber => otp;

  bool? get rememberMe => _rememberMe;

  String get fromForgot => _fromForgot = "";

  setPhoneNumber(value) {
    _phoneNumber = value;
    notifyListeners();
  }

  setCountryCode(value) {
    _countryCode = value;
    notifyListeners();
  }

  setOtp(value) {
    otp = value;
    notifyListeners();
  }

  setRememberMe(value) {
    _rememberMe = value;
    notifyListeners();
  }

  setFromForgot(value) {
    _fromForgot = value;
    notifyListeners();
  }

  void init() {
    deviceToken = sp?.getString(SpUtil.FCM_TOKEN)??"";
    if (Platform.isAndroid) {
      deviceType = "Android";
    } else if (Platform.isIOS) {
      deviceType = "IOS";
    }
    notifyListeners();
  }

  sendOtpApi({required String type}) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "country_code": countryCode,
      "mobile": phoneNumber,
      "type": type,
    };
    var response = await ApiBaseHelper().postApiCall(true,sendOtp, body);
    SendOtpModel sendOtpModel = SendOtpModel.fromJson(response);
    if (sendOtpModel.success == true) {
        setOtp(sendOtpModel.result?.otp??"");
        if (type == "resendOtp") {

        }else{
          Navigator.push(context!, MaterialPageRoute(builder: (context)=> VerifyOtpScreen(phone: phoneNumber??"", countryCode: countryCode??"", otp: otpNumber??"",screenType: type,)));
        }
    } else {
      //showToastMessage(sendOtpModel.msg!);
    }
  }

  getStaticPage({String? type}) async {
    Map<String, dynamic> body = {
      "slug": type,
    };
    var response = await ApiBaseHelper().postApiCall(true,staticPages, body);
    staticPageResponse = StaticPageResponse.fromJson(response);
    notifyListeners();
  }

  verifyOtpApi(fillOtp,{required String screenType}) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "country_code": countryCode,
      "mobile": phoneNumber,
      // "type": fromForgot == "forgot" ? "forgot_password" : "register",
      "type": screenType,
      "otp": fillOtp,
    };
    var response = await ApiBaseHelper().postApiCall(true,verifyOtp, body);
    SendOtpModel sendOtpModel = SendOtpModel.fromJson(response);

    if (sendOtpModel.success == true) {
      if (screenType == "forgot_password") {
        Navigator.pushNamed(context!, ForgotPasswordScreen.routeName);
      } else {
        Navigator.push(context!, MaterialPageRoute(builder: (context)=> SetPasswordScreen(screenType: screenType)));
      }
    } else {
     // showToastMessage(sendOtpModel.msg!);
    }
  }

  signupApi(password,{required String screenType}) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "country_code": countryCode,
      "mobile": phoneNumber,
      "type": "register",
      "otp": otpNumber,
      "device_token": deviceToken,
      "device_type": deviceType,
      "password": password,
    };
    var response = await ApiBaseHelper().postApiCall(true,signup, body);
    UserProfileModel userProfileModel = UserProfileModel.fromJson(response);

    if (userProfileModel.success == true) {
      sp!.putString(SpUtil.ACCESS_TOKEN, userProfileModel.result!.token!);
      sp!.putString(SpUtil.USER_ID, userProfileModel.result!.id!.toString());
      sp!.putString(SpUtil.USER_EMAIL, userProfileModel.result!.email ?? "");
      sp!.putString(SpUtil.USER_NAME, userProfileModel.result!.name ?? "");
      sp!.putString(SpUtil.USER_TYPE, userProfileModel.result!.userType ?? "");
      sp!.putString(SpUtil.USER_IMAGE, userProfileModel.result!.image ?? "");
      if (screenType == "register") {
        Navigator.pushNamed(context!, SignupSelectType.routeName);
      }else if(screenType == "forgot_password"){
        Navigator.pushNamed(context!, LoginScreen.routeName);
      }
    } else {
      showToastMessage(userProfileModel.msg!);
    }
  }

  loginApi(password) async {
    firebaseFirestore = FirebaseFirestore.instance;
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "country_code": countryCode,
      "mobile": phoneNumber,
      "device_token": deviceToken,
      "device_type": deviceType,
      "password": password,
    };
    var response = await ApiBaseHelper().postApiCall(true,login, body);
    UserProfileModel userProfileModel = UserProfileModel.fromJson(response);
    if (userProfileModel.success == true) {
      sp!.putString(SpUtil.ACCESS_TOKEN, userProfileModel.result!.token!);
      sp!.putString(SpUtil.USER_ID, userProfileModel.result!.id!.toString());
      sp!.putString(SpUtil.USER_EMAIL, userProfileModel.result!.email ?? "");
      sp!.putString(SpUtil.USER_NAME, userProfileModel.result!.name ?? "");
      sp!.putString(SpUtil.USER_TYPE, userProfileModel.result!.userType ?? "");
      sp!.putString(SpUtil.USER_IMAGE, userProfileModel.result!.image ?? "");
      sp!.putBool(SpUtil.IS_SELLER, (userProfileModel.result?.becomeASeller??"") == "Yes" ? true : false);

      final QuerySnapshot result = await firebaseFirestore.collection(ChatConstants().tableName)
            .where(ChatConstants().id, isEqualTo: userProfileModel.result?.id?.toString()??"").get();
      final List<DocumentSnapshot> document = result.docs;
      if (document.isEmpty) {
        firebaseFirestore
            .collection(ChatConstants().tableName)
            .doc(userProfileModel.result?.id?.toString()??"")
            .set({
          ChatConstants().userName: userProfileModel.result?.name?.toString()??"",
          ChatConstants().profileImage: userProfileModel.result?.image,
          ChatConstants().id: userProfileModel.result?.id?.toString()??"",
          "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
          ChatConstants().chattingWith: null,
        });}

      // saveCredentials(userProfileModel.result!.mobile, password);
      if (userProfileModel.result!.userType != null) {
        sp!.putBool(SpUtil.IS_LOGGED_IN, true);
        context!.read<DashboardProvider>().initDashboard();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LocationScreen(isNewUser: false,isSigningIn: true,)), (route) => false);
      } else {
        Navigator.pushNamed(context!, SignupSelectType.routeName);
      }
    }
  }

  forgotPasswordApi(password) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "country_code": countryCode,
      "mobile": phoneNumber,
      "type": "forgot",
      "otp": otpNumber,
      "device_token": deviceToken,
      "device_type": deviceType,
      "password": password,
    };
    var response = await ApiBaseHelper().postApiCall(true,updatePassword, body);
    UserProfileModel userProfileModel = UserProfileModel.fromJson(response);
    if (userProfileModel.success == true) {
      Navigator.pushNamedAndRemoveUntil(context!, LoginScreen.routeName, (route) => false);
    } else {
      // showToastMessage(userProfileModel.msg!);
    }
  }

  logoutApi() async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {
      "user_id": sp!.getString(SpUtil.USER_ID),
      "cart_type": "user"
    };
    var response = await ApiBaseHelper().postApiCall(true,logout, body);
    SendOtpModel sendOtpModel = SendOtpModel.fromJson(response);
    showToastMessage(sendOtpModel.msg!);
    sp!.remove(SpUtil.IS_LOGGED_IN);
    if (sendOtpModel.success == true) {
      String phone = sp?.getString(SpUtil.USER_MOBILE)??"";
      String password = sp?.getString(SpUtil.LOGIN_PASSWORD)??"";
      String countryCode = sp?.getString(SpUtil.COUNTRY_CODE)??"";
      String deviceToken = sp?.getString(SpUtil.FCM_TOKEN)??"";
      bool rememberMe = sp?.getBool(SpUtil.REMEMBER_ME)??false;
      sp?.clear();
      sp?.putString(SpUtil.FCM_TOKEN, deviceToken);
      sp?.putString(SpUtil.USER_MOBILE, phone);
      sp?.putString(SpUtil.LOGIN_PASSWORD, password);
      sp?.putString(SpUtil.COUNTRY_CODE, countryCode);
      sp?.putBool(SpUtil.REMEMBER_ME, rememberMe);
      context?.read<DashboardProvider>().initDashboard();
      context?.read<FavouriteProvider>().initDashboard();
      context?.read<DealersProvider>().initDealers();
      context?.read<SellersProvider>().initSellers();
      context?.read<UserProvider>().initUserProvider();
      context?.read<CarProvider>().initCarProvider();
      context?.read<NotificationProvider>().initNotificationsProvider();
      Navigator.pushAndRemoveUntil(context!, MaterialPageRoute(builder: (context)=> const TutorialScreen()), (route) => false);
      // Navigator.pushNamedAndRemoveUntil(context!, TutorialScreen.routeName, (route) => false);
    }
  }

  void saveCredentials(phone, password) {
    if (rememberMe!) {
      sp!.putString(SpUtil.LOGIN_PHONE, phone);
      sp!.putString(SpUtil.LOGIN_PASSWORD, password);
    } else {
      sp!.putString(SpUtil.LOGIN_PHONE, '');
      sp!.putString(SpUtil.LOGIN_PASSWORD, '');
    }
  }

  /// All social login function define below google, facebook, apple, twitter
  Future<UserModel?> googleSignInFunction() async {
    print("Google");
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      print("googleSignInAccount");
      print(googleSignInAccount);
      UserModel user = UserModel(
        email: googleSignInAccount?.email,
        name: googleSignInAccount?.displayName,
        profilePicURL: googleSignInAccount?.photoUrl,
      );
      return user;
    } catch (error) {
      print("exceprion");
      print(error);
    }
    return null;
  }

  Future<void> facebookSignInFunction() async {
    print("FaceBook");
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        print(userData);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> twitterSignInFunction() async {
    if (kDebugMode) {
      print("Twitter");
    }
    final twitterLogin = TwitterLogin(
      // Consumer API keys
      apiKey: 'BWWFuMdx1i5T1fLSKXkvKUJgN',
      // Consumer API Secret keys
      apiSecretKey: 'siZsGbpJfzrbGbVmLnXsU85EmepiI8wUMwU0KwSy3P1EaCoBx6',
      // Registered Callback URLs in TwitterApp
      // Android is a deeplink
      // iOS is a URLScheme
      redirectURI: 'twittersdk://',
    );
    final authResult = await twitterLogin.login();
    switch (authResult.status!) {
      case TwitterLoginStatus.loggedIn:
        print("success");
        print("authResult");
        print(authResult);
        print(authResult.user);
        // success
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        break;
      case TwitterLoginStatus.error:
        // error
        break;
    }
  }

  Future<void> appleSignInFunction() async {
    print("Apple");
  }
}
