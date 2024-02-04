import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../../constant/app_strings.dart';
class ChangePasswordScreen extends StatefulWidget {
  static const routeName = "/change-password";
  const ChangePasswordScreen({Key? key}) : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}
class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _oldPasswordVisible = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   AppColors.whiteColor,
        body: _buildBody());
  }
  _buildBody() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          customAppbar(),
          const SizedBox(
            height: 50,
          ),
          CustomRoundTextField(
            hintText: "oldPassword".tr(),
            //icon: Icon(Icons.lock, color: Colors.black54),
            isPassword: !_oldPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                  _oldPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.greyColor),
              onPressed: () {
                setState(() => _oldPasswordVisible = !_oldPasswordVisible);
              },
            ),
            fillColor: AppColors.whiteColor,
            controller: oldPasswordController,
            onChanged: (text) {},
          ),
          const SizedBox(
            height: 15,
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
            controller: passwordController,
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
                  _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.greyColor),
              onPressed: () {
                setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
              },
            ),
            fillColor: AppColors.whiteColor,
            controller: confirmPasswordController,
            onChanged: (text) {},
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              changePassword();
            },
            child: SubmitButton(
              height: 50,
              color: AppColors.blackColor,
              value: "changePassword".tr(),
              textColor: Colors.white,
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }
  customAppbar() {
    return SafeArea(
      child: Container(
          color: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric( vertical: 16),
          child: Row(children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Image.asset(
                      AppImages.arrowBack,
                      fit: BoxFit.contain,
                      height: 20,
                    )),
                const SizedBox(width: 20),
                Text("changePassword".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_22, AppColors.blackColor)),
              ],
            ),
          ])),
    );
  }

  changePassword() async {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
    if(oldPasswordController.text.isEmpty){
      showToastMessage("Please enter old password");
    }else if(passwordController.text.isEmpty){
      showToastMessage("Please enter password");
    }else if(!regex.hasMatch(passwordController.text.trim())){
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
    }else if(confirmPasswordController.text.isEmpty){
      showToastMessage("Please enter confirm password");
    }else if(passwordController.text != confirmPasswordController.text){
      showToastMessage('Password and confirm password are not same.');
      return false;
    }else {
      await context.read<UserProvider>().changePasswordApi(oldPasswordController.text,passwordController.text);
    }
  }
  // changePassword() async {
  //   if (oldPasswordController.text.isEmpty) {
  //     showToastMessage("Please enter old password");
  //   }if (passwordController.text.isEmpty) {
  //     showToastMessage("Please enter password");
  //   } else if (passwordController.text !=
  //       confirmPasswordController.text) {
  //     showToastMessage(
  //         'Password and confirm password are not same.');
  //     return false;
  //   }else {
  //     await context.read<UserProvider>().changePasswordApi(oldPasswordController.text,passwordController.text);
  //   }
  // }
}