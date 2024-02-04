import "package:autoparts/app_ui/screens/privacy_screen/web_view_widget.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_strings.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
class PrivacyScreen extends StatelessWidget {
  static const routeName = "/privacy-policy";
  const PrivacyScreen({Key? key}) : super(key: key);
  static Future<String> get _url async {
    await Future.delayed(const Duration(seconds: 1));
    return "http://3.137.120.6/kpmain/page/privacy-policy";
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
        appBar: AppBar(
         backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(
                  context,
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  AppImages.arrowBack,
                  fit: BoxFit.fitWidth,
                  height: 20,
                ),
              )),
          title: Text("privacyPolicy".tr(),
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_22, AppColors.blackColor)),
        ),
        body: Center(
          child: FutureBuilder(
              future: _url,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                  snapshot.hasData
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: WebViewWidget(
                            url: snapshot.data,
                          ),
                      )
                      : const CircularProgressIndicator()),
        ),
      );
}