import 'dart:convert';
import 'dart:io';
import 'package:autoparts/api_service/app_exception.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/main.dart';
import 'package:autoparts/models/uplaod_image_model.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:autoparts/routes/navigator_service.dart';
import 'package:autoparts/utils/connectivity.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiBaseHelper {
  SharedPreferences? prefs;

  Future<dynamic> getApiCall(String url) async {
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var context = NavigationService.navigatorKey.currentContext;
    if (isNetActive) {
      var responseJson;
      showLoader(context);

      var apiHeader = {
        'x-access-token': sp!.getString(SpUtil.ACCESS_TOKEN).toString(),
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      try {
        final response =
            await http.get(Uri.parse(BASE_URL + url), headers: apiHeader);
        Navigator.pop(context!);
        print("apiHeader=========>>>> $apiHeader");
        print("statusCode=========>>>> ${response.statusCode}");
        print("response=========>>>> ${response.body}");
        var res = jsonDecode(response.body);

        if (res['status'].toString() == '401') {
          if (res['message'].toString() ==
              'Unauthorized User: Login required.') {
            Fluttertoast.showToast(msg: res['message']);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
          }
        }

        responseJson = _returnResponse(response);
      } on SocketException {
        //  showToastMessage("No Internet connection");
        throw FetchDataException('No Internet connection');
      }
      return responseJson;
    } else {
      internetConnectionDialog(context);
    }
  }

  Future<dynamic> postApiCall(
    bool isShow,
    String url,
    Map<String, dynamic> jsonData,
  {bool isShimmer = false, String shimmerScreenName = ""}
  ) async {
    var context = NavigationService.navigatorKey.currentContext;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if (isNetActive) {
      if (isShow) {
        showLoader(context);
      }else if(isShimmer){
        // if (shimmerScreenName == "HOME") {
          Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }
        // else if(shimmerScreenName == "FAV"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }else if(shimmerScreenName == "ADD"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }else if(shimmerScreenName == "SEARCH"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }else if(shimmerScreenName == "MESSAGE"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }else if(shimmerScreenName == "FAV"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }else if(shimmerScreenName == "TOP_CATEGORIES"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }else if(shimmerScreenName == "ALL_DEALER"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }else if(shimmerScreenName == "ALL_SELLER"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }else if(shimmerScreenName == "DEALER_DETAIL"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }else if(shimmerScreenName == "SELLER_DETAIL"){
        //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: true);
        // }
      }
      var responseJson;
      var apiHeader = {
        'x-access-token': sp!.getString(SpUtil.ACCESS_TOKEN).toString(),
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      print("ApiUrl=========>>>> ${BASE_URL + url}");
      print("apiToken=========>>>> ${sp!.getString(SpUtil.ACCESS_TOKEN).toString()}");
      print("apiHeader=========>>>> $apiHeader");
      print("request=========>>>> ${jsonEncode(jsonData)}");

      try {
        final http.Response response = await http.post(
          Uri.parse(BASE_URL + url),
          headers: apiHeader,
          body: jsonEncode(jsonData),
        );
        if (isShow) {
          Navigator.pop(context!);
        }else if(isShimmer){
          // if (shimmerScreenName == "HOME") {
            Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }
          // else if(shimmerScreenName == "FAV"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }else if(shimmerScreenName == "ADD"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }else if(shimmerScreenName == "SEARCH"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }else if(shimmerScreenName == "MESSAGE"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }else if(shimmerScreenName == "FAV"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }else if(shimmerScreenName == "TOP_CATEGORIES"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }else if(shimmerScreenName == "ALL_DEALER"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }else if(shimmerScreenName == "ALL_SELLER"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }else if(shimmerScreenName == "DEALER_DETAIL"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }else if(shimmerScreenName == "SELLER_DETAIL"){
          //   Provider.of<LoadingProvider>(context!,listen: false).setHomeLoading(status: false);
          // }
        }

        print("statusCode=========>>>> ${response.statusCode}");
        print("response=========>>>> ${response.body}");

        try {
          responseJson = _returnResponse(response);

          if (!responseJson['success']) {
            // errorDialog(context!, title: responseJson['msg']);
          }
        } catch (e) {}
      } on SocketException {
        //showToastMessage("No Internet connection");
        throw FetchDataException('No Internet connection');
      }
      return responseJson;
    } else {
      internetConnectionDialog(context);
    }
  }

  Future<String> imageUploadApi(File file, String type,{bool isVideoUploading = false}) async {
    var context = NavigationService.navigatorKey.currentContext;
    String? returnType;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if (isNetActive) {
      if (isVideoUploading) {
        showToastMessage("Video uploading in the Background");
        Provider.of<LoadingProvider>(context!,listen: false).setVideoLoading(status: true);
      }else{
        showLoader(context);
      }
      var apiHeader = {
        'x-access-token': sp!.getString(SpUtil.ACCESS_TOKEN).toString(),
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      http.ByteStream? stream;
      int? length;
      stream = http.ByteStream(file.openRead());
      length = await file.length();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(BASE_URL + imageUpdate),
      );
      request.headers.addAll(apiHeader);
      request.files.add(
          http.MultipartFile('image', stream, length, filename: file.path));
      request.fields['image_type'] = type;
      var response = await request.send();
      await response.stream.transform(utf8.decoder).listen((response) {
        print("convert Data To Json ===>  $response");
        if (isVideoUploading) {
          Provider.of<LoadingProvider>(context!,listen: false).setVideoLoading(status: false);
        }else{
          Navigator.pop(context!);
        }
        UploadImageModel uploadImageModel = UploadImageModel.fromJson(json.decode(response));
        if (uploadImageModel.success!) {
          if(isVideoUploading){
            showToastMessage("Video uploaded successfully!");
          }
          returnType = uploadImageModel.result!.imageUrl!;
          print("returnType ===>  $returnType");

        } else {
          if(isVideoUploading){
            showToastMessage("Video not uploaded!");
          }
          showToastMessage(uploadImageModel.msg!);
        }
        Provider.of<LoadingProvider>(context,listen: false).setVideoLoading(status: false);
      });
    } else {
      Provider.of<LoadingProvider>(context!,listen: false).setVideoLoading(status: false);
      internetConnectionDialog(context);
    }
    return returnType!;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
