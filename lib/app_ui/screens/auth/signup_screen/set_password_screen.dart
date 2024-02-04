import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/privacy_screen/terms_conditions_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:provider/src/provider.dart';

import '../../../../constant/app_strings.dart';

class SetPasswordScreen extends StatefulWidget {
  static const routeName = "/set-password";
  final String screenType;

  const SetPasswordScreen({Key? key,required this.screenType}) : super(key: key);

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  TextEditingController textEditingControllerPassword = TextEditingController();
  TextEditingController textEditingControllerConfirmPassword =
      TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _checkTerms = false;
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  _buildBody() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(
            height: 16,
          ),
          _buildArrowBack(),
          const SizedBox(
            height: 16,
          ),
          Text("setPassword".tr(),
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_24, AppColors.blackColor)),
          const SizedBox(
            height: 16,
          ),
          Text("enterYourPasswordLogin".tr(),
              style: AppTextStyles.regularStyle(
                  AppFontSize.font_18, AppColors.blackColor)),
          const SizedBox(
            height: 50,
          ),
          CustomRoundTextField(
            hintText: "enterPassword".tr(),
            //icon: Icon(Icons.lock, color: Colors.black54),
            isPassword: !_passwordVisible,
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
            height: 15,
          ),
          CustomRoundTextField(
            hintText: "confirmPassword".tr(),
            //icon: Icon(Icons.lock, color: Colors.black54),
            isPassword: !_confirmPasswordVisible,

            suffixIcon: IconButton(
              icon: Icon(
                  _confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppColors.greyColor),
              onPressed: () {
                setState(
                    () => _confirmPasswordVisible = !_confirmPasswordVisible);
              },
            ),
            fillColor: AppColors.whiteColor,
            controller: textEditingControllerConfirmPassword,
            onChanged: (text) {},
          ),
          const SizedBox(
            height: 15,
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
                  value: _checkTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _checkTerms = value!;
                      _isButtonDisabled = !_isButtonDisabled;
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              RichText(
                text: TextSpan(
                  text: "iAccept".tr(),
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_16, AppColors.blackColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: "termsConditions".tr(),
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.brownColor,
                            decorationThickness: 2,
                            decorationStyle: TextDecorationStyle.solid,
                            fontSize: AppFontSize.font_16,
                            color: AppColors.brownColor,
                            fontFamily: "Roboto",
                            fontWeight: AppFontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              StaticPage(headingName: "termsConditions".tr(),type: "terms-of-use",)))),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              _isButtonDisabled
                  ? signUpApi(screenType: widget.screenType)
                  : showToastMessage("Please accept terms & conditions");
            },
            child: SubmitButton(
              height: 50,
              color: _isButtonDisabled
                  ? AppColors.btnBlackColor
                  : AppColors.greyColor,
              value: "next".tr(),
              textColor: Colors.white,
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  _buildArrowBack() {
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

  signUpApi({required String screenType}) async {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
    if(textEditingControllerPassword.text.isEmpty){
      showToastMessage("Please enter password");
    }else if(!regex.hasMatch(textEditingControllerPassword.text.trim())){
      // errorDialog(context, title: "Password should contain:\n•One upper case\n•One lower case\n•One digit\n•One Special character\n•6 characters in length ");
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
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
                      children: [
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Password should contain:",
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.w500)),
                                SizedBox(height: 6),
                                Text("•One upper case\n•One lower case\n•One digit\n•One Special character\n•6 characters in length",
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.w400))
                              ],
                            )),
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
    }else if(textEditingControllerConfirmPassword.text.isEmpty){
      showToastMessage("Please enter confirm password");
    }else if(textEditingControllerPassword.text != textEditingControllerConfirmPassword.text){
      showToastMessage('Password and confirm password are not same.');
      return false ;
    }else{
        await context.read<AuthProvider>().signupApi(textEditingControllerPassword.text, screenType: screenType);
      }
    }
    // if (textEditingControllerPassword.text.isEmpty) {
    //   showToastMessage("Please enter password");
    // } else if (textEditingControllerPassword.text !=
    //     textEditingControllerConfirmPassword.text) {
    //   showToastMessage('Password and confirm password are not same.');
    //   return false;
    // } else {
    //   await context.read<AuthProvider>().signupApi(textEditingControllerPassword.text);
    // }
  }

