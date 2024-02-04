import 'package:animate_do/animate_do.dart';
import 'package:autoparts/app_ui/common_widget/animated_column.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/auth/login/login_screen.dart';
import 'package:autoparts/app_ui/screens/location/location_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/auth_provider.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:country_code_picker/country_code_picker.dart";
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:provider/provider.dart';

import '../../../../main.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/sign-up";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<SignUpScreen> {
  TextEditingController mobileController = TextEditingController();
  FocusNode mobileFocusNode = FocusNode();
  String? countryCode;
  

  @override
  void initState() {
    super.initState();
    countryCode = "+971";
    Future.microtask(() {
      context.read<AuthProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FadeInUp(
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "alreadyHaveAccount".tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mediumStyle(
                      15, AppColors.blackColor),
                ),
                const SizedBox(width: 3),
                Text(
                  "sign_in".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.brownColor,decoration: TextDecoration.underline,fontSize: 15,fontWeight: AppFontWeight.medium,fontFamily: "Roboto"),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(),
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

  _buildBody() {
    return SafeArea(
      child: AnimatedColumn(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(
            height: 16,
          ),
          _buildArrowBack(context),
          const SizedBox(
            height: 32,
          ),
          Text("getStarted".tr(),
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_24, AppColors.blackColor)),
          const SizedBox(
            height: 10,
          ),
          Text("enterYourMobileNumber".tr(),
              style: AppTextStyles.regularStyle(
                  AppFontSize.font_18, AppColors.blackColor)),
          const SizedBox(
            height: 50,
          ),
          _buildCountryPicker(),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              sentOtp();
            },
            child: SubmitButton(
              height: 50,
              color: AppColors.btnBlackColor,
              value: "continueText".tr(),
              textColor: Colors.white,
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.whiteColor),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          _buildSkipButton()
        ],
      ),
    );
  }



  _buildCountryPicker() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor, width: 2)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CountryCodePicker(
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.blackColor),
              flagWidth: 30,
              padding: const EdgeInsets.all(0),
              onChanged: (p) {
                print("Country Code ::: >  " + p.toString());
                setState(() {
                  countryCode = p.toString();
                });
                FocusScope.of(context).unfocus();
              },
              // Initial selection and favorite can be one of code ("IT") OR dial_code("+39")
              initialSelection: "+971",

              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            color: AppColors.borderColor,
            width: 2,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(flex: 8, child: _buildTextField())
        ],
      ),
    );
  }

  _buildTextField() {
    return TextField(
      // autofocus: true,
      maxLength: 13,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
      ],
      focusNode: mobileFocusNode,
      controller: mobileController,
      keyboardType: TextInputType.number,
      cursorHeight: 20,
      style: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.blackColor),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "mobileNumberHint".tr(),
          helperStyle: AppTextStyles.mediumStyle(
              AppFontSize.font_16, AppColors.hintTextColor),
          counterText: ""),
    );
  }

  _buildSkipButton() {
    return InkWell(
      onTap: () {
        sp!.putBool(SpUtil.IS_LOGGED_IN,false);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LocationScreen(isSigningIn: true)));

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("skipText".tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.mediumStyle(
                  AppFontSize.font_18, AppColors.brownColor)),
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

  sentOtp() async {
    if (mobileController.text.isEmpty) {
      showToastMessage("Please enter mobile number.");
      FocusScope.of(context).requestFocus(mobileFocusNode);
    } else if(mobileController.text.length < 8){
      showToastMessage("Mobile number can't be less then 8 digits");
      FocusScope.of(context).requestFocus(mobileFocusNode);
    } else {
      context.read<AuthProvider>().setPhoneNumber(mobileController.text);
      context.read<AuthProvider>().setCountryCode(countryCode);
      await context.read<AuthProvider>().sendOtpApi(type: "register");
    }
  }
}
