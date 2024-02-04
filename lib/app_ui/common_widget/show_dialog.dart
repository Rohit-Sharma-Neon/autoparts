import 'package:autoparts/app_ui/screens/auth/login/login_screen.dart';
import 'package:autoparts/app_ui/screens/tutorial/tutorial_screen.dart';
import 'package:autoparts/constant/app_colors.dart';
import 'package:autoparts/constant/app_strings.dart';
import 'package:autoparts/constant/app_text_style.dart';
import 'package:autoparts/provider/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../constant/app_image.dart';

void showToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      //message to show toast
      toastLength: Toast.LENGTH_LONG,
      //duration for message to show
      gravity: ToastGravity.CENTER,
      //where you want to show, top, bottom
      timeInSecForIosWeb: 1,
      //for iOS only
      backgroundColor: AppColors.btnBlackColor,
      //background Color for message
      textColor: AppColors.whiteColor,
      //message text color
      fontSize: 16.0 //message font size
      );
}

showLoader(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const WillPopScope(
        onWillPop: _onWillPop,
        child: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.blackColor),
            ),
          ),
        ),
      );
    },
  );
}

Future<bool> _onWillPop() async {
  return false;
}

doLogOut(context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        "appTitle".tr(),
        style:
            AppTextStyles.boldStyle(AppFontSize.font_16, AppColors.blackColor),
      ),
      content: Text("areYouLogout".tr(),
          style: AppTextStyles.mediumStyle(
              AppFontSize.font_14, AppColors.blackColor)),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("no".tr(),
              style: AppTextStyles.boldStyle(AppFontSize.font_16, AppColors.blackColor)),
        ),
        TextButton(
          onPressed: () => context.read<AuthProvider>().logoutApi(),
          child: Text("yes".tr(), style: AppTextStyles.boldStyle(AppFontSize.font_16, AppColors.blackColor)),
        ),
      ],
    ),
  );
}

pleaseLogin(context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        "appTitle".tr(),
        style:
            AppTextStyles.boldStyle(AppFontSize.font_16, AppColors.blackColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Image.asset(
              AppImages.buyBeeLogo,
            ),
          ),
          const SizedBox(height: 8),
          Text("createAnAccount".tr(),
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 5),
          child: SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                // Navigator.pushReplacementNamed(context, TutorialScreen.routeName);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const TutorialScreen()),
                        (route) => false);
              },
              child: Text("createAccountOr".tr(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                primary: AppColors.brownColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

internetConnectionDialog(context) {
  Widget okButton = InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text("OK".tr(),
            style: const TextStyle(fontSize: 20, color: Colors.white)),
      ),
    ),
  );
  Dialog alert = Dialog(
    backgroundColor: Colors.transparent,
    // contentPadding: EdgeInsets.zero,
    insetPadding: EdgeInsets.zero,
    child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Lottie.asset(
                'assets/nointernet.json',
                repeat: true,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20),
            okButton
          ],
        )),
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

errorDialog(BuildContext context, {required String title, Function()? onTap}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(AppStrings.appTitle,
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500))),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 25),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.brownColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("OK".tr(),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
              ],
            )),
      );
    },
  );
}

showActionDialog(BuildContext context, String message, Function()? onPressed,
    {Function()? onNoPressed}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        AppStrings.appTitle,
        style: AppTextStyles.boldStyle(AppFontSize.font_16, AppColors.blackColor),
      ),
      content: Text(message,
          style: AppTextStyles.mediumStyle(
              AppFontSize.font_14, AppColors.blackColor)),
      actions: <Widget>[
        TextButton(
          onPressed: onNoPressed == null ? () => Navigator.of(context).pop(false) : onNoPressed,
          child: Text("no".tr(),
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_16, AppColors.blackColor)),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text("yes".tr(),
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_16, AppColors.blackColor)),
        ),
      ],
    ),
  );
}
