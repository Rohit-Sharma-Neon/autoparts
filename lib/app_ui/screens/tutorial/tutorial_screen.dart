import 'package:autoparts/app_ui/common_widget/animated_column.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/location/location_screen.dart';
import "package:autoparts/app_ui/screens/auth/login/login_screen.dart";
import "package:autoparts/app_ui/screens/auth/signup_screen/sign_up_screen.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/main.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:carousel_slider/carousel_slider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TutorialScreen extends StatefulWidget {
  static const  routeName = "/";
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _current = 0;
  List bannerList = [
    AppImages.tutorialCar,
    AppImages.tutorialCar,
    AppImages.tutorialCar,
    AppImages.tutorialCar,
  ];

  getFcm() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Token from tutorial class ---> "+token.toString());
    sp?.putString(SpUtil.FCM_TOKEN, token??"");
  }

  @override
  void initState() {
    getFcm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  _buildBody() {
    return SafeArea(
      child: AnimatedColumn(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
            child: Text(
              "tutorialTop".tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.mediumStyle(
                  AppFontSize.font_36, AppColors.blackColor),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
              child: Text("tutorialTopNext".tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regularStyle(
                      AppFontSize.font_22, AppColors.blackColor))),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              child: SubmitButton(
                height: 55,
                value: "login".tr().toUpperCase(),
                color: AppColors.btnBlackColor,
                textStyle: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.whiteColor),
              ),
            ),
          ),
          Container(
            margin:
            const EdgeInsets.only(left: 20, right: 20,),
            child: GestureDetector(
              onTap: () {
                // Navigator.pushNamedAndRemoveUntil(context, SignUpScreen.routeName, (route) => false);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpScreen()));
              },
              child: SubmitButton(
                height: 55,
                value: "signUp".tr().toUpperCase(),
                color: AppColors.brownColor,
                textStyle: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.whiteColor),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          _buildCarouselSlider(),
          Container(),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCarouselDot(),
                _buildSkipButton()
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
          autoPlay: true,
          height: 250,
          scrollDirection: Axis.horizontal,
          autoPlayCurve: Curves.ease,
          viewportFraction: 1.0,
          aspectRatio: 2.0,
          enlargeCenterPage: false,
          reverse: false,
          enableInfiniteScroll: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 4000),
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }),
      items: bannerList.map<Widget>((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.only(left: 15),
                width: double.infinity, child: Image.asset(i,
              fit: BoxFit.cover,
            ));
          },
        );
      }).toList(),
    );
  }

  _buildCarouselDot() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
            bannerList.length,
            (index) => Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: _current == index ? 16 : 12,
                  height: _current == index ? 16 : 12,
                  decoration: BoxDecoration(
                      color: _current == index
                          ? AppColors.brownColor
                          : AppColors.greyColor,
                      shape: BoxShape.circle),
                )));
  }

  _buildSkipButton() {
    return InkWell(
      onTap: (){
        // Navigator.pushNamed(context, LocationScreen.routeName);
        sp!.putBool(SpUtil.IS_LOGGED_IN,false);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LocationScreen(isSigningIn: true)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("skipText".tr().toUpperCase(),
              textAlign: TextAlign.center,
              style: AppTextStyles.mediumStyle(
                  AppFontSize.font_20, AppColors.brownColor)),
          const SizedBox(
            width: 10,
          ),
          Image.asset(
            AppImages.rightDoubleArrow,
            width: 30,
          ),
        ],
      ),
    );
  }
}
