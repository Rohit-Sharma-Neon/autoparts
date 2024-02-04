import "dart:async";
import 'package:autoparts/app_ui/common_widget/otp_timer.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import 'package:provider/provider.dart';
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:pin_code_fields/pin_code_fields.dart";
import "package:shared_preferences/shared_preferences.dart";

class VerifyOtpScreen extends StatefulWidget {
  static const routeName = "/verify-otp";
  String phone, countryCode, otp;
  String? screenType;
  VerifyOtpScreen(
      {Key? key,
      required this.phone,
      required this.countryCode,
      this.screenType,
      required this.otp})
      : super(key: key);

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingControllerOTP = TextEditingController();
  String? otpValue = "";
  SharedPreferences? prefs;
  Timer? _timer;
  int _start = 59;
  bool _isButtonDisabled = false;


  @override
  void initState() {
    textEditingControllerOTP = TextEditingController(text: widget.otp);
    otpValue = widget.otp;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (BuildContext context, value, Widget? child) {
      textEditingControllerOTP.text = value.otp??"";
      return Scaffold(key: _scaffoldKey, body: _buildBody(value));
    }
    );
  }

  _buildBody(AuthProvider value) {
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
          Text("verifyNumber".tr(),
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_24, AppColors.blackColor)),
          const SizedBox(
            height: 10,
          ),
          Text("enterYourOTP".tr(),
              style: AppTextStyles.mediumStyle(
                  AppFontSize.font_18, AppColors.blackColor)),
          const SizedBox(
            height: 30,
          ),
          Text("OTP has been sent to ${widget.countryCode} ${widget.phone}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
          const SizedBox(
            height: 20,
          ),
          buildOTPField(),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              verifyOtp();
            },
            child: SubmitButton(
              height: 50,
              color: AppColors.btnBlackColor,
              value: "submitOTP".tr(),
              textColor: Colors.white,
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.whiteColor),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const OtpTimerWidget(),
        ],
      ),
    );
  }

  buildOTPField() {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Colors.green.shade600,
        fontWeight: FontWeight.bold,
      ),
      length: 4,
      blinkWhenObscuring: true,
      enabled: true,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 45,
          fieldWidth: 72,
          selectedColor: AppColors.blackColor,
          inactiveFillColor: AppColors.whiteColor,
          activeFillColor: AppColors.blackColor,
          activeColor: AppColors.borderColor,
          inactiveColor: AppColors.borderColor),
      cursorColor: Colors.black,
      enableActiveFill: false,
      controller: textEditingControllerOTP,
      keyboardType: TextInputType.number,
      onChanged: (v) {},
      onCompleted: (v) {
        print("Completed");
        setState(() {
          otpValue = v;
        });
      },
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

  verifyOtp() async {
    if (otpValue!.length < 3) {
      showToastMessage("Please enter otp.");
    } else {
      await context.read<AuthProvider>().verifyOtpApi(otpValue,screenType: widget.screenType??"");
    }
  }
}
