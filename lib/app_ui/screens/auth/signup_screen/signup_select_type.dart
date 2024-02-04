import 'package:autoparts/app_ui/screens/auth/signup_screen/sign_up_screen.dart';
import 'package:autoparts/app_ui/screens/business_profile/business_profile_screen.dart';
import 'package:autoparts/app_ui/screens/user_profile/complete_profile_screen.dart';
import 'package:autoparts/constant/app_colors.dart';
import 'package:autoparts/constant/app_image.dart';
import 'package:autoparts/constant/app_text_style.dart';
import 'package:autoparts/main.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SignupSelectType extends StatelessWidget {
  static const routeName = "/sign-up-select-type";
  const SignupSelectType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      )) ??
          false;
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(
            height: 16,
          ),
          // _buildArrowBack(context),
          const SizedBox(
            height: 16,
          ),
          const SizedBox(
            height: 50,
          ),
          Image.asset(AppImages.mobileLogin),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
              onTap: () {
                sp!.putString(SpUtil.USER_TYPE,"Individual");
                sp!.putBool(SpUtil.IS_USERTYPE_SELECTED, true);
                // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const CompleteProfileScreen(isNewUser: true,)));
              },
              child: _buildSelectTypeButton(
                  AppImages.individualIcon, "individual".tr())),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                sp!.putString(SpUtil.USER_TYPE,"Dealer");
                sp!.putBool(SpUtil.IS_USERTYPE_SELECTED, true);
                // Navigator.pushNamed(context, BusinessProfileScreen.routeName);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const BusinessProfileScreen(isNewUser: true,)));
              },
              child: _buildSelectTypeButton(
                  AppImages.businessIcon, "business".tr())),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _buildSelectTypeButton(icon, name) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(flex: 2, child: Image.asset(icon)),
            const SizedBox(width: 20),
            Expanded(
              flex: 6,
              child: Text(name,
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_26, AppColors.blackColor)),
            ),
            const Expanded(
                flex: 1,
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 35,
                  color: AppColors.brownColor,
                ))
          ],
        ),
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
