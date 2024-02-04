import 'dart:async';

import 'package:autoparts/constant/app_colors.dart';
import 'package:autoparts/constant/app_text_style.dart';
import 'package:autoparts/provider/auth_provider.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class OtpTimerWidget extends StatefulWidget {
  const OtpTimerWidget({Key? key}) : super(key: key);

  @override
  State<OtpTimerWidget> createState() => _OtpTimerWidgetState();
}

class _OtpTimerWidgetState extends State<OtpTimerWidget> {

  Timer? _timer;
  int _start = 59;
  bool _isButtonDisabled = false;

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() async {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 2) {
            timer.cancel();
            _isButtonDisabled = true;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void reSendOTP() async {
    await context.read<AuthProvider>().sendOtpApi(type: "resendOtp");
    setState(() {
      _start = 59;
      _isButtonDisabled = false;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _isButtonDisabled ? reSendOTP : null,
          child: SizedBox(
            width: 200,
            height: 20,
            child: Text("resendOTP".tr(),
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_18,
                    _isButtonDisabled
                        ? AppColors.brownColor
                        : AppColors.greyColor)),
          ),
        ),
        Center(
          child: Text(
            "00:${_start == 1 ? "00" : _start < 10 ? "0$_start" : _start}s",
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_18, AppColors.greyColor),
          ),
        ),
      ],
    );
  }
}
