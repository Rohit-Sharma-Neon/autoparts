import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:autoparts/app_ui/common_widget/animated_column.dart';
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/auth/forgot_password/forgot_password_phone.dart';
import 'package:autoparts/app_ui/screens/auth/signup_screen/sign_up_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/main.dart';
import 'package:autoparts/provider/auth_provider.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:country_code_picker/country_code_picker.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:provider/src/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textEditingControllerPassword = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool _passwordVisible = false;
  String? countryCode;
  bool? rememberMe;

  @override
  void initState() {
    super.initState();
    getCredentials();
    countryCode = (sp?.getString(SpUtil.COUNTRY_CODE)??"+971")??"+971";
    rememberMe = (sp?.getBool(SpUtil.REMEMBER_ME)??false);
    Future.microtask(() {
      context.read<AuthProvider>().init();
    });
  }

  getCredentials() {
    mobileNumberController.text = sp!.getString(SpUtil.USER_MOBILE)??"";
    textEditingControllerPassword.text = sp!.getString(SpUtil.LOGIN_PASSWORD) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FadeInUp(
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SignUpScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "dontHaveAccount".tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mediumStyle(
                      15, AppColors.blackColor),
                ),
                const SizedBox(width: 3),
                Text(
                  "signUp".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.brownColor,decoration: TextDecoration.underline,fontSize: 15,fontWeight: AppFontWeight.medium,fontFamily: "Roboto"),
                ),
              ],
            ),
          ),
        ),
      ),
        body: _buildBody());
  }

  _buildBody() {
    return SafeArea(
      child: AnimatedColumn(
        children: [
          _buildArrowBack(),
          const SizedBox(
            height: 16,
          ),
          Text("welcomeText".tr(),
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_24, AppColors.blackColor)),
          const SizedBox(
            height: 10,
          ),
          Text("signIn".tr(),
              style: AppTextStyles.regularStyle(
                  AppFontSize.font_18, AppColors.blackColor)),
          const SizedBox(
            height: 40,
          ),
          _buildCountryPicker(),
          const SizedBox(
            height: 20,
          ),
          CustomRoundTextField(
            hintText: "enterPassword".tr(),
            //icon: Icon(Icons.lock, color: Colors.black54),
            isPassword: !_passwordVisible,
            inputFormatters: [],
            focusNode: passwordFocusNode,
            suffixIcon: IconButton(
              icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.greyColor),
              onPressed: () {
                setState(() => _passwordVisible = !_passwordVisible);
              },
            ),
            fillColor: AppColors.whiteColor,
            controller: textEditingControllerPassword,
            onChanged: (text) {},
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  activeColor: AppColors.brownColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  side: const BorderSide(
                      width: 1.5, color: AppColors.borderColor),
                  value: rememberMe,
                  onChanged: (bool? value) {
                    rememberMe = value;
                    context.read<AuthProvider>().setRememberMe(value);
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "rememberMe".tr(),
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              doLogin();
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
            height: 25,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, ForgotPasswordPhone.routeName);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPasswordPhone()));
            },
            child: Text(
              "forgotPassword".tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.mediumStyle(
                  AppFontSize.font_18, AppColors.brownColor),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppColors.borderColor,
                width: 70,
                height: 2,
              ),
              Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: Text(
                  "orText".tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_14, AppColors.blackColor),
                ),
              ),
              Container(
                color: AppColors.borderColor,
                width: 70,
                height: 2,
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    context.read<AuthProvider>().twitterSignInFunction();
                  },
                  child: Image.asset(
                    AppImages.loginTwitter,
                    fit: BoxFit.fitHeight,
                    height: 45,
                    width: 45,
                  )),
              Platform.isIOS
                  ? const SizedBox(width: 15)
                  : const SizedBox(width: 0),
              Platform.isIOS
                  ? GestureDetector(
                      onTap: () {
                        context.read<AuthProvider>().appleSignInFunction();
                      },
                      child: Image.asset(
                        AppImages.loginApple,
                        fit: BoxFit.fitHeight,
                        height: 45,
                        width: 45,
                      ))
                  : const SizedBox(),
              const SizedBox(width: 15),
              GestureDetector(
                  onTap: () {
                    context.read<AuthProvider>().facebookSignInFunction();
                  },
                  child: Image.asset(
                    AppImages.loginFacebook,
                    fit: BoxFit.fitHeight,
                    height: 45,
                    width: 45,
                  )),
              const SizedBox(width: 15),
              GestureDetector(
                  onTap: () {
                    context.read<AuthProvider>().googleSignInFunction();
                  },
                  child: Image.asset(
                    AppImages.loginGoogle,
                    fit: BoxFit.fitHeight,
                    height: 45,
                    width: 45,
                  )),
            ],
          ),
          const SizedBox(height: 30),
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
                FocusScope.of(context).unfocus();
                setState(() {
                  sp!.putString(SpUtil.COUNTRY_CODE, p.dialCode??"");
                  countryCode = p.dialCode??"";
                });
              },
              // Initial selection and favorite can be one of code ("IT") OR dial_code("+39")
              initialSelection: countryCode,
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
      maxLength: 13,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
      ],
      focusNode: mobileFocusNode,
      controller: mobileNumberController,
      keyboardType: TextInputType.number,
      style:
          AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.blackColor),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "mobileNumberHint".tr(),
          helperStyle: AppTextStyles.mediumStyle(
              AppFontSize.font_16, AppColors.hintTextColor),
          counterText: ""),
    );
  }

  _buildArrowBack() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        alignment: Alignment.bottomLeft,
        height: 20,
        width: 25,
        child: Image.asset(AppImages.arrowBack),
      ),
    );
  }

  doLogin() async {
    if (mobileNumberController.text.isEmpty) {
      showToastMessage("Please enter mobile number.");
      FocusScope.of(context).requestFocus(mobileFocusNode);
    } else if (textEditingControllerPassword.text.isEmpty) {
      showToastMessage("Please enter password.");
      FocusScope.of(context).requestFocus(passwordFocusNode);
    } else {
      if(rememberMe??false){
        context.read<AuthProvider>().setPhoneNumber(mobileNumberController.text);
        context.read<AuthProvider>().setCountryCode(countryCode);
        sp!.putString(SpUtil.USER_MOBILE, mobileNumberController.text);
        sp!.putString(SpUtil.COUNTRY_CODE, countryCode??"+971");
        sp!.putString(SpUtil.LOGIN_PASSWORD, textEditingControllerPassword.text);
        sp!.putBool(SpUtil.REMEMBER_ME, rememberMe??true);
      }else{
        context.read<AuthProvider>().setPhoneNumber(mobileNumberController.text);
        context.read<AuthProvider>().setCountryCode(countryCode);
        sp!.putString(SpUtil.USER_MOBILE, "");
        sp!.putString(SpUtil.COUNTRY_CODE, "+971");
        sp!.putString(SpUtil.LOGIN_PASSWORD, "");
        sp!.putBool(SpUtil.REMEMBER_ME, rememberMe??false);
      }
      await context.read<AuthProvider>().loginApi(textEditingControllerPassword.text);
    }
  }
}
