import 'package:flutter/cupertino.dart';

class LoadingProvider extends ChangeNotifier{
  bool? isHomeLoading;
  bool? isVideoUploading;
  setHomeLoading({required bool status}){
    isHomeLoading = status;
    notifyListeners();
  }

  setVideoLoading({required bool status}){
    isVideoUploading = status;
    notifyListeners();
  }
}