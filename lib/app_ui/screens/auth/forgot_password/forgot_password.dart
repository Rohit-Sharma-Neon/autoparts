import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = "/forgot-password";
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController textEditingControllerPassword = TextEditingController();
  TextEditingController textEditingControllerConfirmPassword =
  TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

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
          Text("resetPassword".tr(),
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_24, AppColors.blackColor)),
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
                  _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.greyColor),
              onPressed: () {
                setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
              },
            ),
            fillColor: AppColors.whiteColor,
            controller: textEditingControllerConfirmPassword,
            onChanged: (text) {},
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              resetPasswordApi();
            },
            child: SubmitButton(
              height: 50,
              color: AppColors.btnBlackColor,
              value: "resetPassword".tr(),
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

  resetPasswordApi() async {
    if (textEditingControllerPassword.text.isEmpty) {
      showToastMessage("Please enter password");
    } else if (textEditingControllerPassword.text !=
        textEditingControllerConfirmPassword.text) {
      showToastMessage(
          'Password and confirm password are not same.');
      return false;
    }else {
     await context.read<AuthProvider>().forgotPasswordApi(textEditingControllerPassword.text);
    }
  }

}
