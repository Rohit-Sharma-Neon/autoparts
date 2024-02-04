import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/select_category/select_category.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import 'package:autoparts/main.dart';
import 'package:autoparts/provider/dashboard_provider.dart';
import 'package:autoparts/provider/location_provider.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:easy_localization/easy_localization.dart";
import "package:autoparts/constant/app_text_style.dart";
import "package:flutter/material.dart";
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  static const routeName = "/location";
  final bool isNewUser;
  final bool isSigningIn;
  final bool isSkipping;
  const LocationScreen({Key? key,this.isNewUser = false,this.isSigningIn = false,this.isSkipping = false}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  final GoogleMapsPlaces? _places = GoogleMapsPlaces(apiKey:  "AIzaSyArqlT_3Q9fHcisw6lvvUGTcObXGz3GEJk");
  String? address;

  @override
  void initState() {
    context.read<LocationProvider>().initialization();
    super.initState();
  }

  Future<void> getAddressFromLatLong(LocationData? locationData) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(locationData!.latitude!, locationData.longitude!);
    print(placeMarks);
    Placemark place = placeMarks[0];
    setState(() {
      address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
    print("address  =>  " + address.toString());
    sp!.putString(SpUtil.USER_ADDRESS, address.toString());
    sp!.putBool(SpUtil.IS_ADDRESS_GET, true);
    //showToastMessage("Address get successfully $address");
    // Navigator.pop(context);
    // Navigator.pushNamed(context, CarsCategoryScreen.routeName);
    if (widget.isNewUser) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const CarsCategoryScreen()), (route) => false);
    }else{
      if (widget.isSigningIn) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const CarsCategoryScreen()), (route) => false);
      }else if (widget.isSigningIn){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const CarsCategoryScreen()), (route) => false);
      }else{
        Navigator.pop(context);
      }
    }
  }

  displayPrediction(Prediction p,{bool isNewUser = true}) async {
    print("address  =>  " + address.toString());
    if (p != null) {
      print("address  =>  " + address.toString());
      PlacesDetailsResponse detail = await _places!.getDetailsByPlaceId(p.placeId!);

      var placeId = p.placeId;
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
      print(placeMarks);
      Placemark place = placeMarks[0];
      setState(() {
        address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
      print("address  =>  " + address.toString());
      print(lat);
      print(lng);
      sp!.putString(SpUtil.USER_ADDRESS, address.toString());
      //showToastMessage("Address get successfully $address");
      // Navigator.pushNamed(context, CarsCategoryScreen.routeName);
      if (isNewUser) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const CarsCategoryScreen()), (route) => false);
      }else{
        if (widget.isSigningIn) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const CarsCategoryScreen()), (route) => false);
        }else if (widget.isSigningIn){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const CarsCategoryScreen()), (route) => false);
        }else{
          Navigator.pop(context);
        }
      }
    }
  }

  Future<bool> _onWillPop() async {
    return widget.isNewUser ?
      (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          "confirmExit".tr(),
          style: AppTextStyles.boldStyle(
              AppFontSize.font_16, AppColors.blackColor),
        ),
        content: Text("doYouWantBuyBee".tr(),
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_14, AppColors.blackColor)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("no".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("yes".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
          ),
        ],
      ),
    )) ?? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop,
    child: Scaffold(
        body: _buildBody()));
  }

  _buildBody() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 16),
          !widget.isNewUser ? SizedBox() :
          _buildArrowBack(context),
          const SizedBox(height: 45),
          Image.asset(AppImages.locationMap),
          const SizedBox(height: 45),
          Text(
            "setLocation".tr(),
            textAlign: TextAlign.left,
            style: AppTextStyles.boldStyle(
                AppFontSize.font_24, AppColors.blackColor),
          ),
          const SizedBox(height: 16),
          Text("setLocationNext".tr(),
              textAlign: TextAlign.left,
              style: AppTextStyles.regularStyle(
                  AppFontSize.font_18, AppColors.blackColor)),
          const SizedBox(height: 10),
          Text("nearYou".tr(),
              textAlign: TextAlign.left,
              style: AppTextStyles.regularStyle(
                  AppFontSize.font_18, AppColors.blackColor)),
          const SizedBox(height: 30),
          InkWell(
            onTap: () {
              context.read<LocationProvider>().locationData != null ? getAddressFromLatLong(context.read<LocationProvider>().locationData)
                  : null;
            },
            child: SubmitButton(
              height: 50,
              value: "detectMyLocation".tr().toUpperCase(),
              color: AppColors.btnBlackColor,
              textStyle: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.whiteColor),
            ),
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () async{
              Prediction? p = await PlacesAutocomplete.show(
                  types: [],
                  onError: (val){
                    print("Below ---- >");
                    print(val);
                  },
                  context: context,
                  apiKey:  "AIzaSyArqlT_3Q9fHcisw6lvvUGTcObXGz3GEJk",
                  strictbounds: false,
                  components: []
              );
              displayPrediction(p!,isNewUser: widget.isNewUser);
            },
            child: SubmitButton(
              height: 50,
              value: "setLocationManually".tr().toUpperCase(),
              color: AppColors.brownColor,
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  _buildArrowBack(context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        height: 20,
        width: 25,
        child: Image.asset(AppImages.arrowBack),
      ),
    );
  }
}
